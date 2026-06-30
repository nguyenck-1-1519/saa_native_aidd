import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/stub_secret_box_repository.dart';
import '../../domain/entities/secret_box_reward.dart';
import '../../domain/entities/secret_box_state.dart';
import '../../domain/repositories/secret_box_repository.dart';
import '../../domain/usecases/get_secret_box_state.dart';
import '../../domain/usecases/open_secret_box.dart';
import '../../domain/value_objects/secret_box_phase.dart';

// ---------------------------------------------------------------------------
// Repository DI — SINGLE shared instance; INT reads stats from here too
// ---------------------------------------------------------------------------

/// Shared [SecretBoxRepository] instance.
///
/// INT must derive the unopened-count feed stat from this provider so the
/// Kudos feed and the Secret Box screen never desync.
final secretBoxRepositoryProvider = Provider<SecretBoxRepository>(
  (_) => StubSecretBoxRepository(),
);

// ---------------------------------------------------------------------------
// Usecase DI
// ---------------------------------------------------------------------------

final getSecretBoxStateProvider = Provider<GetSecretBoxState>(
  (ref) => GetSecretBoxState(ref.watch(secretBoxRepositoryProvider)),
);

final openSecretBoxProvider = Provider<OpenSecretBox>(
  (ref) => OpenSecretBox(ref.watch(secretBoxRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// SecretBoxState snapshot — FutureProvider (read-only, no retry needed)
// ---------------------------------------------------------------------------

final secretBoxStateProvider = FutureProvider<SecretBoxState>(
  (ref) => ref.watch(getSecretBoxStateProvider).call(),
);

// ---------------------------------------------------------------------------
// UI state — drives the closed → opening → revealed state machine
// ---------------------------------------------------------------------------

/// Immutable UI state held by [SecretBoxController].
class SecretBoxUiState {
  const SecretBoxUiState({
    this.phase = SecretBoxPhase.closed,
    this.unopenedCount = 0,
    this.reward,
    this.errorMessage,
  });

  final SecretBoxPhase phase;

  /// Remaining boxes — kept in sync after every successful draw.
  final int unopenedCount;

  /// Non-null when [phase] is [SecretBoxPhase.revealed].
  final SecretBoxReward? reward;

  /// Non-null when an error occurred during open; [phase] is reset to closed.
  final String? errorMessage;

  SecretBoxUiState copyWith({
    SecretBoxPhase? phase,
    int? unopenedCount,
    SecretBoxReward? reward,
    String? errorMessage,
    bool clearReward = false,
    bool clearError = false,
  }) {
    return SecretBoxUiState(
      phase: phase ?? this.phase,
      unopenedCount: unopenedCount ?? this.unopenedCount,
      reward: clearReward ? null : (reward ?? this.reward),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ---------------------------------------------------------------------------
// SecretBoxController — Notifier<SecretBoxUiState>
// ---------------------------------------------------------------------------

/// Drives the Secret Box phase state machine.
///
/// Public API (consumed by the screen widget and integration layer):
///
///   [open()]              — guard count > 0; set phase opening.
///   [onOpeningComplete()] — called by the UI when the opening animation
///                           finishes; applies the draw, stores the reward,
///                           advances phase to revealed.
///   [close()]             — return to closed/idle; clears reward + error.
///
/// Exposed state fields:
///   [SecretBoxUiState.unopenedCount] — live count after each draw.
///   [SecretBoxUiState.phase]         — current phase.
///   [SecretBoxUiState.reward]        — last drawn reward (kind + name + assetRef).
class SecretBoxController extends Notifier<SecretBoxUiState> {
  @override
  SecretBoxUiState build() {
    // Seed the unopened count from the repository's initial state so the
    // count widget is correct before the first draw.
    _initCount();
    return const SecretBoxUiState();
  }

  /// Asynchronously seeds [SecretBoxUiState.unopenedCount] from the repo.
  Future<void> _initCount() async {
    try {
      final s = await ref.read(getSecretBoxStateProvider).call();
      state = state.copyWith(unopenedCount: s.unopenedCount);
    } catch (_) {
      // Non-fatal: count stays 0; the user will see the none-left state.
    }
  }

  /// Transitions closed → opening.
  ///
  /// Guards against:
  ///   - double-tap while opening is in flight
  ///   - tapping when no boxes remain
  void open() {
    if (state.phase == SecretBoxPhase.opening) return;
    if (state.unopenedCount <= 0) return;

    state = state.copyWith(
      phase: SecretBoxPhase.opening,
      clearError: true,
    );
  }

  /// Called by the UI when the opening animation completes.
  ///
  /// Applies the draw via the repository, stores the reward, and advances
  /// phase to [SecretBoxPhase.revealed].  On error, resets to closed with
  /// an error message so the double-tap guard is never left locked.
  Future<void> onOpeningComplete() async {
    // Only act if we are actually in the opening phase (guard spurious calls).
    if (state.phase != SecretBoxPhase.opening) return;

    try {
      final result = await ref.read(openSecretBoxProvider).call();

      // Invalidate the state snapshot so kudosStatsProvider reflects the
      // new count immediately after a successful draw.
      ref.invalidate(secretBoxStateProvider);

      state = state.copyWith(
        phase: SecretBoxPhase.revealed,
        unopenedCount: result.nextState.unopenedCount,
        reward: result.reward,
      );
    } catch (e) {
      // Catch both Exception and Error subclasses so that any throwable
      // (e.g. StateError, LateInitializationError) resets phase to closed
      // instead of leaving the double-tap guard locked in `opening` forever.
      state = SecretBoxUiState(
        phase: SecretBoxPhase.closed,
        unopenedCount: state.unopenedCount,
        errorMessage: e.toString(),
      );
    }
  }

  /// Returns to [SecretBoxPhase.closed], clearing reward and error.
  void close() {
    state = SecretBoxUiState(
      phase: SecretBoxPhase.closed,
      unopenedCount: state.unopenedCount,
    );
  }

  /// Alias for [close] — kept for backwards compatibility with existing tests.
  void reset() => close();
}

final secretBoxControllerProvider =
    NotifierProvider<SecretBoxController, SecretBoxUiState>(
  SecretBoxController.new,
);

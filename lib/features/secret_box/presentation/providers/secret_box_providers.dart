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
    this.reward,
    this.errorMessage,
  });

  final SecretBoxPhase phase;

  /// Non-null when [phase] is [SecretBoxPhase.revealed].
  final SecretBoxReward? reward;

  /// Non-null when an error occurred during open; [phase] is reset to closed.
  final String? errorMessage;

  SecretBoxUiState copyWith({
    SecretBoxPhase? phase,
    SecretBoxReward? reward,
    String? errorMessage,
    bool clearReward = false,
    bool clearError = false,
  }) {
    return SecretBoxUiState(
      phase: phase ?? this.phase,
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
/// Exposes [open] (closed → opening → revealed) and [reset] (any → closed).
/// On error during [open], state returns to closed with [SecretBoxUiState.errorMessage].
class SecretBoxController extends Notifier<SecretBoxUiState> {
  @override
  SecretBoxUiState build() => const SecretBoxUiState();

  /// Transitions: closed → opening → revealed (on success)
  ///               or  → closed with errorMessage (on failure).
  Future<void> open() async {
    if (state.phase == SecretBoxPhase.opening) return; // guard double-tap

    state = state.copyWith(
      phase: SecretBoxPhase.opening,
      clearError: true,
    );

    try {
      final reward = await ref.read(openSecretBoxProvider).call();
      // Invalidate the state snapshot so unopenedCount and kudosStatsProvider
      // reflect the new counts immediately after a successful open.
      ref.invalidate(secretBoxStateProvider);
      state = state.copyWith(
        phase: SecretBoxPhase.revealed,
        reward: reward,
      );
    } catch (e) {
      // Catch both Exception and Error subclasses so that any throwable
      // (e.g. StateError, LateInitializationError) resets phase to closed
      // instead of leaving the double-tap guard locked in `opening` forever.
      state = SecretBoxUiState(
        phase: SecretBoxPhase.closed,
        errorMessage: e.toString(),
      );
    }
  }

  /// Returns to [SecretBoxPhase.closed], clearing reward and error.
  void reset() {
    state = const SecretBoxUiState();
  }
}

final secretBoxControllerProvider =
    NotifierProvider<SecretBoxController, SecretBoxUiState>(
  SecretBoxController.new,
);

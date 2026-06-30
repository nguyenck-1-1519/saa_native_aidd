import 'dart:async';
import 'dart:math';

import '../../../../core/error/failures.dart';
import '../../domain/entities/secret_box_reward.dart';
import '../../domain/entities/secret_box_state.dart';
import '../../domain/repositories/secret_box_repository.dart';
import '../../domain/usecases/draw_secret_box_reward.dart';
import '../sources/secret_box_mock_data.dart';

/// Deterministic, delay-free [SecretBoxRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific scenario:
///   - `.empty()`         → 7 unopened boxes, seeded draw via [Random(0)]
///   - `.none()`          → 0 unopened boxes (FR8 none-left state)
///   - `.error()`         → throws [UnknownFailure] immediately
///   - `.throwingError()` → throws a Dart [StateError] on draw()
///   - `.loading()`       → never resolves — pins the provider in loading state
class FakeSecretBoxRepository implements SecretBoxRepository {
  FakeSecretBoxRepository._({
    required Future<SecretBoxState> Function() stateHandler,
    required Future<DrawResult> Function() drawHandler,
  })  : _stateHandler = stateHandler,
        _drawHandler = drawHandler;

  /// Normal draw flow — deterministic [Random(0)], 7 boxes, full icon pool.
  ///
  /// A single seeded RNG is created once and used for every draw, so the
  /// sequence is reproducible across test runs.
  factory FakeSecretBoxRepository.empty() {
    var state = SecretBoxMockData.initialState;
    final usecase = DrawSecretBoxReward(
      iconPool: SecretBoxMockData.iconRewards,
      giftReward: SecretBoxMockData.giftReward,
    );
    final rng = Random(0);

    return FakeSecretBoxRepository._(
      stateHandler: () async => state,
      drawHandler: () async {
        final result = usecase(state, random: rng);
        state = result.nextState;
        return result;
      },
    );
  }

  /// 0 unopened boxes — exercises the none-left (FR8) path.
  factory FakeSecretBoxRepository.none() {
    return FakeSecretBoxRepository._(
      stateHandler: () async => const SecretBoxState(
        unopenedCount: 0,
        openedRewards: [],
      ),
      drawHandler: () async =>
          throw const UnknownFailure('Fake: no boxes remaining'),
    );
  }

  /// All calls throw [UnknownFailure].
  factory FakeSecretBoxRepository.error() {
    return FakeSecretBoxRepository._(
      stateHandler: () async =>
          throw const UnknownFailure('Fake: simulated secret box fetch error'),
      drawHandler: () async =>
          throw const UnknownFailure('Fake: simulated secret box open error'),
    );
  }

  /// draw() throws a Dart [StateError] (not an Exception).
  ///
  /// Used to verify that the controller catch-all (`catch (e)`) handles
  /// non-Exception throwables and still resets phase → closed.
  factory FakeSecretBoxRepository.throwingError() {
    return FakeSecretBoxRepository._(
      stateHandler: () async => const SecretBoxState(
        unopenedCount: 1,
        openedRewards: [],
      ),
      drawHandler: () async => throw StateError('Fake: unexpected Dart Error'),
    );
  }

  /// Returns futures that never complete — pins the provider in loading state.
  factory FakeSecretBoxRepository.loading() {
    return FakeSecretBoxRepository._(
      stateHandler: () => Completer<SecretBoxState>().future,
      drawHandler: () => Completer<DrawResult>().future,
    );
  }

  /// Single-reward fake for widget tests that need a predictable reward value.
  ///
  /// Returns [reward] on the first draw; subsequent draws throw [UnknownFailure].
  factory FakeSecretBoxRepository.withReward(SecretBoxReward reward) {
    var drawn = false;
    return FakeSecretBoxRepository._(
      stateHandler: () async => const SecretBoxState(
        unopenedCount: 1,
        openedRewards: [],
      ),
      drawHandler: () async {
        if (drawn) {
          throw const UnknownFailure('Fake: no boxes remaining');
        }
        drawn = true;
        const initialState = SecretBoxState(
          unopenedCount: 1,
          openedRewards: [],
        );
        final nextState = initialState.copyWith(
          unopenedCount: 0,
          openedRewards: [reward],
          collectedIconIds: reward.iconId != null ? {reward.iconId!} : {},
        );
        return DrawResult(nextState: nextState, reward: reward);
      },
    );
  }

  final Future<SecretBoxState> Function() _stateHandler;
  final Future<DrawResult> Function() _drawHandler;

  @override
  Future<SecretBoxState> getState() => _stateHandler();

  @override
  Future<DrawResult> draw() => _drawHandler();
}

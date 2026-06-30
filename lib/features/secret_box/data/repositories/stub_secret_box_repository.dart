import 'dart:math';

import '../../../../core/error/failures.dart';
import '../../domain/entities/secret_box_state.dart';
import '../../domain/repositories/secret_box_repository.dart';
import '../../domain/usecases/draw_secret_box_reward.dart';
import '../sources/secret_box_mock_data.dart';

/// Behavior modes for [StubSecretBoxRepository].
enum StubSecretBoxBehavior { data, error }

/// Stub implementation of [SecretBoxRepository] for development and manual QA.
///
/// Holds mutable in-memory state (session-scoped — resets on hot-restart).
/// Adds an artificial delay to exercise loading state in the UI.
///
///   - [StubSecretBoxBehavior.data]  → normal draw/get flow
///   - [StubSecretBoxBehavior.error] → every call throws [UnknownFailure]
///
/// Pass a seeded [Random] via [random] for deterministic demo/test runs.
class StubSecretBoxRepository implements SecretBoxRepository {
  StubSecretBoxRepository({
    this.behavior = StubSecretBoxBehavior.data,
    this.delay = const Duration(milliseconds: 800),
    Random? random,
  })  : _state = SecretBoxMockData.initialState,
        _drawUsecase = DrawSecretBoxReward(
          iconPool: SecretBoxMockData.iconRewards,
          giftReward: SecretBoxMockData.giftReward,
          random: random,
        );

  final StubSecretBoxBehavior behavior;
  final Duration delay;

  SecretBoxState _state;
  final DrawSecretBoxReward _drawUsecase;

  @override
  Future<SecretBoxState> getState() async {
    await Future<void>.delayed(delay);
    if (behavior == StubSecretBoxBehavior.error) {
      throw const UnknownFailure('Stub: simulated secret box fetch error');
    }
    return _state;
  }

  @override
  Future<DrawResult> draw() async {
    await Future<void>.delayed(delay);
    if (behavior == StubSecretBoxBehavior.error) {
      throw const UnknownFailure('Stub: simulated secret box open error');
    }

    final result = _drawUsecase(_state);
    _state = result.nextState;
    return result;
  }
}

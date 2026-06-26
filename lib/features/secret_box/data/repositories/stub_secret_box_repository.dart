import '../../../../core/error/failures.dart';
import '../../domain/entities/secret_box_reward.dart';
import '../../domain/entities/secret_box_state.dart';
import '../../domain/repositories/secret_box_repository.dart';
import '../sources/secret_box_mock_data.dart';

/// Behavior modes for [StubSecretBoxRepository].
enum StubSecretBoxBehavior { data, error }

/// Stub implementation of [SecretBoxRepository] for development and manual QA.
///
/// Holds mutable in-memory state (session-scoped — resets on hot-restart).
/// Adds an artificial delay to exercise loading state in the UI.
///
///   - [StubSecretBoxBehavior.data]  → normal open/get flow
///   - [StubSecretBoxBehavior.error] → every call throws [UnknownFailure]
class StubSecretBoxRepository implements SecretBoxRepository {
  StubSecretBoxRepository({
    this.behavior = StubSecretBoxBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  })  : _unopenedCount = SecretBoxMockData.initialState.unopenedCount,
        _openedRewards = List.of(SecretBoxMockData.initialState.openedRewards);

  final StubSecretBoxBehavior behavior;
  final Duration delay;

  int _unopenedCount;
  final List<SecretBoxReward> _openedRewards;

  /// Rotation index so successive opens yield distinct reward entries.
  int _nextIndex = 0;

  @override
  Future<SecretBoxState> getState() async {
    await Future<void>.delayed(delay);
    if (behavior == StubSecretBoxBehavior.error) {
      throw const UnknownFailure('Stub: simulated secret box fetch error');
    }
    return SecretBoxState(
      unopenedCount: _unopenedCount,
      openedRewards: List.unmodifiable(_openedRewards),
    );
  }

  @override
  Future<SecretBoxReward> open() async {
    await Future<void>.delayed(delay);
    if (behavior == StubSecretBoxBehavior.error) {
      throw const UnknownFailure('Stub: simulated secret box open error');
    }
    if (_unopenedCount <= 0) {
      throw const UnknownFailure('Stub: no secret boxes remaining');
    }

    final reward =
        SecretBoxMockData.rewards[_nextIndex % SecretBoxMockData.rewards.length];
    _nextIndex++;
    _unopenedCount--;
    _openedRewards.add(reward);

    return reward;
  }
}

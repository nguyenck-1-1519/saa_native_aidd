import '../entities/secret_box_reward.dart';
import '../entities/secret_box_state.dart';

/// Contract for Secret Box data access.
///
/// Implementations live in `data/repositories/`.  Both methods throw a
/// [Failure] subtype on error so callers can use `AsyncValue.guard`.
abstract interface class SecretBoxRepository {
  /// Returns the current state: remaining unopened count + already-opened
  /// rewards for this session.
  Future<SecretBoxState> getState();

  /// Opens one box: decrements [SecretBoxState.unopenedCount], records the
  /// reward, and returns the newly revealed [SecretBoxReward].
  ///
  /// Throws [UnknownFailure] when [SecretBoxState.unopenedCount] is already 0.
  Future<SecretBoxReward> open();
}

import '../entities/secret_box_state.dart';
import '../usecases/draw_secret_box_reward.dart';

/// Contract for Secret Box data access.
///
/// Implementations live in `data/repositories/`.  Both methods throw a
/// [Failure] subtype on error so callers can use `AsyncValue.guard`.
abstract interface class SecretBoxRepository {
  /// Returns the current state: remaining unopened count, already-opened
  /// rewards for this session, and the set of collected icon IDs.
  Future<SecretBoxState> getState();

  /// Draws one reward: decrements [SecretBoxState.unopenedCount], applies
  /// the collect-the-set rule (icon until set complete → gift), and returns
  /// the new state + drawn reward as a [DrawResult].
  ///
  /// Throws [UnknownFailure] when [SecretBoxState.unopenedCount] is already 0.
  Future<DrawResult> draw();
}

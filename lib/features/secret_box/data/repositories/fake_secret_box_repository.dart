import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/secret_box_reward.dart';
import '../../domain/entities/secret_box_state.dart';
import '../../domain/repositories/secret_box_repository.dart';

/// Deterministic, delay-free [SecretBoxRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.empty()`   → 1 unopened box, no opened rewards; resolves immediately
///   - `.none()`    → 0 unopened boxes (FR8 none-left state); resolves immediately
///   - `.error()`   → throws [UnknownFailure] immediately
///   - `.loading()` → never resolves — pins the provider in loading state
class FakeSecretBoxRepository implements SecretBoxRepository {
  FakeSecretBoxRepository._({
    required Future<SecretBoxState> Function() stateHandler,
    required Future<SecretBoxReward> Function() openHandler,
  })  : _stateHandler = stateHandler,
        _openHandler = openHandler;

  factory FakeSecretBoxRepository.empty() {
    return FakeSecretBoxRepository._(
      stateHandler: () async => const SecretBoxState(
        unopenedCount: 1,
        openedRewards: [],
      ),
      openHandler: () async => const SecretBoxReward(
        id: 'fake-reward-1',
        name: 'Test Reward',
        descriptor: 'Test descriptor',
        assetRef: null,
      ),
    );
  }

  factory FakeSecretBoxRepository.none() {
    return FakeSecretBoxRepository._(
      stateHandler: () async => const SecretBoxState(
        unopenedCount: 0,
        openedRewards: [],
      ),
      openHandler: () async =>
          throw const UnknownFailure('Fake: no boxes remaining'),
    );
  }

  factory FakeSecretBoxRepository.error() {
    return FakeSecretBoxRepository._(
      stateHandler: () async =>
          throw const UnknownFailure('Fake: simulated secret box fetch error'),
      openHandler: () async =>
          throw const UnknownFailure('Fake: simulated secret box open error'),
    );
  }

  /// Throws a [StateError] (a Dart [Error], not [Exception]) on open().
  ///
  /// Used to verify that the controller catch-all (`catch (e)`) handles
  /// non-Exception throwables and still resets phase → closed.
  factory FakeSecretBoxRepository.throwingError() {
    return FakeSecretBoxRepository._(
      stateHandler: () async => const SecretBoxState(
        unopenedCount: 1,
        openedRewards: [],
      ),
      openHandler: () async => throw StateError('Fake: unexpected Dart Error'),
    );
  }

  /// Returns futures that never complete — useful for testing loading state.
  factory FakeSecretBoxRepository.loading() {
    return FakeSecretBoxRepository._(
      stateHandler: () => Completer<SecretBoxState>().future,
      openHandler: () => Completer<SecretBoxReward>().future,
    );
  }

  final Future<SecretBoxState> Function() _stateHandler;
  final Future<SecretBoxReward> Function() _openHandler;

  @override
  Future<SecretBoxState> getState() => _stateHandler();

  @override
  Future<SecretBoxReward> open() => _openHandler();
}

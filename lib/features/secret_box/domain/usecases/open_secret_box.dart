import '../entities/secret_box_reward.dart';
import '../repositories/secret_box_repository.dart';

/// Opens one Secret Box and returns the revealed [SecretBoxReward].
///
/// Throws [UnknownFailure] (via the repository) when no boxes remain.
class OpenSecretBox {
  const OpenSecretBox(this._repo);

  final SecretBoxRepository _repo;

  Future<SecretBoxReward> call() => _repo.open();
}

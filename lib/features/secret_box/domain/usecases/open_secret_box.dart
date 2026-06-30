import '../repositories/secret_box_repository.dart';
import '../usecases/draw_secret_box_reward.dart';

/// Opens one Secret Box and returns the [DrawResult] (new state + reward).
///
/// Throws [UnknownFailure] (via the repository) when no boxes remain.
class OpenSecretBox {
  const OpenSecretBox(this._repo);

  final SecretBoxRepository _repo;

  Future<DrawResult> call() => _repo.draw();
}

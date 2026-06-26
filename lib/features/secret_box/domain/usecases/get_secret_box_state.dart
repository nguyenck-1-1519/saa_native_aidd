import '../entities/secret_box_state.dart';
import '../repositories/secret_box_repository.dart';

/// Returns the current [SecretBoxState] (unopened count + opened rewards).
class GetSecretBoxState {
  const GetSecretBoxState(this._repo);

  final SecretBoxRepository _repo;

  Future<SecretBoxState> call() => _repo.getState();
}

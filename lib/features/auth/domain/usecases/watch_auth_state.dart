import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Streams auth state changes (null = signed out). Drives router redirects and
/// auto-login at startup.
class WatchAuthState {
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  Stream<AuthUser?> call() => _repository.watchAuthState();
}

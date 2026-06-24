import '../entities/auth_user.dart';

/// Contract for authentication. Implemented by the data layer (real Supabase +
/// Google, or a fake for tests). Errors surface as [Failure] subtypes via throw.
abstract interface class AuthRepository {
  /// Runs the Google sign-in flow and returns the authenticated user.
  /// Throws `AuthCancelled`, `NetworkFailure`, `AccountDisabled`, or
  /// `UnknownFailure`.
  Future<AuthUser> signInWithGoogle();

  /// Clears the current session.
  Future<void> signOut();

  /// Emits the current user (or null when signed out) and on every change.
  Stream<AuthUser?> watchAuthState();

  /// The currently authenticated user, or null. Used for auto-login decisions.
  AuthUser? get currentUser;
}

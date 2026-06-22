/// Domain-level failures surfaced to the presentation layer.
///
/// Thrown by repositories/usecases (plain `throw`, no Either) and mapped to a
/// localized message in the UI. Kept framework-free so the domain layer can use
/// them without importing Flutter.
sealed class Failure implements Exception {
  const Failure([this.message]);

  /// Optional non-localized diagnostic message (never shown raw to the user).
  final String? message;

  @override
  String toString() => '$runtimeType(${message ?? ''})';
}

/// User dismissed/cancelled the Google sign-in flow.
class AuthCancelled extends Failure {
  const AuthCancelled([super.message]);
}

/// Network/connectivity problem during authentication.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Account is invalid, deleted, disabled or locked.
class AccountDisabled extends Failure {
  const AccountDisabled([super.message]);
}

/// Anything not covered by the cases above.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}

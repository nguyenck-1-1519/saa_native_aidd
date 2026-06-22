/// Immutable authenticated user (public profile only — no tokens).
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          other.id == id &&
          other.email == email &&
          other.displayName == displayName &&
          other.photoUrl == photoUrl;

  @override
  int get hashCode => Object.hash(id, email, displayName, photoUrl);
}

/// Display identity for a profile — extends beyond [AuthUser] with
/// role, department, heroLevel and badges which are profile-specific fields
/// that the auth layer does not own.
///
/// [avatarUrl] is intentionally nullable; the UI renders a grey placeholder
/// when null (consistent with F003/F004 null-S3 convention).
class ProfileUser {
  const ProfileUser({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    this.avatarUrl,
    this.heroLevel,
    this.badges = const [],
  });

  final String id;
  final String name;
  final String role;
  final String department;

  /// Remote URL or local asset path. Null → show grey avatar placeholder.
  final String? avatarUrl;

  /// Hero-level label (e.g. "Rising Hero", "Legend Hero"). Null = not earned.
  final String? heroLevel;

  /// List of earned badge labels (e.g. ["Top Talent", "MVP"]).
  final List<String> badges;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileUser &&
          other.id == id &&
          other.name == name &&
          other.role == role &&
          other.department == department &&
          other.avatarUrl == avatarUrl &&
          other.heroLevel == heroLevel &&
          _listEquals(other.badges, badges);

  @override
  int get hashCode => Object.hash(
      id, name, role, department, avatarUrl, heroLevel, Object.hashAll(badges));

  // Lightweight structural list equality — avoids importing `collection`.
  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// A Sunner that can appear as a recent gift recipient or as a write-kudo
/// search result.
///
/// [role] is used by the recipient search feature (Write Kudo screen) to
/// narrow results by department/role. Existing usages that only care about
/// the gift-list view may leave [role] as null.
class KudoRecipient {
  const KudoRecipient({
    required this.name,
    required this.giftDescription,
    this.role,
    this.avatarUrl,
  });

  final String name;
  final String giftDescription;

  /// Job title / department — used for search filtering; may be null for
  /// recipients that appear only in the recent-gifts list.
  final String? role;
  final String? avatarUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KudoRecipient &&
          other.name == name &&
          other.giftDescription == giftDescription &&
          other.role == role &&
          other.avatarUrl == avatarUrl;

  @override
  int get hashCode => Object.hash(name, giftDescription, role, avatarUrl);
}

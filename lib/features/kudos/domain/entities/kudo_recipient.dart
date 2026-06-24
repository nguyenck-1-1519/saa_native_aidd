/// A recent gift recipient shown in the "10 Sunner nhận quà mới nhất" list.
class KudoRecipient {
  const KudoRecipient({
    required this.name,
    required this.giftDescription,
    this.avatarUrl,
  });

  final String name;
  final String giftDescription;
  final String? avatarUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KudoRecipient &&
          other.name == name &&
          other.giftDescription == giftDescription &&
          other.avatarUrl == avatarUrl;

  @override
  int get hashCode => Object.hash(name, giftDescription, avatarUrl);
}

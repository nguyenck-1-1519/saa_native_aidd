/// Distinguishes the two reveal outcomes in the Secret Box flow.
///
/// - [icon] — a collectible emblem (one of 6 variants); common result.
/// - [gift] — the physical BTC prize awarded when all 6 icons are collected.
enum SecretBoxRewardKind { icon, gift }

/// A single reward item revealed from a Secret Box.
///
/// [assetRef] is nullable — a null value means the S3 asset has not been
/// linked yet; the UI must fall back to a styled placeholder.
///
/// [iconId] is non-null when [kind] == [SecretBoxRewardKind.icon] and holds
/// the stable identifier used to track set-completion (e.g. "REVIVAL").
class SecretBoxReward {
  const SecretBoxReward({
    required this.id,
    required this.kind,
    required this.name,
    required this.descriptor,
    this.iconId,
    this.assetRef,
  });

  /// Stable identifier (used for deduplication / list keys).
  final String id;

  /// Whether this reward is a collectible icon or the physical gift.
  final SecretBoxRewardKind kind;

  /// Display name of the reward, e.g. "REVIVAL" or "Khăn Root Further".
  final String name;

  /// Short descriptor shown below the name, e.g. "Quà từ BTC SAA 2025".
  final String descriptor;

  /// Stable icon identifier for set-completion tracking.
  /// Non-null iff [kind] == [SecretBoxRewardKind.icon].
  final String? iconId;

  /// Optional S3 / CDN URL for the reward image.  Null → UI shows fallback.
  final String? assetRef;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretBoxReward &&
          other.id == id &&
          other.kind == kind &&
          other.name == name &&
          other.descriptor == descriptor &&
          other.iconId == iconId &&
          other.assetRef == assetRef;

  @override
  int get hashCode =>
      Object.hash(id, kind, name, descriptor, iconId, assetRef);

  @override
  String toString() => 'SecretBoxReward(id: $id, kind: $kind, name: $name, '
      'descriptor: $descriptor, iconId: $iconId, assetRef: $assetRef)';
}

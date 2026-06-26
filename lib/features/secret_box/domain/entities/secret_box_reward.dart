/// A single reward item revealed from a Secret Box.
///
/// [assetRef] is nullable — a null value means the S3 asset has not been
/// linked yet; the UI must fall back to a styled placeholder (handled in A1).
class SecretBoxReward {
  const SecretBoxReward({
    required this.id,
    required this.name,
    required this.descriptor,
    this.assetRef,
  });

  /// Stable identifier (used for deduplication / list keys).
  final String id;

  /// Display name of the reward, e.g. "Khăn Root Further".
  final String name;

  /// Short descriptor shown below the name, e.g. "Quà từ BTC SAA 2025".
  final String descriptor;

  /// Optional S3 / CDN URL for the reward image.  Null → UI shows fallback.
  final String? assetRef;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretBoxReward &&
          other.id == id &&
          other.name == name &&
          other.descriptor == descriptor &&
          other.assetRef == assetRef;

  @override
  int get hashCode => Object.hash(id, name, descriptor, assetRef);

  @override
  String toString() =>
      'SecretBoxReward(id: $id, name: $name, descriptor: $descriptor, assetRef: $assetRef)';
}

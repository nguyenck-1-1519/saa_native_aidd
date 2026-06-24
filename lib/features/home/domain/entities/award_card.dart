/// An award category shown in the Home awards carousel.
///
/// [imageRef] is the asset path/key for the card image (Track A extracts the
/// exact MoMorph media; the data layer only references the name/path).
class AwardCard {
  const AwardCard({
    required this.id,
    required this.name,
    required this.description,
    required this.imageRef,
  });

  final String id;
  final String name;
  final String description;
  final String imageRef;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwardCard &&
          other.id == id &&
          other.name == name &&
          other.description == description &&
          other.imageRef == imageRef;

  @override
  int get hashCode => Object.hash(id, name, description, imageRef);
}

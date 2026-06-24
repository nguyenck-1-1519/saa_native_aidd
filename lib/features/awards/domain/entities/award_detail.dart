/// A single SAA 2025 award category shown on the Awards screen (selected via
/// the award dropdown). Content + badge image come from the MoMorph design.
class AwardDetail {
  const AwardDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.badgeImageRef,
    required this.quantityValue,
    required this.quantityUnit,
    required this.prizeValue,
    required this.prizeNote,
  });

  final String id;
  final String name;
  final String description;

  /// Asset path for the circular award badge graphic (e.g. "TOP TALENT").
  final String badgeImageRef;

  /// "Số lượng giải thưởng" — value + unit (e.g. "10" / "Cá nhân").
  final String quantityValue;
  final String quantityUnit;

  /// "Giá trị giải thưởng" — amount + note (e.g. "7.000.000 VNĐ" / "cho mỗi giải thưởng").
  final String prizeValue;
  final String prizeNote;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AwardDetail &&
          other.id == id &&
          other.name == name &&
          other.description == description &&
          other.badgeImageRef == badgeImageRef &&
          other.quantityValue == quantityValue &&
          other.quantityUnit == quantityUnit &&
          other.prizeValue == prizeValue &&
          other.prizeNote == prizeNote;

  @override
  int get hashCode => Object.hash(id, name, description, badgeImageRef,
      quantityValue, quantityUnit, prizeValue, prizeNote);
}

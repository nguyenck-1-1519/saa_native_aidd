/// The award category / badge type shown on a Kudo card and detail screen.
///
/// Values are derived from titles present in the Sun*Kudos design
/// (MoMorph fileKey fO0Kt19sZZ). The [displayName] string matches the
/// text visible in the design so it can be stored as-is in mock data.
enum HeroTag {
  risingHero('Rising Hero'),
  legendHero('Legend Hero'),
  newHero('New Hero'),
  superHero('Super Hero');

  const HeroTag(this.displayName);

  /// The human-readable label shown on a kudo card / detail badge.
  final String displayName;

  /// Parse a display-name string back to a [HeroTag], returning [risingHero]
  /// as the fallback for any unrecognised value.
  static HeroTag fromDisplayName(String name) {
    for (final tag in HeroTag.values) {
      if (tag.displayName == name) return tag;
    }
    return HeroTag.risingHero;
  }
}

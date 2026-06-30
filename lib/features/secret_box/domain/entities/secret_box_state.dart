import 'secret_box_reward.dart';

/// Aggregate state of the user's Secret Box.
///
/// Sourced from [SecretBoxRepository.getState] and updated after each
/// successful draw.
class SecretBoxState {
  const SecretBoxState({
    required this.unopenedCount,
    required this.openedRewards,
    this.collectedIconIds = const {},
  });

  /// How many boxes remain to be opened (≥ 0).
  final int unopenedCount;

  /// Rewards already revealed in this session (oldest first).
  final List<SecretBoxReward> openedRewards;

  /// Set of [SecretBoxReward.iconId] values the user has already collected.
  ///
  /// Used by [DrawSecretBoxReward] to determine which icons remain unowned
  /// and whether the next open completes the set of 6 (triggering the gift).
  final Set<String> collectedIconIds;

  SecretBoxState copyWith({
    int? unopenedCount,
    List<SecretBoxReward>? openedRewards,
    Set<String>? collectedIconIds,
  }) {
    return SecretBoxState(
      unopenedCount: unopenedCount ?? this.unopenedCount,
      openedRewards: openedRewards ?? this.openedRewards,
      collectedIconIds: collectedIconIds ?? this.collectedIconIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretBoxState &&
          other.unopenedCount == unopenedCount &&
          _listEquals(other.openedRewards, openedRewards) &&
          _setEquals(other.collectedIconIds, collectedIconIds);

  @override
  int get hashCode => Object.hash(
        unopenedCount,
        Object.hashAll(openedRewards),
        Object.hashAll(collectedIconIds),
      );

  @override
  String toString() => 'SecretBoxState(unopenedCount: $unopenedCount, '
      'openedRewards: $openedRewards, '
      'collectedIconIds: $collectedIconIds)';
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

bool _setEquals<T>(Set<T> a, Set<T> b) {
  if (a.length != b.length) return false;
  return a.containsAll(b);
}

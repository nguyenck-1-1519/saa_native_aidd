import 'secret_box_reward.dart';

/// Aggregate state of the user's Secret Box.
///
/// Sourced from [SecretBoxRepository.getState] and updated after each
/// successful [SecretBoxRepository.open] call.
class SecretBoxState {
  const SecretBoxState({
    required this.unopenedCount,
    required this.openedRewards,
  });

  /// How many boxes remain to be opened (≥ 0).
  final int unopenedCount;

  /// Rewards already revealed in this session (oldest first).
  final List<SecretBoxReward> openedRewards;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretBoxState &&
          other.unopenedCount == unopenedCount &&
          _listEquals(other.openedRewards, openedRewards);

  @override
  int get hashCode => Object.hash(unopenedCount, Object.hashAll(openedRewards));

  @override
  String toString() =>
      'SecretBoxState(unopenedCount: $unopenedCount, openedRewards: $openedRewards)';
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

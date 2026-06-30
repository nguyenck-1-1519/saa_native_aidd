import 'dart:math';

import '../../../../core/error/failures.dart';
import '../entities/secret_box_reward.dart';
import '../entities/secret_box_state.dart';

/// Result of a single draw operation.
class DrawResult {
  const DrawResult({required this.nextState, required this.reward});

  /// Updated state after the draw (count decremented, reward appended).
  final SecretBoxState nextState;

  /// The reward drawn in this operation.
  final SecretBoxReward reward;
}

/// Pure domain usecase: draw one reward from the Secret Box pool.
///
/// Collect-the-set rule:
///   - If the user has not collected all 6 icons → draw a random
///     not-yet-owned icon (icon reveal), add its [iconId] to
///     [SecretBoxState.collectedIconIds].
///   - The draw that completes the set of 6 → return the gift reward
///     (gift reveal).
///
/// The usecase is stateless; state is carried in via [currentState] and
/// the updated [SecretBoxState] is returned inside [DrawResult].
///
/// Deterministic given an injectable [Random] — pass `Random(seed)` in tests.
class DrawSecretBoxReward {
  const DrawSecretBoxReward({
    required this.iconPool,
    required this.giftReward,
    Random? random,
  }) : _random = random;

  /// All 6 collectible icon rewards.  Order does not matter — drawn by index.
  final List<SecretBoxReward> iconPool;

  /// The single physical gift reward awarded on completing the icon set.
  final SecretBoxReward giftReward;

  // ignore: prefer_final_fields — injected; may be null (lazily defaulted below)
  final Random? _random;

  /// Draws one reward from [currentState].
  ///
  /// Throws [UnknownFailure] when [SecretBoxState.unopenedCount] is already 0.
  DrawResult call(SecretBoxState currentState, {Random? random}) {
    if (currentState.unopenedCount <= 0) {
      throw const UnknownFailure('No secret boxes remaining');
    }

    final rng = random ?? _random ?? Random();

    final collected = Set<String>.of(currentState.collectedIconIds);

    // Determine which icon IDs have not yet been collected.
    final unowned = iconPool
        .where((r) => !collected.contains(r.iconId))
        .toList(growable: false);

    late final SecretBoxReward drawn;
    late final Set<String> updatedIconIds;

    if (unowned.isEmpty) {
      // All 6 icons already collected — this path is only reachable when
      // unopenedCount > 0 but the set is full; hand out the gift again.
      drawn = giftReward;
      updatedIconIds = collected;
    } else if (unowned.length == 1) {
      // This draw completes the set → gift reveal.
      drawn = giftReward;
      updatedIconIds = {...collected, unowned.first.iconId!};
    } else {
      // Common path: give a random not-yet-owned icon.
      final pick = unowned[rng.nextInt(unowned.length)];
      drawn = pick;
      updatedIconIds = {...collected, pick.iconId!};
    }

    final nextState = currentState.copyWith(
      unopenedCount: currentState.unopenedCount - 1,
      openedRewards: [...currentState.openedRewards, drawn],
      collectedIconIds: updatedIconIds,
    );

    return DrawResult(nextState: nextState, reward: drawn);
  }
}

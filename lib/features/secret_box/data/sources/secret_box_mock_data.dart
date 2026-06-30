import '../../domain/entities/secret_box_reward.dart';
import '../../domain/entities/secret_box_state.dart';

/// Design-sourced mock data for the Secret Box feature.
///
/// Reward taxonomy (MoMorph fileKey 9ypp4enmFmdK3YAFJLIu6C):
///   - 6 collectible icon rewards (kind: icon) — one per design variant frame.
///     Icon names: REVIVAL, TOUCH OF LIGHT, STAY GOLD, FLOW TO HORIZON,
///     BEYOND THE BOUNDARY, ROOT FURTHER.
///   - 1 physical gift reward (kind: gift) — "Khăn Root Further", awarded
///     when the user completes the full set of 6 icons.
///
/// [assetRef] is null for all entries — S3 nodes not yet exported; the UI
/// renders styled fallbacks until real PNGs land in assets/images/secret_box/.
abstract final class SecretBoxMockData {
  // ── Icon IDs ────────────────────────────────────────────────────────────────

  static const String idRevival = 'REVIVAL';
  static const String idTouchOfLight = 'TOUCH_OF_LIGHT';
  static const String idStayGold = 'STAY_GOLD';
  static const String idFlowToHorizon = 'FLOW_TO_HORIZON';
  static const String idBeyondTheBoundary = 'BEYOND_THE_BOUNDARY';
  static const String idRootFurther = 'ROOT_FURTHER';

  // ── Icon reward pool — 6 variants ──────────────────────────────────────────

  static const List<SecretBoxReward> iconRewards = [
    SecretBoxReward(
      id: 'icon-revival',
      kind: SecretBoxRewardKind.icon,
      name: 'REVIVAL',
      descriptor: '',
      iconId: idRevival,
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'icon-touch-of-light',
      kind: SecretBoxRewardKind.icon,
      name: 'TOUCH OF LIGHT',
      descriptor: '',
      iconId: idTouchOfLight,
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'icon-stay-gold',
      kind: SecretBoxRewardKind.icon,
      name: 'STAY GOLD',
      descriptor: '',
      iconId: idStayGold,
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'icon-flow-to-horizon',
      kind: SecretBoxRewardKind.icon,
      name: 'FLOW TO HORIZON',
      descriptor: '',
      iconId: idFlowToHorizon,
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'icon-beyond-the-boundary',
      kind: SecretBoxRewardKind.icon,
      name: 'BEYOND THE BOUNDARY',
      descriptor: '',
      iconId: idBeyondTheBoundary,
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'icon-root-further',
      kind: SecretBoxRewardKind.icon,
      name: 'ROOT FURTHER',
      descriptor: '',
      iconId: idRootFurther,
      assetRef: null,
    ),
  ];

  // ── Gift reward — grand prize ───────────────────────────────────────────────

  static const SecretBoxReward giftReward = SecretBoxReward(
    id: 'gift-khan-root-further',
    kind: SecretBoxRewardKind.gift,
    name: 'Khăn Root Further',
    descriptor: 'Quà từ BTC SAA 2025',
    iconId: null,
    assetRef: null,
  );

  // ── Initial state ──────────────────────────────────────────────────────────

  /// Starting state injected into [StubSecretBoxRepository] on first load.
  ///
  /// [unopenedCount] = 7 so the user can collect all 6 icons and then
  /// trigger the gift reveal in a single demo session.
  /// The design artboard shows "05" but that is a static mock value;
  /// 7 is the minimum that makes both reveal types reachable in one run.
  static const SecretBoxState initialState = SecretBoxState(
    unopenedCount: 7,
    openedRewards: [],
    collectedIconIds: {},
  );
}

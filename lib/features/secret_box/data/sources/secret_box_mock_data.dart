import '../../domain/entities/secret_box_reward.dart';
import '../../domain/entities/secret_box_state.dart';

/// Design-sourced mock data for the Secret Box feature.
///
/// Reward names and descriptors come directly from the MoMorph design content
/// (fileKey 9ypp4enmFmdK3YAFJLIu6C, 7 standby reward variant frames).
/// The design shows "Khăn Root Further" as the reward name across all 7 frames;
/// each variant corresponds to a distinct gift image asset.  [assetRef] is null
/// for all entries because the S3 nodes were not yet linked at design time —
/// the UI (A1) must render a styled fallback.
abstract final class SecretBoxMockData {
  // -------------------------------------------------------------------------
  // Reward pool — 7 variants sourced from the 7 standby design frames
  // -------------------------------------------------------------------------

  static const List<SecretBoxReward> rewards = [
    SecretBoxReward(
      id: 'reward-001',
      name: 'Khăn Root Further',
      descriptor: 'Quà từ BTC SAA 2025',
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'reward-002',
      name: 'Khăn Root Further',
      descriptor: 'Quà từ BTC SAA 2025',
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'reward-003',
      name: 'Khăn Root Further',
      descriptor: 'Quà từ BTC SAA 2025',
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'reward-004',
      name: 'Khăn Root Further',
      descriptor: 'Quà từ BTC SAA 2025',
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'reward-005',
      name: 'Khăn Root Further',
      descriptor: 'Quà từ BTC SAA 2025',
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'reward-006',
      name: 'Khăn Root Further',
      descriptor: 'Quà từ BTC SAA 2025',
      assetRef: null,
    ),
    SecretBoxReward(
      id: 'reward-007',
      name: 'Khăn Root Further',
      descriptor: 'Quà từ BTC SAA 2025',
      assetRef: null,
    ),
  ];

  // -------------------------------------------------------------------------
  // Initial state — 1 box ready to open (mirrors KudosMockData.stats)
  // -------------------------------------------------------------------------

  /// Starting state injected into [StubSecretBoxRepository] on first load.
  ///
  /// [unopenedCount] = 1 so the UI shows the open CTA immediately.
  /// The closed-state design (IXpGakYRm5) shows "05" as the count, but the
  /// stub exposes only 1 so the FR8 "none left" path is exercisable in one tap.
  static const SecretBoxState initialState = SecretBoxState(
    unopenedCount: 1,
    openedRewards: [],
  );
}

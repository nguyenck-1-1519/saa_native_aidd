import 'package:flutter/material.dart';

import 'widgets/secret_box_app_bar.dart';
import 'widgets/secret_box_closed_content.dart';
import 'widgets/secret_box_icon_reveal_content.dart';
import 'widgets/secret_box_opening_wrapper.dart';
import 'widgets/secret_box_revealed_content.dart';

// ── View state enum ───────────────────────────────────────────────────────────

/// The visual states of the Secret Box reveal flow.
///
/// Integration maps the real domain `SecretBoxPhase` / `SecretBoxReward.kind`
/// onto this enum and passes it as [SecretBoxScreen.view].
enum SecretBoxView {
  /// Unopened — shows box + tap affordance.
  closed,

  /// Box-opening animation playing; auto-advances to a reveal state on complete.
  opening,

  /// Icon revealed — shows opened podium + glowing collectible emblem + name.
  revealedIcon,

  /// Gift revealed — shows congrats heading + product image + name.
  revealedGift,
}

// ── Screen ────────────────────────────────────────────────────────────────────

/// Secret Box reveal screen — pure presentational, no providers / router.
///
/// Design sources (MoMorph fileKey 9ypp4enmFmdK3YAFJLIu6C):
///   • Closed      : screen kQk65hSYF2  (node 6885:9402)
///   • Opening     : screen KUmv414uC9  (node 6885:9532)
///   • Icon reveal : screen IXpGakYRm5  (6 icon variants, data-driven)
///   • Gift reveal : screen FvTOS7oCPU  (grand prize after full set)
///
/// Background : assets/images/home/Keyvisual_BG.png  (reused from Home)
/// Box closed : assets/images/secret_box/box_closed.png   (MM_MEDIA 6885:9443, S3 null)
/// Box opening: assets/images/secret_box/box_opening.png  (MM_MEDIA 6885:9572, S3 null)
/// Reward img : supplied at runtime via [rewardAssetRef]   (MM_MEDIA 6885:9663, S3 null)
/// → Declare assets/images/secret_box/ in pubspec.yaml once real PNGs land.
class SecretBoxScreen extends StatelessWidget {
  const SecretBoxScreen({
    super.key,
    required this.view,
    this.unopenedCount = 0,
    this.rewardName,
    this.rewardAssetRef,
    this.onOpen,
    this.onClose,
    this.onOpeningComplete,
  });

  // ── State ──────────────────────────────────────────────────────────────
  /// Current view state — drives which content panel is shown.
  final SecretBoxView view;

  // ── Data ───────────────────────────────────────────────────────────────
  /// Number of still-unopened boxes (shown in [SecretBoxView.closed] and
  /// [SecretBoxView.revealedIcon]).
  final int unopenedCount;

  /// Reward display name.
  /// - Icon reveal: icon name, e.g. "TOUCH OF LIGHT".
  /// - Gift reveal: product name, e.g. "Khăn Root Further".
  final String? rewardName;

  /// Flutter asset path for the reward image / emblem. Null → placeholder shown.
  final String? rewardAssetRef;

  // ── Callbacks ──────────────────────────────────────────────────────────
  /// User tapped the box / open affordance in [SecretBoxView.closed].
  final VoidCallback? onOpen;

  /// User tapped close in a revealed state.
  final VoidCallback? onClose;

  /// Opening animation finished — caller should advance [view] to a reveal state.
  final VoidCallback? onOpeningComplete;

  static const Color _bgColor = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      extendBodyBehindAppBar: true,
      appBar: SecretBoxAppBar(onBack: onClose),
      body: Stack(
        children: [
          // Keyvisual background — full-bleed, top-anchored
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/home/Keyvisual_BG.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // Content — constrained to design width, centred
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 375),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7.3),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (view) {
      case SecretBoxView.closed:
        return SecretBoxClosedContent(
          key: const ValueKey('closed'),
          unopenedCount: unopenedCount,
          onOpen: onOpen,
        );

      case SecretBoxView.opening:
        return SecretBoxOpeningWrapper(
          key: const ValueKey('opening'),
          onAnimationComplete: onOpeningComplete,
        );

      case SecretBoxView.revealedIcon:
        return SecretBoxIconRevealContent(
          key: const ValueKey('revealedIcon'),
          iconName: rewardName ?? '',
          unopenedCount: unopenedCount,
          assetRef: rewardAssetRef,
          onClose: onClose,
        );

      case SecretBoxView.revealedGift:
        return SecretBoxRevealedContent(
          key: const ValueKey('revealedGift'),
          rewardName: rewardName,
          rewardAssetRef: rewardAssetRef,
          onClose: onClose,
        );
    }
  }
}

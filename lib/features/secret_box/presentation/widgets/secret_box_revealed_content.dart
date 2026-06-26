import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import 'secret_box_reward_image.dart';

/// Content panel for [SecretBoxView.revealed].
///
/// Design source: MoMorph _cWAEarZPi — node 6885:9656.
/// All 7 reward variants share identical layout — only [rewardName] and
/// [rewardAssetRef] differ. Integration passes the real reward data.
///
/// Entrance: 600 ms fade-in + 32 pt slide-up driven by [AnimationController].
class SecretBoxRevealedContent extends StatefulWidget {
  const SecretBoxRevealedContent({
    super.key,
    this.rewardName,
    this.rewardAssetRef,
    this.onClose,
  });

  /// Display name of the reward, e.g. "Khăn Root Further".
  final String? rewardName;

  /// Flutter asset path for the reward image.
  /// Null or missing asset → placeholder shown (see [SecretBoxRewardImage]).
  final String? rewardAssetRef;

  final VoidCallback? onClose;

  @override
  State<SecretBoxRevealedContent> createState() =>
      _SecretBoxRevealedContentState();
}

class _SecretBoxRevealedContentState extends State<SecretBoxRevealedContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<double>(begin: 32, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: AnimatedBuilder(
        animation: _slideUp,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _slideUp.value),
          child: child,
        ),
        child: _RevealedBody(
          rewardName: widget.rewardName,
          rewardAssetRef: widget.rewardAssetRef,
        ),
      ),
    );
  }
}

// ── Static body ───────────────────────────────────────────────────────────────

class _RevealedBody extends StatelessWidget {
  const _RevealedBody({
    required this.rewardName,
    required this.rewardAssetRef,
  });

  final String? rewardName;
  final String? rewardAssetRef;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Congrats header — node 6885:9658
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.secretBoxRevealedTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _gold,
              height: 24 / 18,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Reward image — node 6885:9663
        SecretBoxRewardImage(assetRef: rewardAssetRef),
        const SizedBox(height: 24),
        Container(height: 1, color: _divider),
        const SizedBox(height: 24),
        // Reward name — node 6885:9666
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            rewardName ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _gold,
              height: 20 / 14,
              letterSpacing: 0.25,
            ),
          ),
        ),
      ],
    );
  }
}

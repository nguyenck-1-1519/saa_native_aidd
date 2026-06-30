import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_typography.dart';

/// Content panel shown after the box-opening animation when the reward
/// is a collectible icon (one of 6 variants).
///
/// Design source: MoMorph IXpGakYRm5 (TOUCH OF LIGHT variant).
///
/// Layout mirrors the closed state chrome (heading + count) but replaces
/// the closed-box image with the opened-box podium + glowing emblem above it,
/// followed by the icon name below.
///
/// Asset swap path: supply [assetRef] and declare the path in pubspec.yaml.
/// S3 null at extraction time → [_EmblemPlaceholder] shown until real PNGs land.
class SecretBoxIconRevealContent extends StatefulWidget {
  const SecretBoxIconRevealContent({
    super.key,
    required this.iconName,
    required this.unopenedCount,
    this.assetRef,
    this.onClose,
  });

  /// Display name of the collectible icon, e.g. "TOUCH OF LIGHT".
  final String iconName;

  /// Remaining unopened boxes — shown in the count row at the bottom.
  final int unopenedCount;

  /// Optional asset path for the emblem image.  Null → [_EmblemPlaceholder].
  final String? assetRef;

  /// Called when the user taps the close / continue affordance.
  final VoidCallback? onClose;

  @override
  State<SecretBoxIconRevealContent> createState() =>
      _SecretBoxIconRevealContentState();
}

class _SecretBoxIconRevealContentState
    extends State<SecretBoxIconRevealContent>
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
        child: _IconRevealBody(
          iconName: widget.iconName,
          unopenedCount: widget.unopenedCount,
          assetRef: widget.assetRef,
          onClose: widget.onClose,
        ),
      ),
    );
  }
}

// ── Static body ───────────────────────────────────────────────────────────────

class _IconRevealBody extends StatelessWidget {
  const _IconRevealBody({
    required this.iconName,
    required this.unopenedCount,
    this.assetRef,
    this.onClose,
  });

  final String iconName;
  final int unopenedCount;
  final String? assetRef;
  final VoidCallback? onClose;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _white = Colors.white;
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Header (same chrome as closed state) ──────────────────────────
        Text(
          l10n.secretBoxDiscoverTitle,
          textAlign: TextAlign.center,
          style: AppTypography.montserrat(
            fontSize: 18,
            weight: FontWeight.w700,
            color: _gold,
            height: 24 / 18,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, color: _divider),
        const SizedBox(height: 24),

        // ── Opened box podium + glowing emblem ────────────────────────────
        _OpenedPodiumWithEmblem(assetRef: assetRef, iconName: iconName),
        const SizedBox(height: 16),

        // ── Icon name ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            iconName,
            textAlign: TextAlign.center,
            style: AppTypography.montserrat(
              fontSize: 20,
              weight: FontWeight.w700,
              color: _gold,
              height: 28 / 20,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(height: 1, color: _divider),
        const SizedBox(height: 24),

        // ── Count row ─────────────────────────────────────────────────────
        _CountRow(count: unopenedCount),
        const SizedBox(height: 24),

        // ── Close / continue ─────────────────────────────────────────────
        TextButton(
          onPressed: onClose,
          child: Text(
            '✕',
            style: AppTypography.montserrat(
              fontSize: 16,
              weight: FontWeight.w500,
              color: _white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Opened podium + floating emblem ───────────────────────────────────────────

class _OpenedPodiumWithEmblem extends StatelessWidget {
  const _OpenedPodiumWithEmblem({
    required this.assetRef,
    required this.iconName,
  });

  final String? assetRef;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Opened-box base (podium)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/secret_box/box_opening.png',
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const _OpenedBoxPlaceholder(),
            ),
          ),
          // Glowing emblem floating above
          Positioned(
            top: 0,
            child: _GlowingEmblem(assetRef: assetRef, iconName: iconName),
          ),
        ],
      ),
    );
  }
}

// ── Glowing emblem ────────────────────────────────────────────────────────────

class _GlowingEmblem extends StatelessWidget {
  const _GlowingEmblem({required this.assetRef, required this.iconName});

  final String? assetRef;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFEA9E).withValues(alpha: 0.55),
            blurRadius: 36,
            spreadRadius: 4,
          ),
        ],
      ),
      child: assetRef != null
          ? ClipOval(
              child: Image.asset(
                assetRef!,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _EmblemPlaceholder(iconName: iconName),
              ),
            )
          : _EmblemPlaceholder(iconName: iconName),
    );
  }
}

// ── Emblem placeholder (S3 null) ──────────────────────────────────────────────

class _EmblemPlaceholder extends StatelessWidget {
  const _EmblemPlaceholder({required this.iconName});

  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF001828),
        border: Border.all(color: const Color(0xFFFFEA9E), width: 2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            iconName,
            textAlign: TextAlign.center,
            style: AppTypography.montserrat(
              fontSize: 10,
              weight: FontWeight.w700,
              color: const Color(0xFFFFEA9E),
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Opened-box fallback ───────────────────────────────────────────────────────

class _OpenedBoxPlaceholder extends StatelessWidget {
  const _OpenedBoxPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF001828),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFEA9E), width: 1.5),
      ),
      child: const Icon(
        Icons.all_inbox_outlined,
        color: Color(0xFFFFEA9E),
        size: 60,
      ),
    );
  }
}

// ── Count row (duplicated from closed content for self-contained widget) ──────

class _CountRow extends StatelessWidget {
  const _CountRow({required this.count});

  final int count;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.secretBoxUnopenedLabel,
          style: AppTypography.montserrat(
            fontSize: 12,
            weight: FontWeight.w400,
            color: _white,
            height: 16 / 12,
          ),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: AppTypography.montserrat(
            fontSize: 18,
            weight: FontWeight.w700,
            color: _gold,
            height: 24 / 18,
          ),
        ),
      ],
    );
  }
}

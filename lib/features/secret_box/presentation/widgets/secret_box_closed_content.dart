import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

/// Content panel for [SecretBoxView.closed].
///
/// Design source: MoMorph kQk65hSYF2 — node 6885:9434
/// "Open secret box- chưa mở"
///
/// Box image asset: assets/images/secret_box/box_closed.png
/// (MM_MEDIA node 6885:9443 — S3 null at extraction time → fallback icon).
/// Swap path: drop PNG at assets/images/secret_box/box_closed.png and
/// declare it in pubspec.yaml under assets/images/secret_box/.
class SecretBoxClosedContent extends StatelessWidget {
  const SecretBoxClosedContent({
    super.key,
    required this.unopenedCount,
    required this.onOpen,
  });

  final int unopenedCount;
  final VoidCallback? onOpen;

  // ── Design tokens (from Figma) ──────────────────────────────────────────
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final noneLeft = unopenedCount <= 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Header(l10n: l10n),
        const SizedBox(height: 24),
        _BoxImage(onTap: noneLeft ? null : onOpen),
        const SizedBox(height: 24),
        Container(height: 1, color: _divider),
        const SizedBox(height: 24),
        if (noneLeft)
          _NoneLeftMessage(message: l10n.secretBoxNoneLeft)
        else
          _CountRow(count: unopenedCount),
      ],
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.l10n});

  final AppLocalizations l10n;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _white = Colors.white;
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title — secretBoxTitle key ("Secret Box")
        Text(
          l10n.secretBoxTitle.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _gold,
            height: 24 / 18,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, color: _divider),
        const SizedBox(height: 4),
        // Subtitle — secretBoxOpenCta key
        Text(
          l10n.secretBoxOpenCta,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _white,
            height: 20 / 14,
          ),
        ),
      ],
    );
  }
}

// ── Box image (tappable) ─────────────────────────────────────────────────

class _BoxImage extends StatelessWidget {
  const _BoxImage({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 320,
        height: 320,
        child: Image.asset(
          'assets/images/secret_box/box_closed.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const _BoxPlaceholder(opened: false),
        ),
      ),
    );
  }
}

// ── Count row ────────────────────────────────────────────────────────────

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
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _white,
            height: 16 / 12,
          ),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _gold,
            height: 24 / 18,
          ),
        ),
      ],
    );
  }
}

// ── None-left message (FR8) ───────────────────────────────────────────────

class _NoneLeftMessage extends StatelessWidget {
  const _NoneLeftMessage({required this.message});

  final String message;

  static const Color _white = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _white,
        height: 20 / 14,
      ),
    );
  }
}

// ── Shared placeholder (used by closed + opening states) ────────────────

class _BoxPlaceholder extends StatelessWidget {
  const _BoxPlaceholder({required this.opened});

  final bool opened;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF001828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEA9E), width: 1.5),
      ),
      child: Icon(
        opened ? Icons.card_giftcard_outlined : Icons.all_inbox_outlined,
        color: const Color(0xFFFFEA9E),
        size: 80,
      ),
    );
  }
}

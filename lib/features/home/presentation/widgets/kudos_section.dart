import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/app_localizations.dart';

/// Presentational Kudos section for the SAA 2025 Home screen (node 6885:9039).
///
/// Renders the Sun* Kudos banner, a short programme description, and a
/// "Chi tiết" CTA. No state management — all values injected via constructor.
class KudosSection extends StatelessWidget {
  const KudosSection({
    super.key,
    this.visible = true,
    this.onDetail,
  });

  final bool visible;
  final VoidCallback? onDetail;

  static const _gold = Color(0xFFFFEA9E);
  static const _darkBg = Color(0xFF00101A);
  static const _divider = Color(0xFF2E3940);
  static const _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: 335,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(l10n),
          const SizedBox(height: 12),
          _banner(),
          const SizedBox(height: 12),
          _noteArea(l10n),
          const SizedBox(height: 16),
          _detailButton(l10n),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _header(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeKudosBadge,
          style: _montserrat(
            fontSize: 12,
            weight: FontWeight.w400,
            color: _white,
          ),
        ),
        const SizedBox(height: 4),
        const Divider(color: _divider, thickness: 1, height: 1),
        const SizedBox(height: 4),
        // "Sun* Kudos" is the section title — not an ARB key; kept literal per design
        Text(
          'Sun* Kudos',
          style: _montserrat(
            fontSize: 22,
            weight: FontWeight.w500,
            color: _gold,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Banner
  // ---------------------------------------------------------------------------

  Widget _banner() {
    return SizedBox(
      width: 335,
      height: 145,
      // The banner PNG already has the "Sun* KUDOS" logo baked in (matches the
      // MoMorph export 6885:9041). Do NOT overlay Logo_Kudos.svg on top — that
      // produced a duplicated/offset logo that deviated from the design.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.65),
        child: Image.asset(
          'assets/images/home/Sunkudos_banner.png',
          width: 335,
          height: 145,
          fit: BoxFit.cover,
          errorBuilder: (ctx, e, st) => Container(
            width: 335,
            height: 145,
            color: const Color(0xFF0F0F0F),
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Note / badge area
  // ---------------------------------------------------------------------------

  Widget _noteArea(AppLocalizations l10n) {
    return SizedBox(
      width: 335,
      child: Text(
        l10n.homeKudosDescription,
        style: _montserrat(
          fontSize: 14,
          weight: FontWeight.w300,
          color: _white,
          height: 20 / 14,
          letterSpacing: 0.25,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Detail button
  // ---------------------------------------------------------------------------

  Widget _detailButton(AppLocalizations l10n) {
    return GestureDetector(
      onTap: onDetail,
      child: Container(
        width: 160,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                l10n.homeKudosDetail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _montserrat(
                  fontSize: 14,
                  weight: FontWeight.w500,
                  color: _darkBg,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/images/home/icon_arrow.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static TextStyle _montserrat({
    required double fontSize,
    required FontWeight weight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: fontSize,
      fontWeight: weight,
      // Montserrat.ttf is a variable font (default master = Thin); pin the
      // wght axis so the true designed weight renders instead of a thin/faux one.
      fontVariations: [FontVariation('wght', (weight.index + 1) * 100.0)],
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

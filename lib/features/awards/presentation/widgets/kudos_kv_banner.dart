import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_typography.dart';

/// Static "Hệ thống ghi nhận và cảm ơn" + Sun*Kudos logo banner (mms_A_KV Kudos).
///
/// From MoMorph: 221×67px block with two sub-groups:
///   - Group 424: tagline text (Montserrat 14 w500 gold)
///   - Group 380: Sun* Kudos logo row (49×38 saa_logo + 163×39 KUDOS wordmark)
///
/// H1 fix: Logo_RootFuther.png (Root Further wordmark) was the wrong brand mark.
/// The correct KUDOS wordmark is assets/images/home/Logo_Kudos.svg.
class KudosKvBanner extends StatelessWidget {
  const KudosKvBanner({super.key});

  static const _gold = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: 221,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group 424 — subtitle text
          Text(
            l10n.kudosKvTagline,
            style: AppTypography.montserrat(
              fontSize: 14,
              weight: FontWeight.w500,
              color: _gold,
              height: 20 / 14,
            ),
          ),
          const SizedBox(height: 8),
          // Group 380 — logo row: Sun* flame mark + KUDOS wordmark.
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sun* flame mark only. (Was logo_homepage.png, which bakes in an
              // extra "Sun* Annual Awards" wordmark next to the flame — redundant
              // beside the KUDOS wordmark and not in the design.)
              Image.asset(
                'assets/images/home/ic_kudos_flame.png',
                width: 40,
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(width: 40, height: 38),
              ),
              const SizedBox(width: 9),
              // KUDOS wordmark (163×39) — Logo_Kudos.svg (H1 fix: replaces wrong Logo_RootFuther.png)
              // SizedBox constrains the SVG to its design dimensions so the Row never overflows.
              SizedBox(
                width: 163,
                height: 39,
                child: SvgPicture.asset(
                  'assets/images/home/Logo_Kudos.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
          // Logo: Logo_Kudos.svg already contains BOTH the Sun* flame and the
          // "KUDOS" lettering, so no separate flame image is used (a separate one
          // doubled the flame). Height 38 per design; width follows the 119:22
          // aspect (~205px, fits the 221px banner).
          SizedBox(
            width: 205,
            height: 38,
            child: SvgPicture.asset(
              'assets/images/home/Logo_Kudos.svg',
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      ),
    );
  }
}

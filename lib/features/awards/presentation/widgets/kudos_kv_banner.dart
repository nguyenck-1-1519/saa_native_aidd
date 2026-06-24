import 'package:flutter/material.dart';

/// Static "Hệ thống ghi nhận và cảm ơn" + Sun*Kudos logo banner (mms_A_KV Kudos).
///
/// From MoMorph: 221×67px block with two sub-groups:
///   - Group 424: "Hệ thống ghi nhận và cảm ơn" text (Montserrat 14 w500 gold)
///   - Group 380: Sun* Kudos logo row (49×38 saa_logo + 163×39 KUDOS text group)
///
/// The KUDOS group is a vector logo not available as a standalone image in S3,
/// so we replicate the visible text styling from the design nodes.
class KudosKvBanner extends StatelessWidget {
  const KudosKvBanner({super.key});

  static const _gold = Color(0xFFFFEA9E);
  static const _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 221,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group 424 — subtitle text
          Text(
            'Hệ thống ghi nhận và cảm ơn',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _gold,
              height: 20 / 14,
            ),
          ),
          const SizedBox(height: 8),
          // Group 380 — logo row
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sun* Kudos SAA logo (49×38) — reuse home asset
              Image.asset(
                'assets/images/home/logo_homepage.png',
                width: 49,
                height: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(width: 49, height: 38),
              ),
              const SizedBox(width: 9),
              // KUDOS text group (163×39) — Logo_Kudos from home
              Image.asset(
                'assets/images/home/Logo_RootFuther.png',
                width: 163,
                height: 39,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Text(
                  'SUN* KUDOS',
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

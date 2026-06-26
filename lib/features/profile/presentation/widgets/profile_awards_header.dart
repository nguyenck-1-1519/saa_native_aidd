import 'package:flutter/material.dart';

/// Awards section header — "Sun* Annual Awards 2025" + "KUDOS" tab chip.
///
/// Design node: mms_4_header / mms_6_header (6885:10387 / 6885:10418)
/// Both self and other designs share the same header layout.
class ProfileAwardsHeader extends StatelessWidget {
  const ProfileAwardsHeader({super.key});

  static const Color _subtitleColor = Colors.white;
  static const Color _dividerColor = Color(0xFF2E3940);
  static const Color _chipBg = Color(0xFF001A2B);
  static const Color _chipText = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Sun* Annual Awards 2025"
        const Text(
          'Sun* Annual Awards 2025', // TODO(l10n): move to arb
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _subtitleColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, color: _dividerColor),
        const SizedBox(height: 4),
        // "KUDOS" chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _chipBg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'KUDOS',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _chipText,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

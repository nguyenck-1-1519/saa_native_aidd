import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

/// Icon collection section — row of dark circular badge slots + label.
///
/// Design node: mms_2_icon collection (6885:10349)
/// Row: up to 6 dark circular icons (32×32, bg #323231, border white 0.956px,
/// radius 47.782px), gap 14px.
/// Label below: "Bộ sưu tập icon của tôi" — Montserrat 12 Regular white, centred.
class ProfileIconCollection extends StatelessWidget {
  const ProfileIconCollection({
    super.key,
    required this.badgeCount,
  });

  /// How many badge slots to render (from Figma: 6).
  final int badgeCount;

  static const Color _badgeBg = Color(0xFF323231);
  static const Color _badgeBorder = Colors.white;
  static const Color _labelColor = Colors.white;
  static const double _badgeSize = 32;
  static const double _badgeBorderWidth = 0.956;
  static const double _rowGap = 14;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(badgeCount, (i) {
            final isLast = i == badgeCount - 1;
            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : _rowGap),
              child: const _IconBadgeSlot(),
            );
          }),
        ),
        const SizedBox(height: 12),
        // Label
        Text(
          // TODO(l10n): move to arb
          'Bộ sưu tập icon của tôi',
          style: AppTypography.montserrat(
            fontSize: 12,
            weight: FontWeight.w400,
            color: _labelColor,
            height: 16 / 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _IconBadgeSlot extends StatelessWidget {
  const _IconBadgeSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ProfileIconCollection._badgeSize,
      height: ProfileIconCollection._badgeSize,
      decoration: BoxDecoration(
        color: ProfileIconCollection._badgeBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: ProfileIconCollection._badgeBorder,
          width: ProfileIconCollection._badgeBorderWidth,
        ),
      ),
    );
  }
}

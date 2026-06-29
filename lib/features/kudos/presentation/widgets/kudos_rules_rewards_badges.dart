import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

// ---------------------------------------------------------------------------
// Design tokens (MoMorph zIuFaHAid4 "[iOS] Thể lệ")
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFFFEA9E);
const Color _kWhite = Colors.white;

// ---------------------------------------------------------------------------
// Collection section — "NGƯỜI GỬI KUDOS…" + intro + 6 collectible icons
// (node mms_4.3)
// ---------------------------------------------------------------------------

/// Labels for the six collectible SAA icons (node mms_4.3 → list).
const _kIconLabels = [
  'REVIVAL',
  'TOUCH OF LIGHT',
  'STAY GOLD',
  'FLOW TO HORIZON',
  'BEYOND THE BOUNDARY',
  'ROOT FURTHER',
];

class KudosCollectionSection extends StatelessWidget {
  const KudosCollectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtitle — gold, weight 400 per design (lighter than the first subtitle).
        Text(
          'NGƯỜI GỬI KUDOS: SƯU TẬP TRỌN BỘ 6 ICON, NHẬN NGAY PHẦN QUÀ BÍ ẨN',
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w400,
            color: _kGold,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Mỗi lời Kudos bạn gửi sẽ được đăng tải trên hệ thống và nhận về '
          'những lượt ❤️ từ cộng đồng Sunner. Cứ mỗi 5 lượt ❤️, bạn sẽ được mở '
          '1 Secret Box, với cơ hội nhận về một trong 6 icon độc quyền của SAA.',
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w400,
            color: _kWhite,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final label in _kIconLabels)
              Expanded(child: _CollectibleIcon(label: label)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Những Sunner thu thập trọn bộ 6 icon sẽ nhận về một phần quà bí ẩn '
          'từ SAA 2025.',
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w400,
            color: _kWhite,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }
}

/// One collectible icon: a 32px circular emblem + label. The emblem artwork is
/// MoMorph media that was not exported, so a styled placeholder circle stands
/// in (white rim, dark gold-tinted fill, sparkle glyph).
class _CollectibleIcon extends StatelessWidget {
  const _CollectibleIcon({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kWhite, width: 1),
            gradient: const RadialGradient(
              colors: [Color(0xFF3A2E12), Color(0xFF0A1720)],
            ),
          ),
          child: const Icon(Icons.auto_awesome, size: 14, color: _kGold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.montserrat(
            fontSize: 10,
            weight: FontWeight.w400,
            color: _kWhite,
            height: 16 / 10,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Kudos Quốc Dân (node mms_4.4)
// ---------------------------------------------------------------------------

class KudosQuocDanSection extends StatelessWidget {
  const KudosQuocDanSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KUDOS QUỐC DÂN',
          style: AppTypography.montserrat(
            fontSize: 18,
            weight: FontWeight.w700,
            color: _kGold,
            height: 24 / 18,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '5 Kudos nhận về nhiều ❤️ nhất toàn Sun* sẽ chính thức trở thành '
          'Kudos Quốc Dân và được trao phần quà đặc biệt từ SAA 2025: Root Further.',
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w400,
            color: _kWhite,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }
}

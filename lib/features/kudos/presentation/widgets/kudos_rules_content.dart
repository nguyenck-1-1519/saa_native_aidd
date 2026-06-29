import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

// ---------------------------------------------------------------------------
// Design tokens (MoMorph zIuFaHAid4 "[iOS] Thể lệ")
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFFFEA9E);
const Color _kWhite = Colors.white;

// ---------------------------------------------------------------------------
// Header — "Thể lệ" title + "NGƯỜI NHẬN KUDOS…" subtitle + intro paragraph
// (node mms_4.1)
// ---------------------------------------------------------------------------

class KudosRulesHeader extends StatelessWidget {
  const KudosRulesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Thể lệ" — 18px w700 gold
        Text(
          'Thể lệ',
          style: AppTypography.montserrat(
            fontSize: 18,
            weight: FontWeight.w700,
            color: _kGold,
            height: 24 / 18,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'NGƯỜI NHẬN KUDOS: HUY HIỆU HERO CHO NHỮNG ẢNH HƯỞNG TÍCH CỰC',
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w700,
            color: _kGold,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Dựa trên số lượng đồng đội gửi trao Kudos, bạn sẽ sở hữu Huy hiệu '
          'Hero tương ứng, được hiển thị trực tiếp cạnh tên profile',
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

// ---------------------------------------------------------------------------
// Hero tiers — New / Rising / Super / Legend Hero (node mms_4.2)
// ---------------------------------------------------------------------------

class _HeroTier {
  const _HeroTier(this.badgeWord, this.emphasis, this.count, this.description);

  /// First word of the badge ("New", "Rising", …); " Hero" is appended.
  final String badgeWord;

  /// Whether the badge word is rendered in gold (Rising/Super/Legend) vs white.
  final bool emphasis;
  final String count;
  final String description;
}

const _kDesc1 =
    'Hành trình lan tỏa điều tốt đẹp bắt đầu – những lời cảm ơn và ghi nhận '
    'đầu tiên đã tìm đến bạn.';
const _kDesc2 =
    'Bạn đã trở thành biểu tượng được tin tưởng và yêu quý, người luôn sẵn '
    'sàng hỗ trợ và được nhiều đồng đội nhớ đến.';

const _kTiers = [
  _HeroTier('New', false, 'Có 1-4 người gửi Kudos cho bạn', _kDesc1),
  _HeroTier('Rising', true, 'Có 5-9 người gửi Kudos cho bạn', _kDesc1),
  _HeroTier('Super', true, 'Có 10–20 người gửi Kudos cho bạn', _kDesc2),
  _HeroTier('Legend', true, 'Có hơn 20 người gửi Kudos cho bạn', _kDesc2),
];

/// The four Hero achievement tiers. The badge graphics are MoMorph media that
/// were not exported, so each badge is rendered as a styled pill approximating
/// the design (dark teal fill, gold rim, two-tone label).
class KudosHeroTiers extends StatelessWidget {
  const KudosHeroTiers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _kTiers.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          _TierBlock(tier: _kTiers[i]),
        ],
      ],
    );
  }
}

class _TierBlock extends StatelessWidget {
  const _TierBlock({required this.tier});

  final _HeroTier tier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroBadge(word: tier.badgeWord, emphasis: tier.emphasis),
        const SizedBox(height: 8),
        Text(
          tier.count,
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w700,
            color: _kWhite,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tier.description,
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

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.word, required this.emphasis});

  final String word;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xCC0A2230), // dark teal, translucent
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kGold, width: 0.5),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: word,
              style: AppTypography.montserrat(
                fontSize: 10,
                weight: FontWeight.w700,
                color: emphasis ? _kGold : _kWhite,
              ),
            ),
            TextSpan(
              text: ' Hero',
              style: AppTypography.montserrat(
                fontSize: 10,
                weight: FontWeight.w400,
                color: _kWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

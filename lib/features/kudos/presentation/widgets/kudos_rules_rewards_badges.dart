import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Shared design token (kept local — avoids cross-file const leakage)
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFFFEA9E);

// ---------------------------------------------------------------------------
// Rewards section — 3 icon + title + description rows
// ---------------------------------------------------------------------------

class _RewardEntry {
  const _RewardEntry({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

const _kRewards = [
  _RewardEntry(
    icon: Icons.emoji_events_outlined,
    title: 'Huy hiệu danh dự', // TODO(l10n): move to arb
    description: 'Nhận huy hiệu đặc biệt khi đạt milestones Kudos nổi bật.', // TODO(l10n)
  ),
  _RewardEntry(
    icon: Icons.star_outline,
    title: 'Điểm thưởng', // TODO(l10n): move to arb
    description: 'Tích lũy điểm từ Kudos nhận được, quy đổi thành phần thưởng.', // TODO(l10n)
  ),
  _RewardEntry(
    icon: Icons.leaderboard_outlined,
    title: 'Bảng xếp hạng', // TODO(l10n): move to arb
    description: 'Được vinh danh trên Spotlight Board của chương trình.', // TODO(l10n)
  ),
];

/// Rewards list: 3 icon-row entries matching the design's danh sách thưởng.
class KudosRewardsSection extends StatelessWidget {
  const KudosRewardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phần thưởng', // TODO(l10n): move to arb
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _kGold,
          ),
        ),
        const SizedBox(height: 12),
        ..._kRewards.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RewardRow(entry: r),
          ),
        ),
      ],
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({required this.entry});

  final _RewardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0A1720),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(entry.icon, color: _kGold, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 20 / 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                entry.description,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  height: 18 / 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

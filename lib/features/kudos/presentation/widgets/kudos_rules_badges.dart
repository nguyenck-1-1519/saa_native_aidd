import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Shared design tokens (kept local)
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFFFEA9E);
const Color _kDividerLine = Color(0xFF2E3940);

// ---------------------------------------------------------------------------
// 6 Kudos badge tiles
// ---------------------------------------------------------------------------

// 6 badges sourced from Figma design (screen b1Filzi9i6); intentionally broader
// than the 4-value HeroTag enum. Revisit if badges become data-driven.
const _kBadgeLabels = [
  'Rising Hero', // TODO(l10n): move to arb
  'Legend Hero', // TODO(l10n): move to arb
  'Team Spirit', // TODO(l10n): move to arb
  'Tech Master', // TODO(l10n): move to arb
  'Innovator', // TODO(l10n): move to arb
  'Mentor', // TODO(l10n): move to arb
];

/// 3-column grid of 6 Kudos achievement badge tiles.
class KudosBadgesSection extends StatelessWidget {
  const KudosBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Huy hiệu Kudos', // TODO(l10n): move to arb
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _kGold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
          children: _kBadgeLabels.map((l) => _BadgeTile(label: l)).toList(),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1720),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _kDividerLine, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/home/Award_BG.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  label.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: _kGold,
                    letterSpacing: 0.5,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

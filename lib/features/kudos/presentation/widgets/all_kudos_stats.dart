import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/kudos_stats.dart';

/// All Kudos Stats widget showing aggregate numbers for the current user.
///
/// Design source: MoMorph node mms_D.1_Thống kê tổng quat 6885:9223.
/// Outer container: bg #00070C, border 0.794px solid #998C5F, radius 8, padding 12.
class AllKudosStats extends StatelessWidget {
  const AllKudosStats({
    super.key,
    required this.stats,
    this.onOpenSecretBox,
  });

  final KudosStats stats;
  final VoidCallback? onOpenSecretBox;

  static const Color _dark = Color(0xFF00070C);
  static const Color _border = Color(0xFF998C5F);
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _dark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 0.794),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionHeader(title: 'ALL KUDOS'),
          const SizedBox(height: 12),
          _StatRow(
            label: 'Số Kudos bạn nhận được:',
            value: '${stats.received}',
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Số Kudos bạn đã gửi:',
            value: '${stats.sent}',
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: _divider),
          const SizedBox(height: 8),
          _StatRowWithBadge(
            label: 'Số tim bạn nhận được:',
            value: '${stats.heartsReceived}',
            badge: 'x2',
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Số Secret Box bạn đã mở:',
            value: '${stats.secretBoxOpened}',
          ),
          const SizedBox(height: 8),
          _StatRow(
            label: 'Số Secret Box chưa mở:',
            value: '${stats.secretBoxUnopened}',
          ),
          const SizedBox(height: 16),
          _OpenSecretBoxButton(onPressed: onOpenSecretBox),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sun* Annual Awards 2025',
          style: AppTypography.montserrat(
            fontSize: 12,
            weight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, color: _divider),
        const SizedBox(height: 4),
        // White section title per design (was gold).
        Text(
          title,
          style: AppTypography.montserrat(
            fontSize: 22,
            weight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ── Stat row ──────────────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.montserrat(
              fontSize: 14,
              weight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        // Value is white per design (was gold).
        Text(
          value,
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ── Stat row with badge ───────────────────────────────────────────────────────

class _StatRowWithBadge extends StatelessWidget {
  const _StatRowWithBadge({
    required this.label,
    required this.value,
    required this.badge,
  });

  final String label;
  final String value;
  final String badge;

  static const Color _gold = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.montserrat(
              fontSize: 14,
              weight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTypography.montserrat(
                fontSize: 14,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: _gold),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                badge,
                style: AppTypography.montserrat(
                  fontSize: 12,
                  weight: FontWeight.w700,
                  color: _gold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Open Secret Box button ────────────────────────────────────────────────────

class _OpenSecretBoxButton extends StatelessWidget {
  const _OpenSecretBoxButton({this.onPressed});

  final VoidCallback? onPressed;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _buttonText = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: _buttonText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mở Secret Box',
              style: AppTypography.montserrat(
                fontSize: 14,
                weight: FontWeight.w500,
                color: _buttonText,
              ),
            ),
            const SizedBox(width: 8),
            // Gift icon per design (was missing).
            const Icon(Icons.card_giftcard, size: 20, color: _buttonText),
          ],
        ),
      ),
    );
  }
}

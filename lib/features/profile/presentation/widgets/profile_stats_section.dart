import 'package:flutter/material.dart';

/// Stats block — shown on self-profile only.
///
/// Design node: mms_D.1_Thống kê tổng quat (6885:10358)
/// Container: bg #00070C, border 0.794px solid #998C5F, radius 8px, padding 12px.
/// Each stat row: label left (white 14px w400) + value right (gold #FFEA9E 14px w700).
/// Divider between kudos/hearts block and secret-box block: 1px #2E3940.
/// Button at bottom: "Mở Secret Box" — bg #FFEA9E, text #00101A, radius 4px, h 40.
class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({
    super.key,
    required this.kudosReceived,
    required this.kudosSent,
    required this.heartsReceived,
    required this.secretBoxOpened,
    required this.secretBoxUnopened,
    this.onOpenSecretBox,
  });

  final int kudosReceived;
  final int kudosSent;
  final int heartsReceived;
  final int secretBoxOpened;
  final int secretBoxUnopened;
  final VoidCallback? onOpenSecretBox;

  static const Color _containerBg = Color(0xFF00070C);
  static const Color _border = Color(0xFF998C5F);
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _containerBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 0.794),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // D.1.2 — Kudos received
          _StatRow(
            // TODO(l10n): move to arb
            label: 'Số Kudos bạn nhận được',
            value: '$kudosReceived',
          ),
          const SizedBox(height: 12),
          // D.1.3 — Kudos sent
          _StatRow(
            // TODO(l10n): move to arb
            label: 'Số Kudos bạn đã gửi',
            value: '$kudosSent',
          ),
          const SizedBox(height: 12),
          // D.1.4 — Hearts received
          _StatRow(
            // TODO(l10n): move to arb
            label: 'Số tim bạn nhận được',
            value: '$heartsReceived',
          ),
          const SizedBox(height: 12),
          // D.1.5 — Divider
          Container(height: 1, color: _divider),
          const SizedBox(height: 12),
          // D.1.6 — Secret box opened
          _StatRow(
            // TODO(l10n): move to arb
            label: 'Số Secret Box bạn đã mở',
            value: '$secretBoxOpened',
          ),
          const SizedBox(height: 12),
          // D.1.7 — Secret box unopened
          _StatRow(
            // TODO(l10n): move to arb
            label: 'Số Secret Box chưa mở',
            value: '$secretBoxUnopened',
          ),
          const SizedBox(height: 16),
          // Open secret box button
          _OpenSecretBoxButton(onPressed: onOpenSecretBox),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat row
// ---------------------------------------------------------------------------

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});

  final String label;
  final String value;

  static const Color _labelColor = Colors.white;
  static const Color _valueColor = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _labelColor,
              height: 20 / 14,
              letterSpacing: 0.25,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _valueColor,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Open Secret Box button
// ---------------------------------------------------------------------------

class _OpenSecretBoxButton extends StatelessWidget {
  const _OpenSecretBoxButton({this.onPressed});

  final VoidCallback? onPressed;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _textColor = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _gold,
          foregroundColor: _textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: const Text(
          // TODO(l10n): move to arb
          'Mở Secret Box',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _textColor,
          ),
        ),
      ),
    );
  }
}

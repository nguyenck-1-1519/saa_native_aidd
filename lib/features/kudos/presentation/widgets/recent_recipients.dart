import 'package:flutter/material.dart';
import '../../domain/entities/kudo_recipient.dart';

/// Displays the 10 most recent gift recipients.
///
/// Design source: MoMorph node mms_D.3_10 SUNNER nhận quà (6885:9255).
/// Container: bg #00070C, border 0.794px solid #998C5F, border-radius 8, padding 12.
class RecentRecipients extends StatelessWidget {
  const RecentRecipients({super.key, required this.recipients});

  final List<KudoRecipient> recipients;

  // ── palette ─────────────────────────────────────────────────────────────────
  static const Color _darkBg = Color(0xFF00070C);
  static const Color _border = Color(0xFF998C5F);

  @override
  Widget build(BuildContext context) {
    final visible = recipients.take(10).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _darkBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border, width: 0.794),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionTitle(),
          if (visible.isNotEmpty) const SizedBox(height: 8),
          ...visible.map((r) => _RecipientRow(recipient: r)),
        ],
      ),
    );
  }
}

// ── Section title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '10 SUNNER NHẬN QUÀ MỚI NHẤT',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFFFFEA9E),
      ),
    );
  }
}

// ── Recipient row ────────────────────────────────────────────────────────────

class _RecipientRow extends StatelessWidget {
  const _RecipientRow({required this.recipient});

  final KudoRecipient recipient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: SizedBox(
        height: 38,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Avatar(avatarUrl: recipient.avatarUrl),
            const SizedBox(width: 6),
            Expanded(
              child: _NameGiftColumn(
                name: recipient.name,
                giftDescription: recipient.giftDescription,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Avatar ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: Colors.white, width: 1.483),
        ),
      ),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xFF444444),
        backgroundImage:
            avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null
            ? const Icon(Icons.person, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}

// ── Name + gift text column ───────────────────────────────────────────────────

class _NameGiftColumn extends StatelessWidget {
  const _NameGiftColumn({
    required this.name,
    required this.giftDescription,
  });

  final String name;
  final String giftDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFEA9E),
          ),
        ),
        Text(
          giftDescription,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

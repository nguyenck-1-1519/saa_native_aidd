// Private helper widgets for ViewKudoScreen — card structure and person columns.
// Do NOT import this file directly — use view_kudo_screen.dart.
part of 'view_kudo_screen.dart';

// Design tokens (shared across all parts)
const Color _kGold = Color(0xFFFFEA9E);
const Color _kCardBg = Color(0xFFFFF8E1);
const Color _kCardText = Color(0xFF00101A);
const Color _kHashtagColor = Color(0xFF998C5F);
const Color _kTimestamp = Color(0xFF999999);
const Color _kDivider = Color(0xFFFFEA9E);
const Color _kHeartRed = Color(0xFFFF6B6B);
const Color _kAnonSubtitle = Color(0xFF888888);

// ── Full detail card ─────────────────────────────────────────────────────────

class _KudoDetailCard extends StatelessWidget {
  const _KudoDetailCard({
    required this.kudo,
    this.onCopyLink,
    this.onTapSender,
    this.onTapRecipient,
  });

  final KudoDetailViewModel kudo;
  final VoidCallback? onCopyLink;
  final VoidCallback? onTapSender;
  final VoidCallback? onTapRecipient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kGold),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // B.3 — Sender/Recipient highlight row
          _HighlightRow(
            kudo: kudo,
            onTapSender: onTapSender,
            onTapRecipient: onTapRecipient,
          ),
          const SizedBox(height: 10),
          _HorizontalDivider(),
          const SizedBox(height: 10),
          // B.4 — Content block
          _ContentSection(kudo: kudo, onCopyLink: onCopyLink),
        ],
      ),
    );
  }
}

// ── B.3 Highlight row ────────────────────────────────────────────────────────

/// Sender (left) → arrow → Recipient (right)
///
/// Anonymous branch: sender shows "Anh Hùng Xạ Điêu" + "Người gửi ẩn danh"
/// subtitle instead of real name/role chip.
class _HighlightRow extends StatelessWidget {
  const _HighlightRow({
    required this.kudo,
    this.onTapSender,
    this.onTapRecipient,
  });

  final KudoDetailViewModel kudo;
  final VoidCallback? onTapSender;
  final VoidCallback? onTapRecipient;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: kudo.isAnonymous ? null : onTapSender,
            child: kudo.isAnonymous
                ? _AnonSenderColumn(
                    displayName: kudo.senderName,
                    avatarUrl: kudo.senderAvatarUrl,
                  )
                : _PersonColumn(
                    name: kudo.senderName,
                    avatarUrl: kudo.senderAvatarUrl,
                    heroTag: kudo.senderHeroTag,
                    subLabel: null,
                  ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 20, color: _kGold),
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTapRecipient,
            child: _PersonColumn(
              name: kudo.recipientName,
              avatarUrl: kudo.recipientAvatarUrl,
              heroTag: kudo.recipientHeroTag,
              subLabel: kudo.recipientCode,
            ),
          ),
        ),
      ],
    );
  }
}

/// Person column used for the recipient, and for the sender when NOT anonymous.
///
/// Layout (top → bottom): avatar, name, [subLabel], [heroTag chip]
class _PersonColumn extends StatelessWidget {
  const _PersonColumn({
    required this.name,
    required this.avatarUrl,
    required this.heroTag,
    required this.subLabel,
  });

  final String name;
  final String? avatarUrl;
  final String? heroTag;
  final String? subLabel; // e.g. "CECV10"

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Avatar(url: avatarUrl, size: 44),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _kGold,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        if (subLabel != null && subLabel!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            subLabel!,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (heroTag != null && heroTag!.isNotEmpty) ...[
          const SizedBox(height: 4),
          _HeroTagChip(label: heroTag!),
        ],
      ],
    );
  }
}

/// Sender column shown when [KudoDetailViewModel.isAnonymous] == true.
///
/// Shows display name (e.g. "Anh Hùng Xạ Điêu") + "Người gửi ẩn danh" subtitle.
/// No hero tag chip — sender identity is masked.
class _AnonSenderColumn extends StatelessWidget {
  const _AnonSenderColumn({
    required this.displayName,
    required this.avatarUrl,
  });

  final String displayName;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Avatar(url: avatarUrl, size: 44, isAnonymous: true),
        const SizedBox(height: 4),
        Text(
          displayName,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _kGold,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        const Text(
          'Người gửi ẩn danh',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: _kAnonSubtitle,
          ),
          textAlign: TextAlign.center,
        ),
        // No hero tag chip for anonymous sender
      ],
    );
  }
}

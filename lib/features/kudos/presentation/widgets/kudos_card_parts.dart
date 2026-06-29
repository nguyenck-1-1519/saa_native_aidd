// Private helper widgets for KudosCard.
// Do NOT import this file directly — use kudos_card.dart.
part of 'kudos_card.dart';

// ── Trao → Nhận row ──────────────────────────────────────────────────────────

class _TraoNhanRow extends StatelessWidget {
  const _TraoNhanRow({
    required this.senderName,
    required this.senderRole,
    required this.recipientName,
    required this.recipientRole,
  });

  final String senderName, senderRole, recipientName, recipientRole;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: _InfoColumn(name: senderName, role: senderRole)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            // Dark navy on the cream card (was gold — low contrast).
            child: Icon(Icons.send, size: 16, color: Color(0xFF00101A)),
          ),
          Expanded(
              child: _InfoColumn(name: recipientName, role: recipientRole)),
        ],
      );
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({required this.name, required this.role});

  final String name, role;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFBDBDBD),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            // Dark navy on the cream card (was gold — nearly invisible).
            style: AppTypography.montserrat(
              fontSize: 14,
              weight: FontWeight.w700,
              color: const Color(0xFF00101A),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            role,
            // Muted grey on the cream card (was white — invisible).
            style: AppTypography.montserrat(
              fontSize: 12,
              weight: FontWeight.w400,
              color: const Color(0xFF6E6E6E),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
}

// ── Divider ───────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: const Color(0xFFFFEA9E));
}

// ── Content block ─────────────────────────────────────────────────────────────

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({
    required this.timeRange,
    required this.title,
    required this.message,
    required this.hashtags,
  });

  final String timeRange, title, message;
  final List<String> hashtags;

  // Hashtags are brand red per design (was olive/brown).
  static final _hashtagStyle = AppTypography.montserrat(
    fontSize: 10,
    weight: FontWeight.w400,
    color: const Color(0xFFE73928),
  );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(timeRange,
              style: AppTypography.montserrat(
                fontSize: 10,
                weight: FontWeight.w500,
                color: const Color(0xFF999999),
              )),
          const SizedBox(height: 2),
          Text(title,
              textAlign: TextAlign.center,
              style: AppTypography.montserrat(
                fontSize: 12,
                weight: FontWeight.w700,
                color: const Color(0xFF00101A),
              )),
          const SizedBox(height: 4),
          Text(message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.montserrat(
                fontSize: 12,
                weight: FontWeight.w400,
                color: const Color(0xFF00101A),
              )),
          if (hashtags.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children:
                  hashtags.map((t) => Text(t, style: _hashtagStyle)).toList(),
            ),
          ],
        ],
      );
}

// ── Action row ────────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.heartCount, this.onViewDetail});

  final int heartCount;
  final VoidCallback? onViewDetail;

  // Dark navy on the cream card (was white — invisible).
  static const Color _dark = Color(0xFF00101A);
  static final _btnTextStyle = AppTypography.montserrat(
    fontSize: 10,
    weight: FontWeight.w400,
    color: _dark,
  );

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(Icons.favorite, size: 12, color: Color(0xFFE73928)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$heartCount',
              style: AppTypography.montserrat(
                fontSize: 10,
                weight: FontWeight.w500,
                color: _dark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Copy Link', style: _btnTextStyle,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(width: 2),
                const Icon(Icons.link, size: 14, color: _dark),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onViewDetail,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Xem chi tiết', style: _btnTextStyle,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(width: 2),
                SvgPicture.asset(
                  'assets/images/home/icon_arrow.svg',
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(_dark, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ],
      );
}

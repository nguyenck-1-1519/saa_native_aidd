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
            child:
                Icon(Icons.arrow_forward, size: 16, color: Color(0xFFFFEA9E)),
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
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFFEA9E),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            role,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white,
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

  static const _hashtagStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Color(0xFF998C5F),
  );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(timeRange,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF999999),
              )),
          const SizedBox(height: 2),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00101A),
              )),
          const SizedBox(height: 4),
          Text(message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF00101A),
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

  static const _btnTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(Icons.favorite, size: 12, color: Color(0xFFFF6B6B)),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$heartCount',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: null,
            child: const Text('Copy Link', style: _btnTextStyle,
                overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onViewDetail,
            child: const Text('Xem chi tiết', style: _btnTextStyle,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );
}

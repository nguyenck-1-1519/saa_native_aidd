import 'package:flutter/material.dart';

import '../notifications_screen.dart';

/// A single row in the notifications list.
///
/// Read state: unread = bold body text + red dot indicator.
/// Read state: normal weight text + no indicator.
///
/// [onTap] fires when the row is tapped — the caller (route wrapper) is
/// responsible for marking the item read and then deep-linking.  Do NOT wire
/// [onMarkRead] to the same tap; doing so would fire markRead twice per tap.
/// [onMarkRead] is kept as a separate affordance in case the design ever adds
/// a dedicated per-item read button (e.g. a swipe action).
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.item,
    this.onTap,
    this.onMarkRead,
  });

  final NotificationItemView item;
  final ValueChanged<String>? onTap;

  /// Optional separate affordance to mark a single item read without tapping
  /// the whole row (e.g. future swipe action).  Not wired to the row tap.
  final ValueChanged<String>? onMarkRead;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap?.call(item.id),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF2E3940), width: 1),
          ),
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading icon
            SizedBox(
              width: 24,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: _NotificationIcon(typeKey: item.typeKey),
              ),
            ),
            const SizedBox(width: 16),
            // Content: body text + time label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.isNotEmpty ? item.title : item.body,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: item.isRead
                          ? FontWeight.w400
                          : FontWeight.w700, // unread = bold
                      color: Colors.white,
                      height: 20 / 14,
                      letterSpacing: 0.25,
                    ),
                  ),
                  if (item.body.isNotEmpty && item.title.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: item.isRead
                            ? FontWeight.w400
                            : FontWeight.w700,
                        color: Colors.white,
                        height: 20 / 14,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    item.timeLabel,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),
            ),
            // Unread indicator (red dot)
            if (!item.isRead) ...[
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: _UnreadDot(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 8×8 red dot shown on unread items (spec B.1.3).
class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFFD4271D),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Leading icon per [typeKey]. All 7 notification types mapped.
/// Assets are null in S3 — falling back to Material icons per spec.
class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.typeKey});

  final String typeKey;

  @override
  Widget build(BuildContext context) {
    final (iconData, color) = _iconForType(typeKey);
    return Icon(iconData, size: 24, color: color);
  }

  static (IconData, Color) _iconForType(String key) {
    switch (key) {
      case 'kudos': // Nhận lời ghi nhận — envelope blue
        return (Icons.mail_outline, const Color(0xFF4A9EFF));
      case 'heart': // Nhận lượt tim — heart pink
        return (Icons.favorite_border, const Color(0xFFFF6B9D));
      case 'secretBox': // Mở Secret Box — gift green
        return (Icons.card_giftcard, const Color(0xFF4CAF50));
      case 'levelUp': // Thăng hạng — star yellow
        return (Icons.star_border, const Color(0xFFFFD700));
      case 'warning': // Lời nhắn bị tạm ẩn — warning triangle yellow
        return (Icons.warning_amber_outlined, const Color(0xFFFFB300));
      case 'badge': // Thu thập huy hiệu — shield blue
        return (Icons.shield_outlined, const Color(0xFF4A9EFF));
      case 'review': // Cần xem xét (admin) — edit purple
        return (Icons.edit_outlined, const Color(0xFFAB47BC));
      case 'system': // Fallback
      default:
        return (Icons.notifications_outlined, const Color(0xFF9E9E9E));
    }
  }
}

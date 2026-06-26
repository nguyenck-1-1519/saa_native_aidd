import 'package:flutter/material.dart';

import 'notifications_mock_data.dart';
import 'widgets/notification_item.dart';
import 'widgets/notifications_empty_state.dart';
import 'widgets/notifications_mark_all_button.dart';
import 'widgets/notifications_nav_bar.dart';

// ---------------------------------------------------------------------------
// View-model (pure data — no domain import required)
// ---------------------------------------------------------------------------

/// Flat view-model for one notification row.
///
/// [typeKey] drives the leading icon:
///   'kudos'     → envelope (blue)    — Nhận lời ghi nhận
///   'heart'     → heart (pink)       — Nhận lượt tim
///   'secretBox' → gift (green)       — Mở Secret Box
///   'levelUp'   → star (yellow)      — Thăng hạng level
///   'warning'   → warning (yellow)   — Lời nhắn bị tạm ẩn
///   'badge'     → shield (blue)      — Thu thập huy hiệu
///   'review'    → edit (purple)      — Cần xem xét (admin)
///   'system'    → bell (grey)        — Fallback
class NotificationItemView {
  const NotificationItemView({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.isRead,
    required this.typeKey,
  });

  final String id;

  /// Primary line. Pass empty string to use [body] as the only text line.
  final String title;

  /// Body text. Used as the sole line when [title] is empty.
  final String body;

  /// Relative time label — e.g. "15 phút trước", "1 giờ trước".
  final String timeLabel;

  final bool isRead;

  /// One of: kudos | heart | secretBox | levelUp | warning | badge | review | system
  final String typeKey;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Notifications list screen (F007) — pure presentational, no providers.
///
/// INT layer wires [items], [onTapItem], [onMarkRead], [onMarkAllRead] to
/// real providers. Until then the screen renders [_kMockItems].
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({
    super.key,
    List<NotificationItemView>? items,
    this.onTapItem,
    this.onMarkRead,
    this.onMarkAllRead,
  }) : items = items ?? kNotificationsMockItems;

  final List<NotificationItemView> items;
  final ValueChanged<String>? onTapItem;
  final ValueChanged<String>? onMarkRead;
  final VoidCallback? onMarkAllRead;

  static const Color _bgColor = Color(0xFF00101A);
  static const double _hPad = 20;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _bgColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Key-visual BG image (shared asset, same as Home/Kudos/Awards).
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/home/Keyvisual_BG.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          // Dark gradient overlay (matches design TopNavigation bg group).
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.7644, 0.8462, 0.887, 0.9279, 0.9639, 1.0],
                  colors: [
                    Color(0xFF00101A),
                    Color(0x4D00101A),
                    Color(0x3300101A),
                    Color(0x2600101A),
                    Color(0x1A00101A),
                    Color(0x0D00101A),
                    Color(0x0000101A),
                  ],
                ),
              ),
            ),
          ),
          // Scrollable content
          CustomScrollView(
            slivers: [
              // Space for iOS status bar (47px) — sits under the gradient.
              SliverToBoxAdapter(
                child: SizedBox(height: topPadding + 47),
              ),
              // Pinned nav bar (42px content area per design).
              SliverPersistentHeader(
                pinned: true,
                delegate: NotificationsNavBarDelegate(topPadding: topPadding),
              ),
              // "Mark all read" button (spec A.1).
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 0, _hPad, 0),
                  child: NotificationsMarkAllButton(onTap: onMarkAllRead),
                ),
              ),
              // List or empty state.
              if (items.isEmpty)
                const SliverFillRemaining(
                  child: NotificationsEmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 0, _hPad, 40),
                  sliver: SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => NotificationItem(
                      item: items[index],
                      onTap: onTapItem,
                      onMarkRead: onMarkRead,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

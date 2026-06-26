import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../features/awards/presentation/providers/awards_providers.dart';
import '../../features/notifications/domain/entities/app_notification.dart';
import '../../features/notifications/domain/entities/notification_type.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/notifications/presentation/providers/notifications_providers.dart';
import 'app_router.dart';

/// ConsumerWidget wrapper that binds [NotificationsScreen] to
/// [notificationsControllerProvider].
///
/// Kept in a separate file to keep [app_router.dart] under 200 lines.
/// Package-private — only [app_router.dart] instantiates it.
class NotificationsRouteWrapper extends ConsumerWidget {
  const NotificationsRouteWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsControllerProvider);
    final controller = ref.read(notificationsControllerProvider.notifier);

    return notificationsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF00101A),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          backgroundColor: const Color(0xFF00101A),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.notificationsError,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(notificationsControllerProvider),
                  child: Text(
                    l10n.notificationsRetry,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      data: (notifications) => NotificationsScreen(
        items: notifications.map(_toItemView).toList(),
        onTapItem: (id) {
          final notification = _findById(notifications, id);
          if (notification == null) return;
          // Mark read first so badge decrements even if the user backs out.
          controller.markRead(id);
          _resolveDeepLink(context, ref, notification);
        },
        onMarkRead: (id) => controller.markRead(id),
        onMarkAllRead: () => controller.markAllRead(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mapping helpers
  // ---------------------------------------------------------------------------

  static NotificationItemView _toItemView(AppNotification n) {
    return NotificationItemView(
      id: n.id,
      title: n.title,
      body: n.body,
      timeLabel: _relativeTime(n.createdAt),
      isRead: n.isRead,
      typeKey: _typeKey(n.type),
    );
  }

  static String _typeKey(NotificationType type) {
    switch (type) {
      case NotificationType.kudos:
        return 'kudos';
      case NotificationType.award:
        return 'badge';
      case NotificationType.secretBox:
        return 'secretBox';
      case NotificationType.system:
        return 'system';
    }
  }

  /// Produces a human-readable relative time label (Vietnamese).
  // TODO(l10n): relative-time formatting is backlog — replace with
  // flutter_timeago or intl-based solution when date formatting is scoped.
  static String _relativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 30) return '${diff.inDays} ngày trước';
    final months = (diff.inDays / 30).floor();
    if (months < 12) return '$months tháng trước';
    final years = (diff.inDays / 365).floor();
    return '$years năm trước';
  }

  static AppNotification? _findById(
    List<AppNotification> notifications,
    String id,
  ) {
    try {
      return notifications.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Deep-link resolver (free function keeps wrapper build() clean)
// ---------------------------------------------------------------------------

/// Resolves the deep-link action for a tapped [AppNotification].
///
/// Rules:
/// - kudos + deepLinkTarget → push `/kudos/detail/:target`
/// - kudos (no target)      → no-op (already marked read above)
/// - award + deepLinkTarget → set selectedAwardIdProvider, go to awards tab
/// - award (no target)      → go to awards tab
/// - secretBox              → go to /secret-box
/// - system                 → no-op
void _resolveDeepLink(
  BuildContext context,
  WidgetRef ref,
  AppNotification notification,
) {
  switch (notification.type) {
    case NotificationType.kudos:
      final target = notification.deepLinkTarget;
      if (target != null && target.isNotEmpty) {
        context.push(Routes.kudoDetailPath(target));
      }

    case NotificationType.award:
      final target = notification.deepLinkTarget;
      if (target != null && target.isNotEmpty) {
        ref.read(selectedAwardIdProvider.notifier).state = target;
      }
      // /notifications is outside the shell; use go() to land on the awards tab.
      context.go(Routes.awards);

    case NotificationType.secretBox:
      context.push(Routes.secretBox);

    case NotificationType.system:
      // System notifications are informational — mark read is sufficient.
      break;
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/stub_notification_feed_repository.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_feed_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_all_notifications_read.dart';
import '../../domain/usecases/mark_notification_read.dart';

// ---------------------------------------------------------------------------
// Repository DI — singleton (NOT autoDispose) so in-memory read-state
// survives navigation away and back (see phase-02 R1).
// ---------------------------------------------------------------------------

final notificationFeedRepositoryProvider = Provider<NotificationFeedRepository>(
  (_) => StubNotificationFeedRepository(),
);

// ---------------------------------------------------------------------------
// Usecase DI
// ---------------------------------------------------------------------------

final getNotificationsProvider = Provider<GetNotifications>(
  (ref) => GetNotifications(ref.watch(notificationFeedRepositoryProvider)),
);

final markNotificationReadProvider = Provider<MarkNotificationRead>(
  (ref) =>
      MarkNotificationRead(ref.watch(notificationFeedRepositoryProvider)),
);

final markAllNotificationsReadProvider = Provider<MarkAllNotificationsRead>(
  (ref) =>
      MarkAllNotificationsRead(ref.watch(notificationFeedRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// NotificationsController — AsyncNotifier<List<AppNotification>>
// ---------------------------------------------------------------------------

/// Loads and mutates the notification feed.
///
/// Exposes [refresh], [markRead], and [markAllRead] so the UI can act on
/// individual items or the full list. State changes here automatically
/// propagate to [notificationsUnreadCountProvider].
class NotificationsController
    extends AsyncNotifier<List<AppNotification>> {
  @override
  FutureOr<List<AppNotification>> build() =>
      ref.watch(getNotificationsProvider).call();

  /// Re-fetches the list from the repository (e.g. pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getNotificationsProvider).call(),
    );
  }

  /// Marks a single notification as read and updates state atomically.
  ///
  /// On success the state is updated so the badge decrements immediately.
  /// On failure the state transitions to [AsyncError] so the UI can react
  /// (e.g. the route wrapper shows a SnackBar via the error branch).
  Future<void> markRead(String id) async {
    final updated = await AsyncValue.guard(
      () => ref.read(markNotificationReadProvider).call(id),
    );
    if (updated.hasValue) {
      state = AsyncData(updated.requireValue);
    } else if (updated.hasError) {
      state = AsyncError(updated.error!, updated.stackTrace!);
    }
  }

  /// Marks all notifications as read and updates state atomically.
  ///
  /// On success all unread badges clear immediately.
  /// On failure the state transitions to [AsyncError] so the UI can react.
  Future<void> markAllRead() async {
    final updated = await AsyncValue.guard(
      () => ref.read(markAllNotificationsReadProvider).call(),
    );
    if (updated.hasValue) {
      state = AsyncData(updated.requireValue);
    } else if (updated.hasError) {
      state = AsyncError(updated.error!, updated.stackTrace!);
    }
  }
}

final notificationsControllerProvider =
    AsyncNotifierProvider<NotificationsController, List<AppNotification>>(
  NotificationsController.new,
);

// ---------------------------------------------------------------------------
// Derived unread count — single source of truth
// ---------------------------------------------------------------------------

/// Number of unread notifications derived from the controller state.
///
/// Returns 0 while loading or on error so the badge never shows a stale count.
/// Consumers re-render automatically whenever the controller state changes.
final notificationsUnreadCountProvider = Provider<int>((ref) {
  final notifications =
      ref.watch(notificationsControllerProvider).valueOrNull;
  if (notifications == null) return 0;
  return notifications.where((n) => !n.isRead).length;
});

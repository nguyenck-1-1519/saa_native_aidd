import '../entities/app_notification.dart';

/// Contract for reading and mutating the notification feed.
///
/// All mutating methods return the **full updated list** so the controller
/// can re-derive the unread count in one round-trip (single source of truth).
/// Throws [Failure] subtypes on error — no Either wrapper (standards §5).
abstract interface class NotificationFeedRepository {
  /// Returns the current notification list, newest first.
  Future<List<AppNotification>> getNotifications();

  /// Marks the notification with [id] as read and returns the updated list.
  Future<List<AppNotification>> markAsRead(String id);

  /// Marks all notifications as read and returns the updated list.
  Future<List<AppNotification>> markAllAsRead();
}

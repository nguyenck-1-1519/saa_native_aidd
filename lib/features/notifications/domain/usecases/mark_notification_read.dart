import '../entities/app_notification.dart';
import '../repositories/notification_feed_repository.dart';

/// Marks a single notification as read and returns the full updated list.
class MarkNotificationRead {
  const MarkNotificationRead(this._repository);

  final NotificationFeedRepository _repository;

  Future<List<AppNotification>> call(String id) =>
      _repository.markAsRead(id);
}

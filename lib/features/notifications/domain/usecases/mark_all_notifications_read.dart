import '../entities/app_notification.dart';
import '../repositories/notification_feed_repository.dart';

/// Marks all notifications as read and returns the full updated list.
class MarkAllNotificationsRead {
  const MarkAllNotificationsRead(this._repository);

  final NotificationFeedRepository _repository;

  Future<List<AppNotification>> call() => _repository.markAllAsRead();
}

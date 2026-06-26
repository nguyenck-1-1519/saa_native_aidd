import '../entities/app_notification.dart';
import '../repositories/notification_feed_repository.dart';

/// Returns the current notification list from the repository.
class GetNotifications {
  const GetNotifications(this._repository);

  final NotificationFeedRepository _repository;

  Future<List<AppNotification>> call() => _repository.getNotifications();
}

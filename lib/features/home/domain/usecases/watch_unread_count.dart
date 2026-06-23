import '../repositories/notification_repository.dart';

/// Subscribes to the unread notification count stream.
///
/// Delegates to [NotificationRepository]. The stream is consumed by a
/// [StreamProvider] in the presentation layer.
class WatchUnreadCount {
  const WatchUnreadCount(this._repository);

  final NotificationRepository _repository;

  Stream<int> call() => _repository.watchUnreadCount();
}

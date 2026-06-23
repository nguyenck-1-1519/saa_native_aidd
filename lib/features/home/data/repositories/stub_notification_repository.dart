import '../../domain/repositories/notification_repository.dart';

/// Stub implementation of [NotificationRepository] for development and QA.
///
/// Emits a single unread count immediately, then holds the stream open.
/// Default [unreadCount] is 3 (>0) so the notification badge is visible.
/// Pass 0 to verify the badge-hidden state.
class StubNotificationRepository implements NotificationRepository {
  StubNotificationRepository({this.unreadCount = 3});

  final int unreadCount;

  @override
  Stream<int> watchUnreadCount() async* {
    yield unreadCount;
    // Stream suspends naturally after the last yield — no timer needed.
  }
}

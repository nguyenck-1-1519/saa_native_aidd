/// Contract for streaming the notification unread count.
///
/// Implementations live in `data/repositories/`. The stream never closes
/// under normal operation — the presentation layer subscribes for the lifetime
/// of the shell.
abstract interface class NotificationRepository {
  /// Stream of unread notification counts. Emits 0 when nothing is unread.
  Stream<int> watchUnreadCount();
}

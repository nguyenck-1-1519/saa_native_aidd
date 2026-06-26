import '../../../../core/error/failures.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_feed_repository.dart';
import '../sources/notifications_mock_data.dart';

/// Behavior modes for [StubNotificationFeedRepository].
enum StubNotificationFeedBehavior { data, empty, error }

/// Stub implementation of [NotificationFeedRepository] for development and QA.
///
/// Holds a mutable in-memory list seeded from [NotificationsMockData.items].
/// Mark-read operations mutate the list in place so the badge decrements live
/// during a session — provided this instance is kept as a singleton (i.e. the
/// provider is NOT autoDispose).
///
///   - [StubNotificationFeedBehavior.data]  → returns the in-memory list
///   - [StubNotificationFeedBehavior.empty] → returns an empty list
///   - [StubNotificationFeedBehavior.error] → throws [UnknownFailure]
class StubNotificationFeedRepository implements NotificationFeedRepository {
  StubNotificationFeedRepository({
    this.behavior = StubNotificationFeedBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  }) : _items = List.of(NotificationsMockData.items);

  final StubNotificationFeedBehavior behavior;
  final Duration delay;

  /// Mutable in-memory list — mutated by mark-read operations.
  List<AppNotification> _items;

  @override
  Future<List<AppNotification>> getNotifications() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubNotificationFeedBehavior.data => List.of(_items),
      StubNotificationFeedBehavior.empty => const [],
      StubNotificationFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated notifications fetch error'),
    };
  }

  @override
  Future<List<AppNotification>> markAsRead(String id) async {
    await Future<void>.delayed(delay);
    if (behavior == StubNotificationFeedBehavior.error) {
      throw const UnknownFailure('Stub: simulated markAsRead error');
    }
    _items = _items
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    return List.of(_items);
  }

  @override
  Future<List<AppNotification>> markAllAsRead() async {
    await Future<void>.delayed(delay);
    if (behavior == StubNotificationFeedBehavior.error) {
      throw const UnknownFailure('Stub: simulated markAllAsRead error');
    }
    _items = _items.map((n) => n.copyWith(isRead: true)).toList();
    return List.of(_items);
  }
}

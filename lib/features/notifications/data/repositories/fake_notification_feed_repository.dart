import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_feed_repository.dart';
import '../sources/notifications_mock_data.dart';

/// Deterministic, delay-free [NotificationFeedRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.data()`    → returns design-sourced notifications immediately
///   - `.empty()`   → returns an empty list immediately
///   - `.error()`   → throws [UnknownFailure] immediately
///   - `.loading()` → never resolves — pins the controller in loading state
class FakeNotificationFeedRepository implements NotificationFeedRepository {
  FakeNotificationFeedRepository._({
    required Future<List<AppNotification>> Function() getHandler,
    required Future<List<AppNotification>> Function(String id) markReadHandler,
    required Future<List<AppNotification>> Function() markAllReadHandler,
  })  : _getHandler = getHandler,
        _markReadHandler = markReadHandler,
        _markAllReadHandler = markAllReadHandler;

  factory FakeNotificationFeedRepository.data() {
    final items = List.of(NotificationsMockData.items);
    return FakeNotificationFeedRepository._(
      getHandler: () async => List.of(items),
      markReadHandler: (id) async => items
          .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
          .toList(),
      markAllReadHandler: () async =>
          items.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  factory FakeNotificationFeedRepository.empty() =>
      FakeNotificationFeedRepository._(
        getHandler: () async => const [],
        markReadHandler: (_) async => const [],
        markAllReadHandler: () async => const [],
      );

  factory FakeNotificationFeedRepository.error() =>
      FakeNotificationFeedRepository._(
        getHandler: () async =>
            throw const UnknownFailure('Fake: simulated notifications error'),
        markReadHandler: (_) async =>
            throw const UnknownFailure('Fake: simulated markAsRead error'),
        markAllReadHandler: () async =>
            throw const UnknownFailure('Fake: simulated markAllAsRead error'),
      );

  /// Returns a future that never completes — useful for testing loading state.
  factory FakeNotificationFeedRepository.loading() =>
      FakeNotificationFeedRepository._(
        getHandler: () => Completer<List<AppNotification>>().future,
        markReadHandler: (_) => Completer<List<AppNotification>>().future,
        markAllReadHandler: () => Completer<List<AppNotification>>().future,
      );

  /// Full control over all three handlers — for tests that need to spy on
  /// call counts or inject custom behaviour not covered by the named factories.
  factory FakeNotificationFeedRepository.withHandlers({
    required Future<List<AppNotification>> Function() getHandler,
    required Future<List<AppNotification>> Function(String id) markReadHandler,
    required Future<List<AppNotification>> Function() markAllReadHandler,
  }) =>
      FakeNotificationFeedRepository._(
        getHandler: getHandler,
        markReadHandler: markReadHandler,
        markAllReadHandler: markAllReadHandler,
      );

  final Future<List<AppNotification>> Function() _getHandler;
  final Future<List<AppNotification>> Function(String id) _markReadHandler;
  final Future<List<AppNotification>> Function() _markAllReadHandler;

  @override
  Future<List<AppNotification>> getNotifications() => _getHandler();

  @override
  Future<List<AppNotification>> markAsRead(String id) => _markReadHandler(id);

  @override
  Future<List<AppNotification>> markAllAsRead() => _markAllReadHandler();
}

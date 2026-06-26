import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saa_2025/features/notifications/data/repositories/fake_notification_feed_repository.dart';
import 'package:saa_2025/features/notifications/presentation/providers/notifications_providers.dart';

void main() {
  group('NotificationsController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    // =========================================================================
    // build() — initial state load
    // =========================================================================

    test('build loads notifications from repository', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final state = await container.read(notificationsControllerProvider.future);

      expect(state, isNotEmpty);
      expect(state.every((n) => n.id.isNotEmpty), isTrue);
    });

    test('build on error enters error state', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.error(),
          ),
        ],
      );

      // When AsyncNotifier build() throws, the provider enters error state
      // We need to wait for it to settle
      expect(
        () async {
          await container.read(notificationsControllerProvider.future);
        },
        throwsA(anything),
      );
    });

    test('build on loading stays in AsyncLoading', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.loading(),
          ),
        ],
      );

      final asyncValue = container.read(notificationsControllerProvider);

      expect(asyncValue.isLoading, isTrue);
    });

    // =========================================================================
    // refresh() — re-fetch from repository
    // =========================================================================

    test('refresh transitions to loading then data', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      // Initial load
      final initial =
          await container.read(notificationsControllerProvider.future);
      expect(initial, isNotEmpty);

      // Refresh
      final controller =
          container.read(notificationsControllerProvider.notifier);
      await controller.refresh();

      final refreshed =
          container.read(notificationsControllerProvider).requireValue;
      expect(refreshed, isNotEmpty);
    });

    // =========================================================================
    // markRead(id) — mark single notification as read
    // =========================================================================

    test('markRead updates state + notification becomes read (FR3/P3 R1)',
        () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final initial =
          await container.read(notificationsControllerProvider.future);
      final unreadNotif =
          initial.firstWhere((n) => !n.isRead, orElse: () => initial.first);
      final unreadId = unreadNotif.id;

      final controller =
          container.read(notificationsControllerProvider.notifier);
      await controller.markRead(unreadId);

      final updated =
          container.read(notificationsControllerProvider).requireValue;
      final marked = updated.firstWhere((n) => n.id == unreadId);

      expect(marked.isRead, isTrue);
    });

    test('markRead causes unread count to decrement', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final initial =
          await container.read(notificationsControllerProvider.future);
      final initialUnread =
          initial.where((n) => !n.isRead).length;

      expect(initialUnread, greaterThan(0), reason: 'Need unread items');

      final unreadId = initial.firstWhere((n) => !n.isRead).id;

      final controller =
          container.read(notificationsControllerProvider.notifier);
      await controller.markRead(unreadId);

      final updatedCount =
          container.read(notificationsUnreadCountProvider);
      expect(updatedCount, equals(initialUnread - 1));
    });

    test('markRead is idempotent', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final initial =
          await container.read(notificationsControllerProvider.future);
      final id = initial.first.id;

      final controller =
          container.read(notificationsControllerProvider.notifier);
      await controller.markRead(id);
      final afterFirst = container.read(notificationsControllerProvider).valueOrNull;

      await controller.markRead(id);
      final afterSecond = container.read(notificationsControllerProvider).valueOrNull;

      expect(afterFirst, equals(afterSecond));
    });

    // =========================================================================
    // markAllRead() — mark all as read
    // =========================================================================

    test('markAllRead marks all notifications as read (FR7/P3 R1)', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final initial =
          await container.read(notificationsControllerProvider.future);
      expect(initial.any((n) => !n.isRead), isTrue, reason: 'Has unread');

      final controller =
          container.read(notificationsControllerProvider.notifier);
      await controller.markAllRead();

      final updated =
          container.read(notificationsControllerProvider).requireValue;

      expect(updated.every((n) => n.isRead), isTrue);
    });

    test('markAllRead causes unread count to reach 0', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final controller =
          container.read(notificationsControllerProvider.notifier);
      await controller.markAllRead();

      final unreadCount =
          container.read(notificationsUnreadCountProvider);

      expect(unreadCount, equals(0));
    });

    // =========================================================================
    // unreadCountProvider — derived count
    // =========================================================================

    test('notificationsUnreadCountProvider reflects unread items', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final notifications =
          await container.read(notificationsControllerProvider.future);
      final expectedUnread =
          notifications.where((n) => !n.isRead).length;

      final count = container.read(notificationsUnreadCountProvider);

      expect(count, equals(expectedUnread));
    });

    test('unreadCountProvider returns 0 on error state', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.error(),
          ),
        ],
      );

      final count = container.read(notificationsUnreadCountProvider);

      expect(count, equals(0));
    });

    test('unreadCountProvider returns 0 on loading state', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.loading(),
          ),
        ],
      );

      final count = container.read(notificationsUnreadCountProvider);

      expect(count, equals(0));
    });

    test('unreadCountProvider decrements after markRead', () async {
      container = ProviderContainer(
        overrides: [
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ],
      );

      final initial =
          await container.read(notificationsControllerProvider.future);
      final initialCount = container.read(notificationsUnreadCountProvider);

      final unreadId = initial.firstWhere((n) => !n.isRead).id;
      final controller =
          container.read(notificationsControllerProvider.notifier);
      await controller.markRead(unreadId);

      final newCount = container.read(notificationsUnreadCountProvider);

      expect(newCount, equals(initialCount - 1));
    });
  });
}

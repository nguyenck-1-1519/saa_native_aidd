import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/notifications/data/repositories/fake_notification_feed_repository.dart';
import 'package:saa_2025/features/notifications/domain/entities/notification_type.dart';

void main() {
  group('FakeNotificationFeedRepository', () {
    // =========================================================================
    // .data() mode — returns mock notifications
    // =========================================================================

    group('.data()', () {
      test('getNotifications returns a non-empty list (FR2)', () async {
        final repo = FakeNotificationFeedRepository.data();
        final result = await repo.getNotifications();

        expect(result, isNotEmpty);
        expect(result.every((n) => n.id.isNotEmpty), isTrue);
        expect(result.every((n) => n.title.isNotEmpty), isTrue);
      });

      test('markAsRead flips isRead + returns updated list (FR3)', () async {
        final repo = FakeNotificationFeedRepository.data();
        final initial = await repo.getNotifications();

        final unreadId = initial.firstWhere((n) => !n.isRead).id;
        final updated = await repo.markAsRead(unreadId);

        final marked = updated.firstWhere((n) => n.id == unreadId);
        expect(marked.isRead, isTrue);
        expect(updated.length, equals(initial.length));
      });

      test('markAsRead idempotent on already-read notification', () async {
        final repo = FakeNotificationFeedRepository.data();
        var list = await repo.getNotifications();

        // Mark all read
        list = await repo.markAllAsRead();
        expect(list.every((n) => n.isRead), isTrue);

        // Mark again — should be fine
        final readId = list.first.id;
        list = await repo.markAsRead(readId);
        expect(list.first.isRead, isTrue);
      });

      test('markAllAsRead flips all isRead → all true (FR3/FR7)', () async {
        final repo = FakeNotificationFeedRepository.data();
        var result = await repo.getNotifications();

        expect(result.any((n) => !n.isRead), isTrue, reason: 'Setup: has unread');

        result = await repo.markAllAsRead();

        expect(result.every((n) => n.isRead), isTrue);
      });

      test('markAllAsRead idempotent on empty/all-read list', () async {
        final repo = FakeNotificationFeedRepository.data();
        var result = await repo.getNotifications();

        result = await repo.markAllAsRead();
        expect(result.every((n) => n.isRead), isTrue);

        // Call again
        result = await repo.markAllAsRead();
        expect(result.every((n) => n.isRead), isTrue);
      });

      test('each item has required fields', () async {
        final repo = FakeNotificationFeedRepository.data();
        final result = await repo.getNotifications();

        for (final item in result) {
          expect(item.id, isNotEmpty);
          expect(item.title, isNotEmpty);
          expect(item.body, isNotEmpty);
          expect(item.createdAt, isNotNull);
          expect(
            [
              NotificationType.kudos,
              NotificationType.award,
              NotificationType.secretBox,
              NotificationType.system,
            ],
            contains(item.type),
          );
        }
      });
    });

    // =========================================================================
    // .empty() mode
    // =========================================================================

    group('.empty()', () {
      test('getNotifications returns empty list', () async {
        final repo = FakeNotificationFeedRepository.empty();
        final result = await repo.getNotifications();

        expect(result, isEmpty);
      });

      test('markAsRead on empty list returns empty', () async {
        final repo = FakeNotificationFeedRepository.empty();
        final result = await repo.markAsRead('any-id');

        expect(result, isEmpty);
      });

      test('markAllAsRead on empty list returns empty', () async {
        final repo = FakeNotificationFeedRepository.empty();
        final result = await repo.markAllAsRead();

        expect(result, isEmpty);
      });
    });

    // =========================================================================
    // .error() mode
    // =========================================================================

    group('.error()', () {
      test('getNotifications throws UnknownFailure', () async {
        final repo = FakeNotificationFeedRepository.error();

        expect(
          () => repo.getNotifications(),
          throwsA(isA<Exception>()),
        );
      });

      test('markAsRead throws UnknownFailure', () async {
        final repo = FakeNotificationFeedRepository.error();

        expect(
          () => repo.markAsRead('any-id'),
          throwsA(isA<Exception>()),
        );
      });

      test('markAllAsRead throws UnknownFailure', () async {
        final repo = FakeNotificationFeedRepository.error();

        expect(
          () => repo.markAllAsRead(),
          throwsA(isA<Exception>()),
        );
      });
    });

    // =========================================================================
    // .loading() mode — never resolves
    // =========================================================================

    group('.loading()', () {
      test('getNotifications never completes', () async {
        final repo = FakeNotificationFeedRepository.loading();
        final future = repo.getNotifications();

        final completed =
            await Future.any([future, Future.delayed(const Duration(milliseconds: 100))]);
        expect(completed, isNull, reason: 'getNotifications should not resolve');
      });

      test('markAsRead never completes', () async {
        final repo = FakeNotificationFeedRepository.loading();
        final future = repo.markAsRead('any-id');

        final completed =
            await Future.any([future, Future.delayed(const Duration(milliseconds: 100))]);
        expect(completed, isNull, reason: 'markAsRead should not resolve');
      });
    });

    // =========================================================================
    // Mutation test: .data() mode preserves original list on copy
    // =========================================================================

    group('.data() mutations preserve immutability', () {
      test('markAsRead returns a new list instance', () async {
        final repo = FakeNotificationFeedRepository.data();
        final list1 = await repo.getNotifications();
        final unreadId = list1.firstWhere((n) => !n.isRead).id;

        final list2 = await repo.markAsRead(unreadId);

        expect(identical(list1, list2), isFalse);
        // Original is unchanged (each call creates a fresh copy)
        final list1Again = await repo.getNotifications();
        expect(list1Again.any((n) => !n.isRead), isTrue);
      });
    });
  });
}

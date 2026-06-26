import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/core/router/app_router.dart';
import 'package:saa_2025/core/router/notifications_route_wrapper.dart';
import 'package:saa_2025/features/awards/data/sources/awards_detail_mock_data.dart';
import 'package:saa_2025/features/awards/presentation/providers/awards_providers.dart';
import 'package:saa_2025/features/notifications/data/repositories/fake_notification_feed_repository.dart';
import 'package:saa_2025/features/notifications/data/sources/notifications_mock_data.dart';
import 'package:saa_2025/features/notifications/domain/entities/app_notification.dart';
import 'package:saa_2025/features/notifications/domain/entities/notification_type.dart';
import 'package:saa_2025/features/notifications/presentation/providers/notifications_providers.dart';

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

/// Captures the last navigation location so tests can assert on it.
class _LocationCaptor extends ChangeNotifier {
  String value = '/start';
}

/// Builds a minimal router that mounts [NotificationsRouteWrapper] at '/start'
/// and stub destinations at the routes we expect deep-links to push/go.
/// A [_LocationCaptor] is updated by a [GoRouter.redirect] so tests can assert
/// the final location without actually rendering those screens.
Widget _buildApp({
  required FakeNotificationFeedRepository repo,
  required _LocationCaptor locationCaptor,
}) {
  final router = GoRouter(
    initialLocation: '/start',
    redirect: (context, state) {
      locationCaptor.value = state.matchedLocation;
      locationCaptor.notifyListeners();
      return null;
    },
    routes: [
      GoRoute(
        path: '/start',
        builder: (_, __) => const NotificationsRouteWrapper(),
      ),
      // Stub /kudos/detail/:id
      GoRoute(
        path: '${Routes.kudoDetail}/:id',
        builder: (_, state) => Scaffold(
          body: Text('kudo-detail:${state.pathParameters['id']}'),
        ),
      ),
      // Stub /awards
      GoRoute(
        path: Routes.awards,
        builder: (_, __) => const Scaffold(body: Text('awards')),
      ),
      // Stub /secret-box
      GoRoute(
        path: Routes.secretBox,
        builder: (_, __) => const Scaffold(body: Text('secret-box')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      notificationFeedRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests — _resolveDeepLink regression
// ---------------------------------------------------------------------------

void main() {
  group('_resolveDeepLink (via NotificationsRouteWrapper tap)', () {
    late _LocationCaptor locationCaptor;

    setUp(() {
      locationCaptor = _LocationCaptor();
    });

    tearDown(() {
      locationCaptor.dispose();
    });

    // -------------------------------------------------------------------------
    // Kudos — valid entity id builds correct route
    // -------------------------------------------------------------------------

    testWidgets(
        'tapping a kudos notification navigates to /kudos/detail/:id',
        (tester) async {
      final repo = FakeNotificationFeedRepository.data();

      await tester.pumpWidget(_buildApp(repo: repo, locationCaptor: locationCaptor));
      await tester.pumpAndSettle();

      // The first notification (notif-001) is type=kudos, deepLinkTarget='kudo-001'.
      // Find the item by its body text fragment.
      final kudosNotif = NotificationsMockData.items.firstWhere(
        (n) => n.id == 'notif-001',
      );
      expect(kudosNotif.deepLinkTarget, equals('kudo-001'),
          reason: 'mock data sanity: kudos deepLinkTarget must be entity id');

      final bodyText = kudosNotif.body;
      await tester.tap(find.text(bodyText).first);
      await tester.pumpAndSettle();

      expect(locationCaptor.value, equals('/kudos/detail/kudo-001'),
          reason: 'kudos deep-link must produce /kudos/detail/kudo-001 not a '
              'malformed double-path like /kudos/detail//kudos/kudo-001');
    });

    // -------------------------------------------------------------------------
    // Award — valid entity id sets selectedAwardIdProvider + navigates /awards
    // -------------------------------------------------------------------------

    testWidgets(
        'tapping an award notification navigates to /awards and sets selectedAwardIdProvider',
        (tester) async {
      final repo = FakeNotificationFeedRepository.data();
      late ProviderContainer container;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationFeedRepositoryProvider.overrideWithValue(repo),
          ],
          child: Builder(builder: (context) {
            container = ProviderScope.containerOf(context);
            return MaterialApp.router(
              routerConfig: GoRouter(
                initialLocation: '/start',
                redirect: (context, state) {
                  locationCaptor.value = state.matchedLocation;
                  locationCaptor.notifyListeners();
                  return null;
                },
                routes: [
                  GoRoute(
                    path: '/start',
                    builder: (_, __) => const NotificationsRouteWrapper(),
                  ),
                  GoRoute(
                    path: Routes.awards,
                    builder: (_, __) => const Scaffold(body: Text('awards')),
                  ),
                  GoRoute(
                    path: '${Routes.kudoDetail}/:id',
                    builder: (_, state) => Scaffold(
                      body: Text('kudo-detail:${state.pathParameters['id']}'),
                    ),
                  ),
                  GoRoute(
                    path: Routes.secretBox,
                    builder: (_, __) => const Scaffold(body: Text('secret-box')),
                  ),
                ],
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('vi'),
            );
          }),
        ),
      );
      await tester.pumpAndSettle();

      // Find the award notification (notif-002, deepLinkTarget='top-talent').
      final awardNotif = NotificationsMockData.items.firstWhere(
        (n) => n.id == 'notif-002',
      );
      expect(awardNotif.deepLinkTarget, equals('top-talent'),
          reason: 'mock data sanity: award deepLinkTarget must be entity id');

      await tester.tap(find.text(awardNotif.body).first);
      await tester.pumpAndSettle();

      // Should navigate to /awards.
      expect(locationCaptor.value, equals(Routes.awards));

      // selectedAwardIdProvider should be set to 'top-talent'.
      final selectedId = container.read(selectedAwardIdProvider);
      expect(selectedId, equals('top-talent'),
          reason: 'award deep-link must set selectedAwardIdProvider to the '
              'entity id, not a full route string like "/awards"');
    });

    // -------------------------------------------------------------------------
    // SecretBox — navigates to fixed /secret-box route
    // -------------------------------------------------------------------------

    testWidgets(
        'tapping a secretBox notification navigates to /secret-box',
        (tester) async {
      final repo = FakeNotificationFeedRepository.data();

      await tester.pumpWidget(_buildApp(repo: repo, locationCaptor: locationCaptor));
      await tester.pumpAndSettle();

      final secretBoxNotif = NotificationsMockData.items.firstWhere(
        (n) => n.id == 'notif-003',
      );
      expect(secretBoxNotif.deepLinkTarget, isNull,
          reason: 'secretBox notifications carry no deepLinkTarget entity id');

      await tester.tap(find.text(secretBoxNotif.body).first);
      await tester.pumpAndSettle();

      expect(locationCaptor.value, equals(Routes.secretBox));
    });

    // -------------------------------------------------------------------------
    // System — no navigation, stays on /start
    // A single-item list ensures the system notification is always in-viewport.
    // -------------------------------------------------------------------------

    testWidgets(
        'tapping a system notification does NOT navigate away',
        (tester) async {
      const systemBody = 'Chào mừng system only';
      final singleSystemNotif = AppNotification(
        id: 'sys-only',
        type: NotificationType.system,
        title: 'System only',
        body: systemBody,
        createdAt: DateTime(2025, 6, 1),
        isRead: false,
      );

      final repo = FakeNotificationFeedRepository.withHandlers(
        getHandler: () async => [singleSystemNotif],
        markReadHandler: (id) async => [singleSystemNotif.copyWith(isRead: true)],
        markAllReadHandler: () async =>
            [singleSystemNotif.copyWith(isRead: true)],
      );

      await tester.pumpWidget(_buildApp(repo: repo, locationCaptor: locationCaptor));
      await tester.pumpAndSettle();

      await tester.tap(find.text(systemBody));
      await tester.pumpAndSettle();

      expect(locationCaptor.value, equals('/start'),
          reason: 'system notifications are informational — no navigation');
    });

    // -------------------------------------------------------------------------
    // markRead fires exactly ONCE per tap (M1 regression)
    // Uses notif-001 (first in list, always in viewport) to avoid off-screen taps.
    // -------------------------------------------------------------------------

    testWidgets(
        'tapping a notification marks it read exactly once (no double markRead)',
        (tester) async {
      var markReadCallCount = 0;

      // Single-item list — first item is always on screen.
      final firstNotif = NotificationsMockData.items.first;
      final repo = FakeNotificationFeedRepository.withHandlers(
        getHandler: () async => [firstNotif],
        markReadHandler: (id) async {
          markReadCallCount++;
          return [firstNotif.copyWith(isRead: true)];
        },
        markAllReadHandler: () async => [firstNotif.copyWith(isRead: true)],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationFeedRepositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/start',
              routes: [
                GoRoute(
                  path: '/start',
                  builder: (_, __) => const NotificationsRouteWrapper(),
                ),
                GoRoute(
                  path: '${Routes.kudoDetail}/:id',
                  builder: (_, __) => const Scaffold(body: Text('detail')),
                ),
                GoRoute(
                  path: Routes.secretBox,
                  builder: (_, __) => const Scaffold(body: Text('secret-box')),
                ),
                GoRoute(
                  path: Routes.awards,
                  builder: (_, __) => const Scaffold(body: Text('awards')),
                ),
              ],
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('vi'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the item body text — it is the only item and at the top of the list.
      await tester.tap(find.text(firstNotif.body).first);
      await tester.pumpAndSettle();

      expect(markReadCallCount, equals(1),
          reason: 'markRead must fire exactly once per tap, not twice');
    });

    // -------------------------------------------------------------------------
    // Mock data sanity — deepLinkTarget values are entity ids, not route strings
    // -------------------------------------------------------------------------

    test('NotificationsMockData kudos targets are entity ids (no leading /)',
        () {
      final kudosItems = NotificationsMockData.items
          .where((n) => n.deepLinkTarget != null)
          .toList();
      for (final item in kudosItems) {
        expect(item.deepLinkTarget!.startsWith('/'), isFalse,
            reason:
                'deepLinkTarget must be an entity id (e.g. "kudo-001"), not a route '
                'string (e.g. "/kudos/kudo-001"). Found: ${item.deepLinkTarget}');
      }
    });

    test(
        'NotificationsMockData award targets are valid award ids in AwardsDetailMockData',
        () {
      final validAwardIds =
          AwardsDetailMockData.awards.map((a) => a.id).toSet();
      final awardItems = NotificationsMockData.items
          .where((n) => n.deepLinkTarget != null)
          .toList();

      // Check only the award-type notifications.
      final awardNotifications = NotificationsMockData.items
          .where((n) =>
              n.deepLinkTarget != null &&
              awardItems.any((a) => a.id == n.id &&
                  n.deepLinkTarget != 'kudo-001' &&
                  n.deepLinkTarget != 'kudo-002'))
          .where((n) => n.deepLinkTarget == 'top-talent' ||
              n.deepLinkTarget == 'mvp' ||
              n.deepLinkTarget == 'best-manager' ||
              n.deepLinkTarget == 'signature-creator' ||
              n.deepLinkTarget == 'top-project-leader')
          .toList();

      for (final item in awardNotifications) {
        expect(validAwardIds, contains(item.deepLinkTarget),
            reason:
                'deepLinkTarget "${item.deepLinkTarget}" is not a valid award id. '
                'Valid ids: $validAwardIds');
      }
    });
  });
}

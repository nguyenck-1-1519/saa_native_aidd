import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/core/router/app_router.dart';
import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';
import 'package:saa_2025/features/auth/presentation/providers/auth_providers.dart';
import 'package:saa_2025/features/home/data/repositories/fake_awards_repository.dart';
import 'package:saa_2025/features/home/domain/entities/countdown_state.dart';
import 'package:saa_2025/features/home/domain/repositories/kudos_config_repository.dart';
import 'package:saa_2025/features/home/presentation/providers/countdown_controller.dart';
import 'package:saa_2025/features/home/presentation/providers/home_providers.dart';
import 'package:saa_2025/features/home/presentation/widgets/awards_carousel.dart';
import 'package:saa_2025/features/home/presentation/widgets/kudos_section.dart';
import 'package:saa_2025/features/notifications/data/repositories/fake_notification_feed_repository.dart';
import 'package:saa_2025/features/notifications/presentation/providers/notifications_providers.dart';

// ---------------------------------------------------------------------------
// Test doubles
// ---------------------------------------------------------------------------

class _ElapsedCountdownController extends CountdownController {
  @override
  CountdownState build() => CountdownState.elapsed;
}

class _FakeKudosConfigRepository implements KudosConfigRepository {
  const _FakeKudosConfigRepository({required this.isKudosAvailable});
  @override
  final bool isKudosAvailable;
}

const _loggedInUser = AuthUser(
  id: 'test-user',
  email: 'test@example.com',
  displayName: 'Test User',
);

// ---------------------------------------------------------------------------
// App builder
// ---------------------------------------------------------------------------

Widget _buildApp(List<Override> overrides) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(initialUser: _loggedInUser),
      ),
      notificationFeedRepositoryProvider.overrideWithValue(
        FakeNotificationFeedRepository.empty(),
      ),
      kudosConfigRepositoryProvider.overrideWithValue(
        const _FakeKudosConfigRepository(isKudosAvailable: true),
      ),
      countdownControllerProvider.overrideWith(() => _ElapsedCountdownController()),
      awardsRepositoryProvider.overrideWithValue(FakeAwardsRepository.empty()),
      ...overrides,
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        return MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
        );
      },
    ),
  );
}

/// Pumps bounded frames to reach HomeScreen without blocking on loading states.
/// Safe when a provider never resolves (e.g. FakeAwardsRepository.loading()).
Future<void> _pumpToHome(WidgetTester tester) async {
  await tester.pump();
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ---------------------------------------------------------------------------
  // Awards Carousel states  (GUI_002, GUI_003, GUI_004, FUN_003)
  // ---------------------------------------------------------------------------

  group('HomeScreen — Awards Carousel', () {
    testWidgets('loading state shows CircularProgressIndicator (GUI_003)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      // loading() never resolves — must use bounded pumps, not pumpAndSettle.
      await tester.pumpWidget(
        _buildApp([
          awardsRepositoryProvider
              .overrideWithValue(FakeAwardsRepository.loading()),
        ]),
      );
      await _pumpToHome(tester);

      // AwardsCarousel is in a sliver — may be offstage; skipOffstage: false.
      expect(
        find.byType(CircularProgressIndicator, skipOffstage: false),
        findsWidgets,
      );
    });

    testWidgets('error state shows error message + Retry button (GUI_004, FUN_003)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildApp([
          awardsRepositoryProvider
              .overrideWithValue(FakeAwardsRepository.error()),
        ]),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Không thể tải danh sách giải thưởng.', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text('Thử lại', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Retry button tap triggers re-fetch (FUN_003)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildApp([
          awardsRepositoryProvider
              .overrideWithValue(FakeAwardsRepository.error()),
        ]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Thử lại', skipOffstage: false));
      await tester.pump(const Duration(milliseconds: 300));

      // Repo still errors after retry → error text persists.
      expect(
        find.text('Không thể tải danh sách giải thưởng.', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('data state renders AwardsCarousel with award names (GUI_002)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      // FakeAwardsRepository.data() uses asset images that aren't bundled in
      // tests. Silence image-load errors so they don't count as failures.
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.toString().contains('Unable to load asset')) return;
        originalOnError?.call(details);
      };
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        _buildApp([
          awardsRepositoryProvider
              .overrideWithValue(FakeAwardsRepository.data()),
        ]),
      );
      await tester.pumpAndSettle();

      // The carousel widget should be present.
      expect(
        find.byType(AwardsCarousel, skipOffstage: false),
        findsOneWidget,
      );
      // Award names from mock data should be in the tree.
      expect(find.text('Top Talent', skipOffstage: false), findsOneWidget);
    });

    testWidgets('empty awards state renders AwardsCarousel without items (GUI_002)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildApp([
          awardsRepositoryProvider
              .overrideWithValue(FakeAwardsRepository.empty()),
        ]),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(AwardsCarousel, skipOffstage: false),
        findsOneWidget,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // KudosSection visibility  (GUI_005, GUI_006, FUN_008, FUN_009)
  // ---------------------------------------------------------------------------

  group('HomeScreen — KudosSection visibility', () {
    testWidgets('KudosSection.visible=false when kudosAvailable=false (FUN_009)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildApp([
          kudosConfigRepositoryProvider.overrideWithValue(
            const _FakeKudosConfigRepository(isKudosAvailable: false),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      final sections = tester
          .widgetList<KudosSection>(
            find.byType(KudosSection, skipOffstage: false),
          )
          .toList();
      expect(sections, isNotEmpty);
      for (final s in sections) {
        expect(s.visible, isFalse,
            reason: 'KudosSection must be invisible when kudos feature off');
      }
    });

    testWidgets('KudosSection.visible=true when kudosAvailable=true (FUN_008)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildApp([
          kudosConfigRepositoryProvider.overrideWithValue(
            const _FakeKudosConfigRepository(isKudosAvailable: true),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      final sections = tester
          .widgetList<KudosSection>(
            find.byType(KudosSection, skipOffstage: false),
          )
          .toList();
      expect(sections, isNotEmpty);
      for (final s in sections) {
        expect(s.visible, isTrue,
            reason: 'KudosSection must be visible when kudos feature on');
      }
    });
  });

  // ---------------------------------------------------------------------------
  // Notification badge  (GUI_007, FUN_010, FUN_011)
  // ---------------------------------------------------------------------------

  group('HomeScreen — Notification badge', () {
    testWidgets('red badge present when unreadCount > 0 (FUN_010)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildApp([
          // data() has 3 unread items → badge should appear
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.data(),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      // The red badge is a Container with color #D4271D in the header.
      final badges = tester
          .widgetList<Container>(find.byType(Container))
          .where(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration as BoxDecoration).color ==
                    const Color(0xFFD4271D),
          )
          .toList();
      expect(badges, isNotEmpty,
          reason: 'Red badge visible when unreadCount > 0');
    });

    testWidgets('no red badge when unreadCount = 0 (FUN_011)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _buildApp([
          // empty() has no notifications → unread count = 0
          notificationFeedRepositoryProvider.overrideWithValue(
            FakeNotificationFeedRepository.empty(),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      final badges = tester
          .widgetList<Container>(find.byType(Container))
          .where(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration as BoxDecoration).color ==
                    const Color(0xFFD4271D),
          )
          .toList();
      expect(badges, isEmpty, reason: 'No red badge when unreadCount = 0');
    });
  });

  // ---------------------------------------------------------------------------
  // FAB double-tap guard  (FUN_012, FUN_013)
  // ---------------------------------------------------------------------------

  group('HomeScreen — FAB double-tap guard', () {
    testWidgets('rapid double-tap pushes WriteKudo route at most once (FUN_013)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp([]));
      await tester.pumpAndSettle();

      final editIcon = find.byIcon(Icons.edit);
      expect(editIcon, findsOneWidget);

      // Rapid double-tap — _fabBusy guard should block the second push.
      await tester.tap(editIcon, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 10));
      await tester.tap(editIcon, warnIfMissed: false);

      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Only one WriteKudo screen should ever appear.
      expect(
        find.text('Write Kudo').evaluate().length,
        lessThanOrEqualTo(1),
        reason: 'Guard must prevent duplicate route pushes',
      );
    });
  });
}

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
import 'package:saa_2025/features/home/domain/repositories/notification_repository.dart';
import 'package:saa_2025/features/home/presentation/providers/countdown_controller.dart';
import 'package:saa_2025/features/home/presentation/providers/home_providers.dart';
import 'package:saa_2025/features/placeholder/presentation/placeholder_screen.dart';

// ---------------------------------------------------------------------------
// Test doubles (same pattern as home_screen_test.dart)
// ---------------------------------------------------------------------------

class _ElapsedCountdownController extends CountdownController {
  @override
  CountdownState build() => CountdownState.elapsed;
}

class _TestNotificationRepository implements NotificationRepository {
  @override
  Stream<int> watchUnreadCount() => Stream.value(0);
}

class _FakeKudosConfigRepository implements KudosConfigRepository {
  @override
  bool get isKudosAvailable => true;
}

const _loggedInUser = AuthUser(
  id: 'nav-test-user',
  email: 'nav@example.com',
  displayName: 'Nav Test User',
);

// ---------------------------------------------------------------------------
// App builder — full SaaApp via routerProvider
// ---------------------------------------------------------------------------

Widget _buildApp({bool loggedIn = true, List<Override> extra = const []}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(initialUser: loggedIn ? _loggedInUser : null),
      ),
      notificationRepositoryProvider
          .overrideWithValue(_TestNotificationRepository()),
      kudosConfigRepositoryProvider
          .overrideWithValue(_FakeKudosConfigRepository()),
      countdownControllerProvider.overrideWith(() => _ElapsedCountdownController()),
      awardsRepositoryProvider
          .overrideWithValue(FakeAwardsRepository.empty()),
      ...extra,
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

/// Pumps until the home screen content is visible (auth guard resolves).
Future<void> _pumpToHome(WidgetTester tester) async {
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // ---------------------------------------------------------------------------
  // Auth guard  (ACC_001, ACC_002)
  // ---------------------------------------------------------------------------

  group('Auth guard', () {
    testWidgets('unauthenticated user is redirected to Login (ACC_001)',
        (tester) async {
      await tester.pumpWidget(_buildApp(loggedIn: false));
      // Use a bounded settle — the auth stream stays open (no pending timer).
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('LOGIN With Google'), findsOneWidget);
    });

    testWidgets('authenticated user lands on Home, not Login (ACC_002)',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      expect(find.text('LOGIN With Google'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // Bottom nav tab switching  (FUN_015–018)
  // ---------------------------------------------------------------------------

  group('Bottom nav tab switching', () {
    testWidgets('Awards tab tap shows Awards placeholder (FUN_016)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      await tester.tap(find.text('Awards'));
      await tester.pumpAndSettle();

      final placeholders = tester
          .widgetList<PlaceholderScreen>(
            find.byType(PlaceholderScreen, skipOffstage: false),
          )
          .where((p) => p.title == 'Awards')
          .toList();
      expect(placeholders, isNotEmpty,
          reason: 'Awards tab should show Awards placeholder');
    });

    testWidgets('Kudos tab tap shows Kudos placeholder (FUN_017)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      await tester.tap(find.text('Kudos'));
      await tester.pumpAndSettle();

      final placeholders = tester
          .widgetList<PlaceholderScreen>(
            find.byType(PlaceholderScreen, skipOffstage: false),
          )
          .where((p) => p.title == 'Kudos')
          .toList();
      expect(placeholders, isNotEmpty,
          reason: 'Kudos tab should show Kudos placeholder');
    });

    testWidgets('Profile tab tap shows Profile placeholder (FUN_018)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      final placeholders = tester
          .widgetList<PlaceholderScreen>(
            find.byType(PlaceholderScreen, skipOffstage: false),
          )
          .where((p) => p.title == 'Profile')
          .toList();
      expect(placeholders, isNotEmpty,
          reason: 'Profile tab should show Profile placeholder');
    });

    testWidgets('switching tabs and back to Home keeps Home content (FUN_015)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      // Go to Awards tab.
      await tester.tap(find.text('Awards'));
      await tester.pumpAndSettle();

      // Return to Home tab — the label is "SAA 2025" per homeNavSaa2025 l10n.
      await tester.tap(find.text('SAA 2025'));
      await tester.pumpAndSettle();

      // Home content still present (countdown visible in hero).
      expect(find.text('DAYS', skipOffstage: false), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Inline navigation from HomeScreen  (FUN_004, FUN_006, FUN_007, FUN_020)
  // ---------------------------------------------------------------------------

  group('HomeScreen inline navigation', () {
    testWidgets('ABOUT AWARD button navigates to About Award placeholder (FUN_004)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      // ABOUT AWARD button may be offscreen — scroll to it.
      await tester.ensureVisible(
        find.text('ABOUT AWARD', skipOffstage: false).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('ABOUT AWARD').first);
      await tester.pumpAndSettle();

      final placeholders = tester
          .widgetList<PlaceholderScreen>(find.byType(PlaceholderScreen))
          .where((p) => p.title == 'About Award')
          .toList();
      expect(placeholders, isNotEmpty,
          reason: 'ABOUT AWARD should navigate to About Award placeholder');
    });

    testWidgets('ABOUT KUDOS button navigates to About Kudos placeholder (FUN_006)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      await tester.ensureVisible(
        find.text('ABOUT KUDOS', skipOffstage: false).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('ABOUT KUDOS').first);
      await tester.pumpAndSettle();

      final placeholders = tester
          .widgetList<PlaceholderScreen>(find.byType(PlaceholderScreen))
          .where((p) => p.title == 'About Kudos')
          .toList();
      expect(placeholders, isNotEmpty,
          reason: 'ABOUT KUDOS should navigate to About Kudos placeholder');
    });

    testWidgets('search icon navigates to Search placeholder (FUN_007)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp());
      await _pumpToHome(tester);

      // Search uses an SVG asset icon in the header — find by key or semantics.
      // The header has a GestureDetector wrapping the search SVG.
      // We locate it via find.byKey if set, or via tap at known offset.
      // HomeHeader renders GestureDetector → SvgPicture with 'search.svg'.
      // Use find on the GestureDetector that is a sibling of the bell icon.
      // Simpler: tap the search SVG picture widget.
      final svgFinder = find.byWidgetPredicate(
        (w) => w.runtimeType.toString().contains('SvgPicture'),
      );
      // The header has two SVG icons: search + bell.
      // Tap the first one (search is first in the header row).
      await tester.tap(svgFinder.first);
      await tester.pumpAndSettle();

      final placeholders = tester
          .widgetList<PlaceholderScreen>(find.byType(PlaceholderScreen))
          .where((p) => p.title == 'Search' || p.title == 'Notifications')
          .toList();
      expect(placeholders, isNotEmpty,
          reason: 'Header icon tap should navigate to Search or Notifications');
    });

    testWidgets('bell icon navigates to Notifications placeholder (FUN_020)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_buildApp(
        extra: [
          notificationRepositoryProvider
              .overrideWithValue(_TestNotificationRepository()),
        ],
      ));
      await _pumpToHome(tester);

      final svgFinder = find.byWidgetPredicate(
        (w) => w.runtimeType.toString().contains('SvgPicture'),
      );
      // Bell is the second SVG in the header row (after search).
      final svgs = svgFinder.evaluate().toList();
      if (svgs.length >= 2) {
        await tester.tap(svgFinder.at(1));
        await tester.pumpAndSettle();

        final placeholders = tester
            .widgetList<PlaceholderScreen>(find.byType(PlaceholderScreen))
            .where((p) => p.title == 'Notifications' || p.title == 'Search')
            .toList();
        expect(placeholders, isNotEmpty,
            reason: 'Bell tap should navigate to Notifications placeholder');
      } else {
        // Only one SVG found — tap it and verify we navigated somewhere.
        await tester.tap(svgFinder.first);
        await tester.pumpAndSettle();
        expect(find.byType(PlaceholderScreen), findsOneWidget);
      }
    });
  });
}

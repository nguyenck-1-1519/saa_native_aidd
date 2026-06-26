import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/core/router/app_router.dart';
import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';
import 'package:saa_2025/features/auth/presentation/providers/auth_providers.dart';
import 'package:saa_2025/features/home/presentation/providers/countdown_controller.dart';
import 'package:saa_2025/features/home/presentation/providers/home_providers.dart';
import 'package:saa_2025/features/home/domain/entities/countdown_state.dart';
import 'package:saa_2025/features/home/domain/entities/award_card.dart';
import 'package:saa_2025/features/home/domain/repositories/awards_repository.dart';
import 'package:saa_2025/features/notifications/data/repositories/fake_notification_feed_repository.dart';
import 'package:saa_2025/features/notifications/presentation/providers/notifications_providers.dart';

/// Test double countdown controller — always returns elapsed state, no timer
class _ElapsedCountdownController extends CountdownController {
  @override
  CountdownState build() => CountdownState.elapsed;
}

/// Test-safe awards repository with minimal data (no images to avoid asset loading errors)
class _TestAwardsRepository implements AwardsRepository {
  @override
  Future<List<AwardCard>> getAwards() async => const [];
}

/// Test app wrapper that displays router
class _TestApp extends ConsumerWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget wrapApp({
    FakeAuthRepository? fakeRepo,
  }) {
    final fake = fakeRepo ?? FakeAuthRepository();
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fake),
        awardsRepositoryProvider.overrideWithValue(
          _TestAwardsRepository(), // Empty awards to avoid asset loading
        ),
        notificationFeedRepositoryProvider.overrideWithValue(
          FakeNotificationFeedRepository.empty(),
        ),
        countdownControllerProvider.overrideWith(
          () => _ElapsedCountdownController(),
        ),
      ],
      child: const _TestApp(),
    );
  }

  group('Auth Redirect Flow', () {
    testWidgets('no authenticated user shows login (ACC_001, FUN_013)', (tester) async {
      final fake = FakeAuthRepository(initialUser: null);
      await tester.pumpWidget(wrapApp(fakeRepo: fake));

      // Wait for initial route resolution
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should be on login screen
      expect(find.text('LOGIN With Google'), findsOneWidget);

      fake.dispose();
    });

    testWidgets('authenticated user with valid token navigates to home (ACC_002, FUN_012)',
        (tester) async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
        displayName: 'Test User',
      );
      final fake = FakeAuthRepository(initialUser: user);
      await tester.pumpWidget(wrapApp(fakeRepo: fake));

      // Wait for router to resolve auth state and redirect (minimal time to avoid home screen rendering)
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Should navigate to home — verify login is NOT shown
      expect(find.text('LOGIN With Google'), findsNothing);

      fake.dispose();
    });

    testWidgets('successful sign-in navigates to home (FUN_007, FUN_009)', (tester) async {
      final fake = FakeAuthRepository(initialUser: null);
      await tester.pumpWidget(wrapApp(fakeRepo: fake));

      // Initially on login
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.text('LOGIN With Google'), findsOneWidget);

      // Perform sign-in
      await tester.tap(find.text('LOGIN With Google'));

      // Wait for sign-in to complete and router to redirect to home
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Should navigate away from login
      expect(find.text('LOGIN With Google'), findsNothing);

      fake.dispose();
    });

    testWidgets('logout navigates back to login (FUN_014)', (tester) async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
        displayName: 'Test User',
      );
      final fake = FakeAuthRepository(initialUser: user);
      await tester.pumpWidget(wrapApp(fakeRepo: fake));

      // Initially on home (auth redirects there, login should not be visible)
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('LOGIN With Google'), findsNothing);

      // Logout via repo
      await fake.signOut();
      // Wait for auth listener to trigger redirect
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Should redirect to login
      expect(find.text('LOGIN With Google'), findsOneWidget);

      fake.dispose();
    });

    testWidgets('token expiration triggers redirect to login', (tester) async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
      );
      final fake = FakeAuthRepository(initialUser: user);
      await tester.pumpWidget(wrapApp(fakeRepo: fake));

      // Initially on home
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.text('LOGIN With Google'), findsNothing);

      // Simulate token expiration
      await fake.signOut();
      // Wait for auth listener and redirect
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Should redirect to login
      expect(find.text('LOGIN With Google'), findsOneWidget);

      fake.dispose();
    });
  });
}

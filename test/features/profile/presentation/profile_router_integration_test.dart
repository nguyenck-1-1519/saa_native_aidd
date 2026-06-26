import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/core/router/app_router.dart';
import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';
import 'package:saa_2025/features/auth/presentation/providers/auth_providers.dart';
import 'package:saa_2025/features/profile/data/repositories/fake_profile_repository.dart';
import 'package:saa_2025/features/profile/presentation/profile_filter_host.dart';
import 'package:saa_2025/features/profile/presentation/profile_screen.dart';
import 'package:saa_2025/features/profile/presentation/providers/profile_providers.dart';

// ---------------------------------------------------------------------------
// Shared test fixture
// ---------------------------------------------------------------------------

const _loggedInUser = AuthUser(
  id: 'fake-user-id',
  email: 'tester@sun-asterisk.com',
  displayName: 'Sun* Tester',
  photoUrl: null,
);

/// Builds a full app with fakes, returns a captured [GoRouter] via [onRouter].
///
/// We capture the router from inside [Consumer] so we can call [GoRouter.go]
/// directly rather than via [GoRouter.of(context)] — which requires a widget
/// context that is a *descendant* of the [MaterialApp.router], not the root.
Widget _buildApp({
  required AuthUser loggedInUser,
  required void Function(GoRouter) onRouter,
  FakeProfileRepository? profileRepo,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(initialUser: loggedInUser),
      ),
      if (profileRepo != null)
        profileRepositoryProvider.overrideWithValue(profileRepo),
    ],
    child: Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(routerProvider);
        onRouter(router);
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

// ---------------------------------------------------------------------------
// Route-shadow GoRouter integration tests
// ---------------------------------------------------------------------------

void main() {
  setUp(() {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final msg = details.toString();
      // Suppress image-load noise that is expected in the test environment:
      // assets are not bundled for unit/widget tests, and NetworkImage calls
      // fail without a real HTTP stack.  Both are handled by errorBuilder in
      // production and do not affect the widget-tree assertions being tested.
      if (msg.contains('Unable to load asset')) return;
      if (msg.contains('HTTP request failed')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  group('Route-shadow integration — /profile vs /profile/:userId', () {
    testWidgets(
        'navigating to /profile renders SelfProfileRouteWrapper (isSelf=true)',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      GoRouter? router;
      await tester.pumpWidget(
        _buildApp(
          loggedInUser: _loggedInUser,
          profileRepo: FakeProfileRepository.data(),
          onRouter: (r) => router = r,
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to the self-profile tab route.
      router!.go(Routes.profile);
      await tester.pumpAndSettle();

      // ProfileFilterHost wraps ProfileScreen — both must be in the tree.
      expect(find.byType(ProfileFilterHost), findsOneWidget);
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets(
        'navigating to /profile/:userId renders OtherProfileRouteWrapper '
        '(isSelf=false, back button visible)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      GoRouter? router;
      await tester.pumpWidget(
        _buildApp(
          loggedInUser: _loggedInUser,
          profileRepo: FakeProfileRepository.data(),
          onRouter: (r) => router = r,
        ),
      );
      await tester.pumpAndSettle();

      router!.push(Routes.profileUserPath('other-user-id'));
      await tester.pumpAndSettle();

      // ProfileFilterHost + ProfileScreen are in tree; back button confirms
      // isSelf=false path was taken (not the self-profile shell branch).
      expect(find.byType(ProfileFilterHost), findsOneWidget);
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(
        find.byIcon(Icons.arrow_back_ios),
        findsOneWidget,
        reason: 'Other-profile route must show back button (isSelf=false)',
      );
    });

    testWidgets(
        '/profile has no back button (isSelf=true), /profile/:userId does '
        '(isSelf=false) — proves no route shadow', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      GoRouter? router;
      await tester.pumpWidget(
        // Use empty repo so no Image.asset/network calls are made — this test
        // only asserts back-button presence, not awards rendering.
        _buildApp(
          loggedInUser: _loggedInUser,
          profileRepo: FakeProfileRepository.empty(),
          onRouter: (r) => router = r,
        ),
      );
      await tester.pumpAndSettle();

      // --- self profile: no back button ---
      router!.go(Routes.profile);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.arrow_back_ios), findsNothing,
          reason: 'Self profile (isSelf=true) must not show back button');

      // --- other-profile: back button present ---
      router!.push(Routes.profileUserPath('someone-else'));
      await tester.pumpAndSettle();
      expect(
        find.byIcon(Icons.arrow_back_ios),
        findsOneWidget,
        reason: 'Other-profile (isSelf=false) must show back button — '
            'route shadow would prevent this',
      );
    });
  });

  // Keep the original string-constant assertions as a fast smoke-check.
  group('Route constants — string assertions', () {
    test('Routes.profile is the literal self-profile path', () {
      expect(Routes.profile, '/profile');
    });

    test('profileUserPath(userId) produces /profile/:userId', () {
      expect(Routes.profileUserPath('abc-123'), '/profile/abc-123');
    });

    test('self path is a strict prefix of other path', () {
      final other = Routes.profileUserPath('x');
      expect(other.startsWith('${Routes.profile}/'), isTrue);
    });
  });
}

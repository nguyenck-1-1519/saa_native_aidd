import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/core/router/system_route_wrappers.dart';
import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';
import 'package:saa_2025/features/auth/presentation/providers/auth_providers.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _loggedInUser = AuthUser(
  id: 'user-123',
  email: 'user@example.com',
  displayName: 'Logged In',
);

// Vietnamese l10n strings (locale: vi)
const _goHomeLabel = 'Về trang chủ';
const _goLoginLabel = 'Về đăng nhập';

// ---------------------------------------------------------------------------
// Minimal router harness — no redirect guards, no full app routes.
// Pumps the target wrapper directly so auth redirects cannot interfere.
// ---------------------------------------------------------------------------

Widget _buildApp({
  required Widget wrapper,
  required FakeAuthRepository authRepo,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => wrapper,
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepo),
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
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AccessDeniedRouteWrapper — Auth-Aware CTA', () {
    testWidgets('logged-in user sees "errorGoHome" label', (tester) async {
      final authRepo = FakeAuthRepository(initialUser: _loggedInUser);

      await tester.pumpWidget(
        _buildApp(
          wrapper: const AccessDeniedRouteWrapper(),
          authRepo: authRepo,
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.text(_goHomeLabel), findsOneWidget,
          reason: 'Logged-in user should see "Về trang chủ" CTA');
      expect(find.text(_goLoginLabel), findsNothing,
          reason: 'Logged-in user must NOT see "Về đăng nhập"');

      authRepo.dispose();
    });

    testWidgets('logged-out user sees "errorGoLogin" label', (tester) async {
      final authRepo = FakeAuthRepository(initialUser: null);

      await tester.pumpWidget(
        _buildApp(
          wrapper: const AccessDeniedRouteWrapper(),
          authRepo: authRepo,
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.text(_goLoginLabel), findsOneWidget,
          reason: 'Logged-out user should see "Về đăng nhập" CTA');
      expect(find.text(_goHomeLabel), findsNothing,
          reason: 'Logged-out user must NOT see "Về trang chủ"');

      authRepo.dispose();
    });
  });

  group('NotFoundRouteWrapper — Auth-Aware CTA', () {
    testWidgets('logged-in user sees "errorGoHome" label', (tester) async {
      final authRepo = FakeAuthRepository(initialUser: _loggedInUser);

      await tester.pumpWidget(
        _buildApp(
          wrapper: const NotFoundRouteWrapper(),
          authRepo: authRepo,
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.text(_goHomeLabel), findsOneWidget,
          reason: 'Logged-in user should see "Về trang chủ" CTA');
      expect(find.text(_goLoginLabel), findsNothing,
          reason: 'Logged-in user must NOT see "Về đăng nhập"');

      authRepo.dispose();
    });

    testWidgets('logged-out user sees "errorGoLogin" label', (tester) async {
      final authRepo = FakeAuthRepository(initialUser: null);

      await tester.pumpWidget(
        _buildApp(
          wrapper: const NotFoundRouteWrapper(),
          authRepo: authRepo,
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.text(_goLoginLabel), findsOneWidget,
          reason: 'Logged-out user should see "Về đăng nhập" CTA');
      expect(find.text(_goHomeLabel), findsNothing,
          reason: 'Logged-out user must NOT see "Về trang chủ"');

      authRepo.dispose();
    });
  });
}

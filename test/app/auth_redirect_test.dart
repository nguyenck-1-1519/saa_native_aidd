import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';
import 'package:saa_2025/features/auth/presentation/providers/auth_providers.dart';
import 'package:saa_2025/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget wrapSaaApp({
    FakeAuthRepository? fakeRepo,
  }) {
    final fake = fakeRepo ?? FakeAuthRepository();
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fake),
      ],
      child: const SaaApp(),
    );
  }

  group('Auth Redirect Flow', () {
    testWidgets('no authenticated user shows login (ACC_001, FUN_013)', (tester) async {
      final fake = FakeAuthRepository(initialUser: null);
      await tester.pumpWidget(wrapSaaApp(fakeRepo: fake));

      // Wait for router to resolve
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
      await tester.pumpWidget(wrapSaaApp(fakeRepo: fake));

      // Wait for router to resolve auth state and navigate
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Should navigate to home screen - check for app bar title or logout button
      expect(find.byIcon(Icons.logout), findsWidgets);

      fake.dispose();
    });

    testWidgets('successful sign-in navigates to home (FUN_007, FUN_009)', (tester) async {
      final fake = FakeAuthRepository(initialUser: null);
      await tester.pumpWidget(wrapSaaApp(fakeRepo: fake));

      // Initially on login
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      expect(find.text('LOGIN With Google'), findsOneWidget);

      // Perform sign-in
      await tester.tap(find.text('LOGIN With Google'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should now navigate to home - logout button/icon visible
      expect(find.byIcon(Icons.logout), findsWidgets);

      fake.dispose();
    });

    testWidgets('logout navigates back to login (FUN_014)', (tester) async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
        displayName: 'Test User',
      );
      final fake = FakeAuthRepository(initialUser: user);
      await tester.pumpWidget(wrapSaaApp(fakeRepo: fake));

      // Initially on home
      await tester.pumpAndSettle(const Duration(milliseconds: 800));
      expect(find.byIcon(Icons.logout), findsWidgets);

      // Tap logout button
      await tester.tap(find.byIcon(Icons.logout).first);
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should now be on login
      expect(find.text('LOGIN With Google'), findsOneWidget);

      fake.dispose();
    });

    testWidgets('token expiration triggers redirect to login', (tester) async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
      );
      final fake = FakeAuthRepository(initialUser: user);
      await tester.pumpWidget(wrapSaaApp(fakeRepo: fake));

      // Initially on home
      await tester.pumpAndSettle(const Duration(milliseconds: 800));
      expect(find.byIcon(Icons.logout), findsWidgets);

      // Simulate token expiration by clearing current user
      await fake.signOut();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should redirect to login
      expect(find.text('LOGIN With Google'), findsOneWidget);

      fake.dispose();
    });
  });
}

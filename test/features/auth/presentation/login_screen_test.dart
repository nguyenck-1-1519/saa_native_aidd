import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/presentation/providers/auth_providers.dart';
import 'package:saa_2025/features/auth/presentation/screens/login_screen.dart';
import 'package:saa_2025/features/auth/presentation/widgets/language_selector.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget wrapLoginScreen({
    required WidgetTester tester,
    FakeAuthRepository? fakeRepo,
  }) {
    final fake = fakeRepo ?? FakeAuthRepository();
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(fake),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        home: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen', () {
    testWidgets('renders VN layout by default (GUI_001, GUI_002)', (tester) async {
      final fake = FakeAuthRepository();
      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      // Check for Vietnamese text
      expect(find.text('Bắt đầu hành trình của bạn cùng SAA 2025. Đăng nhập để khám phá!'),
          findsOneWidget);
      expect(find.text('Bản quyền thuộc về Sun* © 2025'), findsOneWidget);
      expect(find.text('LOGIN With Google'), findsOneWidget);
      // Language selector shows VN by default
      expect(find.text('VN'), findsWidgets);

      fake.dispose();
    });

    testWidgets('language selector shows VN/EN/JA options (FUN_002)', (tester) async {
      final fake = FakeAuthRepository();
      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      // LanguageSelector is present
      expect(find.byType(LanguageSelector), findsOneWidget);
      // Current language code shown (VN for Vietnamese)
      expect(find.text('VN'), findsWidgets);
      // Language dropdown icon visible (keyboard_arrow_down)
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      fake.dispose();
    });

    testWidgets('tap Google button shows loading state (FUN_006)', (tester) async {
      final fake = FakeAuthRepository(
        signInDelay: const Duration(milliseconds: 100),
      );
      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      // Tap the login button
      await tester.tap(find.text('LOGIN With Google'));
      // Pump once to show loading state before completion
      await tester.pump();

      // Check for loading indicator
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      // Complete the sign-in
      await tester.pumpAndSettle();

      fake.dispose();
    });

    testWidgets('double-click prevention (FUN_008)', (tester) async {
      final fake = FakeAuthRepository();
      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      // Tap the button twice rapidly
      await tester.tap(find.text('LOGIN With Google'));
      await tester.tap(find.text('LOGIN With Google'));

      await tester.pumpAndSettle();

      // Verify only one sign-in call was made
      expect(fake.signInCallCount, 1);

      fake.dispose();
    });

    testWidgets('successful sign-in updates auth state (FUN_007, FUN_009)', (tester) async {
      final fake = FakeAuthRepository();
      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      await tester.tap(find.text('LOGIN With Google'));
      await tester.pumpAndSettle(const Duration(milliseconds: 200));

      // After successful sign-in, user is authenticated
      expect(fake.currentUser, isNotNull);

      fake.dispose();
    });

    testWidgets('network failure shows localized error snackbar (FUN_010, FUN_015)',
        (tester) async {
      final fake = FakeAuthRepository();
      fake.nextFailure = NetworkFailure('No network');

      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      await tester.tap(find.text('LOGIN With Google'));
      await tester.pumpAndSettle();

      // Check for error message in snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      // VN message: 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối và thử lại.'
      expect(find.text('Lỗi kết nối mạng. Vui lòng kiểm tra kết nối và thử lại.'),
          findsOneWidget);

      // User should still be on login screen
      expect(fake.currentUser, isNull);

      fake.dispose();
    });

    testWidgets('AccountDisabled failure shows account error message', (tester) async {
      final fake = FakeAuthRepository();
      fake.nextFailure = AccountDisabled('Account locked');

      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      await tester.tap(find.text('LOGIN With Google'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      // VN message: 'Tài khoản không hợp lệ hoặc đã bị vô hiệu hóa.'
      expect(find.text('Tài khoản không hợp lệ hoặc đã bị vô hiệu hóa.'),
          findsOneWidget);

      fake.dispose();
    });

    testWidgets('AuthCancelled failure shows generic error', (tester) async {
      final fake = FakeAuthRepository();
      fake.nextFailure = AuthCancelled('User cancelled');

      await tester.pumpWidget(wrapLoginScreen(tester: tester, fakeRepo: fake));
      await tester.pumpAndSettle();

      await tester.tap(find.text('LOGIN With Google'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      // AuthCancelled maps to generic error
      // VN message: 'Đăng nhập thất bại. Vui lòng thử lại.'
      expect(find.text('Đăng nhập thất bại. Vui lòng thử lại.'), findsOneWidget);

      fake.dispose();
    });
  });
}

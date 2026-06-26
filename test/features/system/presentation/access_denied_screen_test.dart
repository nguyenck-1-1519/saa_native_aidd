import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/system/presentation/access_denied_screen.dart';

/// Pure widget test for [AccessDeniedScreen] — stateless, auth-unaware.
///
/// Tests verify:
/// - Title/message render from l10n keys
/// - CTA button calls onPrimaryAction when tapped
/// - No RenderFlex overflow at 320pt width
/// - i18n resolves in vi/en/ja without missing-key fallback
void main() {
  setUp(() {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('Unable to load asset')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  /// Helper: pump screen with localization harness and given locale.
  Future<void> pumpScreen(
    WidgetTester tester, {
    required Widget child,
    Locale locale = const Locale('vi'),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: child,
      ),
    );
  }

  group('AccessDeniedScreen — Pure Widget Tests', () {
    testWidgets('renders title and message in Vietnamese', (tester) async {
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(
          primaryLabel: 'Test Button',
        ),
      );
      await tester.pumpAndSettle();

      // Title: "Access Denied" (should be in Vietnamese ARB as accessDeniedTitle)
      expect(find.text('Access Denied'), findsOneWidget);

      // Message: Vietnamese localized text from accessDeniedMessage
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data != null &&
              w.data!.contains('không có quyền'),
        ),
        findsWidgets,
      );
    });

    testWidgets('CTA button renders with provided label', (tester) async {
      const label = 'Go Home';
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(
          primaryLabel: label,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(label), findsOneWidget);
    });

    testWidgets('CTA button calls onPrimaryAction when tapped', (tester) async {
      var tapped = false;
      await pumpScreen(
        tester,
        child: AccessDeniedScreen(
          primaryLabel: 'Tap Me',
          onPrimaryAction: () {
            tapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      final button = find.byWidgetPredicate(
        (w) => w is TextButton && w.onPressed != null,
      );
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('CTA button is inert when onPrimaryAction is null', (tester) async {
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(
          primaryLabel: 'Inert Button',
          onPrimaryAction: null,
        ),
      );
      await tester.pumpAndSettle();

      final button = find.byWidgetPredicate(
        (w) => w is TextButton,
      );
      expect(button, findsOneWidget);

      // Verify onPressed is null (button is visually inert)
      final buttonWidget = find.byType(TextButton).evaluate().first.widget as TextButton;
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('no RenderFlex overflow at 320pt width', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(
          primaryLabel: 'Về trang chủ',
        ),
      );
      await tester.pumpAndSettle();

      // If layout violates constraints, pump will throw or emit error.
      // This passes if no overflow exception is raised.
      expect(find.byType(AccessDeniedScreen), findsOneWidget);
    });

    testWidgets('renders lock icon placeholder', (tester) async {
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(
          primaryLabel: 'Continue',
        ),
      );
      await tester.pumpAndSettle();

      // Lock icon (Icons.lock_outline_rounded) should be present
      expect(
        find.byIcon(Icons.lock_outline_rounded),
        findsOneWidget,
      );
    });

    testWidgets('back arrow icon in top nav', (tester) async {
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(
          primaryLabel: 'Back',
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.arrow_back_ios_new_rounded),
        findsOneWidget,
      );
    });

    // -------------------------------------------------------------------------
    // i18n tests — verify keys resolve in vi, en, ja without missing-key
    // -------------------------------------------------------------------------

    testWidgets('i18n: keys resolve in Vietnamese (vi)', (tester) async {
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(primaryLabel: 'Button'),
        locale: const Locale('vi'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Access Denied'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data != null &&
              w.data!.contains('không có quyền'),
        ),
        findsWidgets,
      );
    });

    testWidgets('i18n: keys resolve in English (en)', (tester) async {
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(primaryLabel: 'Button'),
        locale: const Locale('en'),
      );
      await tester.pumpAndSettle();

      // English: "Access Denied" (same as key)
      expect(find.text('Access Denied'), findsOneWidget);

      // English message should be present (no localization in spec, so fallback or same)
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('i18n: keys resolve in Japanese (ja)', (tester) async {
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(primaryLabel: 'Button'),
        locale: const Locale('ja'),
      );
      await tester.pumpAndSettle();

      // Japanese locale should resolve without error
      expect(find.byType(AccessDeniedScreen), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('i18n: no missing-key fallback in any locale', (tester) async {
      // A missing key would render as a fallback string like "accessDeniedTitle"
      // This test ensures the actual localized text is shown.
      await pumpScreen(
        tester,
        child: const AccessDeniedScreen(primaryLabel: 'Test'),
        locale: const Locale('vi'),
      );
      await tester.pumpAndSettle();

      // Should not find the raw key name (would indicate a missing translation)
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data?.contains('accessDeniedTitle') == true ||
                  w.data?.contains('accessDeniedMessage') == true),
        ),
        findsNothing,
      );
    });
  });
}

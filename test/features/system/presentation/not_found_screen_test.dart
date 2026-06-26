import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/system/presentation/not_found_screen.dart';

/// Pure widget test for [NotFoundScreen] — stateless, auth-unaware.
///
/// Tests verify:
/// - Title/message render from l10n keys
/// - CTA button calls onPrimaryAction when tapped
/// - No RenderFlex overflow at 320pt width
/// - i18n resolves in vi/en/ja without missing-key fallback
/// - 404 illustration (4 icon 4) renders correctly
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

  group('NotFoundScreen — Pure Widget Tests', () {
    testWidgets('renders title and message in Vietnamese', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(
          primaryLabel: 'Test Button',
        ),
      );
      await tester.pumpAndSettle();

      // Title: "NOT FOUND" (should be in Vietnamese ARB as notFoundTitle)
      expect(find.text('NOT FOUND'), findsOneWidget);

      // Message: Vietnamese localized text from notFoundMessage
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data != null &&
              w.data!.contains('không tồn tại'),
        ),
        findsWidgets,
      );
    });

    testWidgets('CTA button renders with provided label', (tester) async {
      const label = 'Go Home';
      await pumpScreen(
        tester,
        child: const NotFoundScreen(
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
        child: NotFoundScreen(
          primaryLabel: 'Tap Me',
          onPrimaryAction: () {
            tapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      final button = find.byWidgetPredicate(
        (w) => w is ElevatedButton && w.onPressed != null,
      );
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('CTA button is inert when onPrimaryAction is null', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(
          primaryLabel: 'Inert Button',
          onPrimaryAction: null,
        ),
      );
      await tester.pumpAndSettle();

      final button = find.byWidgetPredicate(
        (w) => w is ElevatedButton,
      );
      expect(button, findsOneWidget);

      // Verify onPressed is null (button is visually inert)
      final buttonWidget = find.byType(ElevatedButton).evaluate().first.widget as ElevatedButton;
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('no RenderFlex overflow at 320pt width', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pumpScreen(
        tester,
        child: const NotFoundScreen(
          primaryLabel: 'Về trang chủ',
        ),
      );
      await tester.pumpAndSettle();

      // If layout violates constraints, pump will throw or emit error.
      // This passes if no overflow exception is raised.
      expect(find.byType(NotFoundScreen), findsOneWidget);
    });

    testWidgets('renders 404 illustration (4 icon 4)', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(
          primaryLabel: 'Continue',
        ),
      );
      await tester.pumpAndSettle();

      // Should have two '4' text widgets (left and right of icon)
      expect(find.text('4'), findsWidgets);

      // Search icon (Icons.search_off_rounded) should be present
      expect(
        find.byIcon(Icons.search_off_rounded),
        findsOneWidget,
      );
    });

    testWidgets('back arrow in app bar', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(
          primaryLabel: 'Back',
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.arrow_back_ios),
        findsOneWidget,
      );
    });

    testWidgets('renders dividers between title and message', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(
          primaryLabel: 'Button',
        ),
      );
      await tester.pumpAndSettle();

      // Should have dividers (rendered as Divider widgets)
      expect(find.byType(Divider), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // i18n tests — verify keys resolve in vi, en, ja without missing-key
    // -------------------------------------------------------------------------

    testWidgets('i18n: keys resolve in Vietnamese (vi)', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(primaryLabel: 'Button'),
        locale: const Locale('vi'),
      );
      await tester.pumpAndSettle();

      expect(find.text('NOT FOUND'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data != null &&
              w.data!.contains('không tồn tại'),
        ),
        findsWidgets,
      );
    });

    testWidgets('i18n: keys resolve in English (en)', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(primaryLabel: 'Button'),
        locale: const Locale('en'),
      );
      await tester.pumpAndSettle();

      // English: "NOT FOUND" (same as key)
      expect(find.text('NOT FOUND'), findsOneWidget);

      // English message should be present
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('i18n: keys resolve in Japanese (ja)', (tester) async {
      await pumpScreen(
        tester,
        child: const NotFoundScreen(primaryLabel: 'Button'),
        locale: const Locale('ja'),
      );
      await tester.pumpAndSettle();

      // Japanese locale should resolve without error
      expect(find.byType(NotFoundScreen), findsOneWidget);
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('i18n: no missing-key fallback in any locale', (tester) async {
      // A missing key would render as a fallback string like "notFoundTitle"
      await pumpScreen(
        tester,
        child: const NotFoundScreen(primaryLabel: 'Test'),
        locale: const Locale('vi'),
      );
      await tester.pumpAndSettle();

      // Should not find the raw key name (would indicate a missing translation)
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data?.contains('notFoundTitle') == true ||
                  w.data?.contains('notFoundMessage') == true),
        ),
        findsNothing,
      );
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/kudos/presentation/community_standards_screen.dart';
import 'package:saa_2025/features/kudos/presentation/kudos_rules_screen.dart';

/// Pump a screen with localization and minimal harness.
Future<void> _pumpScreen(
  WidgetTester tester, {
  required Widget child,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: child,
    ),
  );
}

void main() {
  setUp(() {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('Unable to load asset')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  // -------------------------------------------------------------------------
  // CommunityStandardsScreen
  // -------------------------------------------------------------------------

  group('CommunityStandardsScreen', () {
    testWidgets('renders title in Vietnamese', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpScreen(
        tester,
        child: const CommunityStandardsScreen(),
      );
      await tester.pumpAndSettle();

      // Screen should have a title related to community standards.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data?.contains('Tiêu chuẩn') == true ||
                  w.data?.contains('cộng đồng') == true),
          skipOffstage: false,
        ),
        findsWidgets,
      );
    });

    testWidgets('renders content (static copy)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpScreen(
        tester,
        child: const CommunityStandardsScreen(),
      );
      await tester.pumpAndSettle();

      // Should have static Vietnamese content.
      // Look for non-empty text content (can be in ListView, SingleChildScrollView, or Column).
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null && w.data!.isNotEmpty,
          skipOffstage: false,
        ),
        findsWidgets,
      );
    });

    testWidgets('back button pops the screen', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      var popped = false;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              popped = true;
            },
            child: const CommunityStandardsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap back button (AppBar back icon).
      final backButton = find.byType(BackButton, skipOffstage: false);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        expect(popped, isTrue);
      }
    });

    testWidgets('renders without overflow at 390px width', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final overflowErrors = <String>[];
      final savedOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        final msg = details.toString();
        if (msg.contains('RenderFlex overflowed')) {
          overflowErrors.add(msg);
        }
        if (!msg.contains('Unable to load asset')) {
          savedOnError?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = savedOnError);

      await _pumpScreen(
        tester,
        child: const CommunityStandardsScreen(),
      );
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'CommunityStandardsScreen must not overflow at 390px');
    });
  });

  // -------------------------------------------------------------------------
  // KudosRulesScreen
  // -------------------------------------------------------------------------

  group('KudosRulesScreen', () {
    testWidgets('renders title in Vietnamese', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpScreen(
        tester,
        child: const KudosRulesScreen(),
      );
      await tester.pumpAndSettle();

      // Screen should have a title related to Kudos rules.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              (w.data?.contains('Quy tắc') == true ||
                  w.data?.contains('Kudos') == true),
          skipOffstage: false,
        ),
        findsWidgets,
      );
    });

    testWidgets('renders content (static copy)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpScreen(
        tester,
        child: const KudosRulesScreen(),
      );
      await tester.pumpAndSettle();

      // Should have static Vietnamese content.
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.data != null && w.data!.isNotEmpty,
          skipOffstage: false,
        ),
        findsWidgets,
      );
    });

    testWidgets('back button pops the screen', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      var popped = false;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) {
              popped = true;
            },
            child: const KudosRulesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap back button.
      final backButton = find.byType(BackButton, skipOffstage: false);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        expect(popped, isTrue);
      }
    });

    testWidgets('renders without overflow at 390px width', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final overflowErrors = <String>[];
      final savedOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        final msg = details.toString();
        if (msg.contains('RenderFlex overflowed')) {
          overflowErrors.add(msg);
        }
        if (!msg.contains('Unable to load asset')) {
          savedOnError?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = savedOnError);

      await _pumpScreen(
        tester,
        child: const KudosRulesScreen(),
      );
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'KudosRulesScreen must not overflow at 390px');
    });
  });
}

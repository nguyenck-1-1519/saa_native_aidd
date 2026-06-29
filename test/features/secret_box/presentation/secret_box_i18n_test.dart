import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/secret_box/presentation/secret_box_screen.dart';

Future<void> _pumpWithLocale(
  WidgetTester tester,
  Locale locale,
  SecretBoxView view,
) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: SecretBoxScreen(
        view: view,
        unopenedCount: 1,
        rewardName: 'Test Reward',
      ),
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

  group('Secret Box — Localization (i18n)', () {
    testWidgets('VN locale shows Vietnamese labels', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithLocale(tester, const Locale('vi'), SecretBoxView.closed);
      await tester.pumpAndSettle();

      // "Click vào box để mở" is the Vietnamese closed-state subtitle.
      expect(
          find.text('Click vào box để mở', skipOffstage: false), findsWidgets);

      // App-bar title should be "Secret Box" (EN/universal).
      expect(find.text('Secret Box', skipOffstage: false), findsOneWidget);

      // None-left message in Vietnamese.
      await _pumpWithLocale(tester, const Locale('vi'), SecretBoxView.closed);
      // This will show the open CTA, not the none-left message, unless unopenedCount is 0.
    });

    testWidgets('EN locale shows English labels', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithLocale(tester, const Locale('en'), SecretBoxView.closed);
      await tester.pumpAndSettle();

      // EN closed-state subtitle: "Click the box to open"
      expect(
          find.text('Click the box to open', skipOffstage: false), findsWidgets);
    });

    testWidgets('JA locale shows Japanese labels', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithLocale(tester, const Locale('ja'), SecretBoxView.closed);
      await tester.pumpAndSettle();

      // JA closed-state subtitle: "ボックスをタップして開く"
      expect(
          find.text('ボックスをタップして開く', skipOffstage: false), findsWidgets);
    });

    testWidgets('no Vietnamese leak in EN locale', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithLocale(tester, const Locale('en'), SecretBoxView.revealed);
      await tester.pumpAndSettle();

      // Should NOT find Vietnamese text.
      expect(find.text('Mở hộp quà', skipOffstage: false), findsNothing);
      expect(find.text('Chúc mừng!', skipOffstage: false), findsNothing);
    });

    testWidgets('no Vietnamese leak in JA locale', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithLocale(tester, const Locale('ja'), SecretBoxView.revealed);
      await tester.pumpAndSettle();

      // Should NOT find Vietnamese text.
      expect(find.text('Mở hộp quà', skipOffstage: false), findsNothing);
      expect(find.text('Chúc mừng!', skipOffstage: false), findsNothing);
    });

    testWidgets('unopened label is localized per language', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      // VN: Vietnamese label from ARB
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: const SecretBoxScreen(
            view: SecretBoxView.closed,
            unopenedCount: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Secret box chưa mở ', skipOffstage: false),
        findsOneWidget,
        reason: 'VN locale must show the Vietnamese unopened label from ARB',
      );

      // EN: English label
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const SecretBoxScreen(
            view: SecretBoxView.closed,
            unopenedCount: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Unopened secret boxes ', skipOffstage: false),
        findsOneWidget,
        reason: 'EN locale must show the English unopened label from ARB',
      );

      // JA: Japanese label (machine-translated, needs native review)
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ja'),
          home: const SecretBoxScreen(
            view: SecretBoxView.closed,
            unopenedCount: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('未開封のシークレットボックス ', skipOffstage: false),
        findsOneWidget,
        reason: 'JA locale must show the Japanese unopened label from ARB',
      );
    });

    testWidgets('none-left message is localized per language', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      // VN: "Bạn không còn secret box nào."
      await _pumpWithLocale(
        tester,
        const Locale('vi'),
        SecretBoxView.closed,
      );

      // Manually create a screen with unopenedCount=0 to trigger none-left.
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: const SecretBoxScreen(
            view: SecretBoxView.closed,
            unopenedCount: 0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Bạn không còn secret box nào.', skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}

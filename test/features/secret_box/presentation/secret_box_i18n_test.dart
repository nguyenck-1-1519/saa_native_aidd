import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/secret_box/presentation/secret_box_screen.dart';

Future<void> _pumpWithLocale(
  WidgetTester tester,
  Locale locale,
  SecretBoxView view, {
  int unopenedCount = 1,
  String? rewardName = 'Test Reward',
}) async {
  // iPhone X logical viewport (375×812) — the design reference frame.
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: SecretBoxScreen(
        view: view,
        unopenedCount: unopenedCount,
        rewardName: rewardName,
      ),
    ),
  );
  await tester.pumpAndSettle();
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
    testWidgets('closed-state subtitle and app-bar title resolve per locale',
        (tester) async {
      await _pumpWithLocale(tester, const Locale('vi'), SecretBoxView.closed);
      expect(find.text('Click vào box để mở', skipOffstage: false),
          findsWidgets);
      expect(find.text('Secret Box', skipOffstage: false), findsOneWidget);

      await _pumpWithLocale(tester, const Locale('en'), SecretBoxView.closed);
      expect(find.text('Click the box to open', skipOffstage: false),
          findsWidgets);

      await _pumpWithLocale(tester, const Locale('ja'), SecretBoxView.closed);
      expect(find.text('ボックスをタップして開く', skipOffstage: false), findsWidgets);
    });

    testWidgets('no Vietnamese text leaks into EN or JA locales',
        (tester) async {
      for (final locale in const [Locale('en'), Locale('ja')]) {
        await _pumpWithLocale(tester, locale, SecretBoxView.revealedGift);
        expect(find.text('Mở hộp quà', skipOffstage: false), findsNothing);
        expect(find.text('Chúc mừng!', skipOffstage: false), findsNothing);
      }
    });

    testWidgets('unopened label uses the per-locale ARB string',
        (tester) async {
      await _pumpWithLocale(tester, const Locale('vi'), SecretBoxView.closed,
          unopenedCount: 3, rewardName: null);
      expect(find.text('Secret box chưa mở ', skipOffstage: false),
          findsOneWidget,
          reason: 'VN locale must show the Vietnamese unopened label from ARB');

      await _pumpWithLocale(tester, const Locale('en'), SecretBoxView.closed,
          unopenedCount: 3, rewardName: null);
      expect(find.text('Unopened secret boxes ', skipOffstage: false),
          findsOneWidget,
          reason: 'EN locale must show the English unopened label from ARB');

      await _pumpWithLocale(tester, const Locale('ja'), SecretBoxView.closed,
          unopenedCount: 3, rewardName: null);
      expect(find.text('未開封のシークレットボックス ', skipOffstage: false), findsOneWidget,
          reason: 'JA locale must show the Japanese unopened label from ARB');
    });

    testWidgets('none-left message is localized', (tester) async {
      await _pumpWithLocale(tester, const Locale('vi'), SecretBoxView.closed,
          unopenedCount: 0, rewardName: null);
      expect(find.text('Bạn không còn secret box nào.', skipOffstage: false),
          findsOneWidget);
    });
  });
}

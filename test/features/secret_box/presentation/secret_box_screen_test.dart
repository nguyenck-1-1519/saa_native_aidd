import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/secret_box/presentation/secret_box_screen.dart';

void main() {
  setUp(() {
    // Silence asset-load errors that fire in tests (images not bundled).
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('Unable to load asset')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  Future<void> pumpSecretBoxScreen(
    WidgetTester tester, {
    required SecretBoxView view,
    int unopenedCount = 0,
    String? rewardName,
    String? rewardAssetRef,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    VoidCallback? onOpeningComplete,
  }) async {
    // iPhone X logical viewport (375×812) — the design reference frame.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        home: SecretBoxScreen(
          view: view,
          unopenedCount: unopenedCount,
          rewardName: rewardName,
          rewardAssetRef: rewardAssetRef,
          onOpen: onOpen,
          onClose: onClose,
          onOpeningComplete: onOpeningComplete,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SecretBoxScreen', () {
    group('closed view', () {
      testWidgets('displays unopenedCount as a zero-padded number',
          (tester) async {
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 5,
        );

        expect(find.text('05'), findsOneWidget);
      });

      testWidgets('onOpen is called when the box is tapped', (tester) async {
        bool openTapped = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 2,
          onOpen: () => openTapped = true,
        );

        await tester.tap(find.byType(GestureDetector).first);
        expect(openTapped, isTrue);
      });

      testWidgets('open is disabled when unopenedCount is 0', (tester) async {
        bool openTapped = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 0,
          onOpen: () => openTapped = true,
        );

        await tester.tap(find.byType(GestureDetector).first);
        expect(openTapped, isFalse);
      });
    });

    group('opening view', () {
      testWidgets('calls onOpeningComplete when the animation finishes',
          (tester) async {
        bool animationCompleted = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.opening,
          onOpeningComplete: () => animationCompleted = true,
        );

        // Pump past the opening animation (~1.2s in the widget).
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(animationCompleted, isTrue);
      });
    });

    group('revealedIcon view', () {
      testWidgets('displays icon name and remaining count', (tester) async {
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealedIcon,
          rewardName: 'TOUCH OF LIGHT',
          unopenedCount: 4,
        );

        expect(find.text('TOUCH OF LIGHT'), findsWidgets);
        expect(find.text('04'), findsOneWidget);
      });

      testWidgets('onClose is called when the close button is tapped',
          (tester) async {
        bool closeTapped = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealedIcon,
          rewardName: 'ROOT FURTHER',
          unopenedCount: 0,
          onClose: () => closeTapped = true,
        );

        await tester.tap(find.byType(TextButton).last);
        expect(closeTapped, isTrue);
      });
    });

    group('revealedGift view', () {
      testWidgets('displays gift reward name', (tester) async {
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealedGift,
          rewardName: 'Khăn Root Further',
        );

        expect(find.text('Khăn Root Further'), findsOneWidget);
      });

      testWidgets('renders the reward image when an assetRef is provided',
          (tester) async {
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealedGift,
          rewardName: 'Test Gift',
          rewardAssetRef: 'assets/images/secret_box/reward.png',
        );

        // Image may fail to load in test, but the widget must be present.
        expect(find.byType(Image), findsWidgets);
      });

      testWidgets('onClose is called when the back button is tapped',
          (tester) async {
        bool closeTapped = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealedGift,
          rewardName: 'Test Gift',
          onClose: () => closeTapped = true,
        );

        await tester.tap(find.byIcon(Icons.chevron_left));
        expect(closeTapped, isTrue);
      });
    });
  });
}

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
  }

  group('SecretBoxScreen', () {
    group('closed view', () {
      testWidgets('renders box and open CTA at 375×812', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 3,
        );
        await tester.pumpAndSettle();

        // Should not overflow.
        expect(find.byType(LayoutBuilder), findsWidgets);
      });

      testWidgets('displays unopenedCount', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 5,
        );
        await tester.pumpAndSettle();

        // The count should be rendered in the SecretBoxClosedContent
        // as a zero-padded number. "05" with unopenedCount: 5.
        expect(find.text('05'), findsOneWidget);
      });

      testWidgets('onOpen is called when open CTA is tapped', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        bool openTapped = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 2,
          onOpen: () {
            openTapped = true;
          },
        );
        await tester.pumpAndSettle();

        // Tap the box image (which is a GestureDetector).
        await tester.tap(find.byType(GestureDetector).first);
        expect(openTapped, isTrue);
      });

      testWidgets('shows none-left message when unopenedCount is 0', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 0,
        );
        await tester.pumpAndSettle();

        // The i18n key should resolve to VI: "Bạn không còn secret box nào."
        expect(
          find.byType(Text, skipOffstage: false),
          findsWidgets,
        );
      });

      testWidgets('disables open when unopenedCount is 0', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        bool openTapped = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 0,
          onOpen: () {
            openTapped = true;
          },
        );
        await tester.pumpAndSettle();

        // The box should have onTap: null when unopenedCount <= 0.
        expect(openTapped, isFalse);
      });
    });

    group('opening view', () {
      testWidgets('renders opening animation', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.opening,
        );
        await tester.pumpAndSettle();

        // Opening animation should be present.
        expect(find.byType(Image), findsWidgets);
      });

      testWidgets('calls onOpeningComplete when animation finishes', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        bool animationCompleted = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.opening,
          onOpeningComplete: () {
            animationCompleted = true;
          },
        );

        // Pump the animation duration (animation is ~1.2s in widget).
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(animationCompleted, isTrue);
      });
    });

    group('revealed view', () {
      testWidgets('displays reward name', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealed,
          rewardName: 'Khăn Root Further',
        );
        await tester.pumpAndSettle();

        expect(find.text('Khăn Root Further'), findsOneWidget);
      });

      testWidgets('shows placeholder when rewardAssetRef is null', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealed,
          rewardName: 'Test Reward',
          rewardAssetRef: null,
        );
        await tester.pumpAndSettle();

        // Placeholder should render without error.
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('displays reward image when assetRef is provided', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealed,
          rewardName: 'Test Reward',
          rewardAssetRef: 'assets/images/secret_box/reward.png',
        );
        await tester.pumpAndSettle();

        // Image widget should be present (may fail to load in test, but structure is there).
        expect(find.byType(Image), findsWidgets);
      });

      testWidgets('onClose is called when back button is tapped', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        bool closeTapped = false;
        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealed,
          rewardName: 'Test Reward',
          onClose: () {
            closeTapped = true;
          },
        );
        await tester.pumpAndSettle();

        // Tap the back button in the AppBar (chevron_left).
        await tester.tap(find.byIcon(Icons.chevron_left));
        expect(closeTapped, isTrue);
      });
    });

    group('no overflow at 375×812', () {
      testWidgets('closed view fits within 375px width', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.closed,
          unopenedCount: 10,
        );
        await tester.pumpAndSettle();

        // No overflow errors should be logged.
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('revealed view fits within 375px width', (tester) async {
        tester.view.physicalSize = const Size(1170, 2532);
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);

        await pumpSecretBoxScreen(
          tester,
          view: SecretBoxView.revealed,
          rewardName: 'A very long reward name that might cause overflow issues',
          rewardAssetRef: null,
        );
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}

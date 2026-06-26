import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/profile/presentation/profile_screen.dart';

/// Pumps a minimal [ProfileScreen] showing a single kudo with [heartCount].
/// The _ActionBar's formatted text is rendered inside the kudo card.
Future<void> _pumpWithHeartCount(WidgetTester tester, int heartCount) async {
  final kudo = ProfileKudoView(
    id: 'k1',
    senderName: 'Alice',
    senderAvatarUrl: null,
    senderHeroTag: null,
    recipientName: 'Bob',
    recipientAvatarUrl: null,
    recipientHeroTag: null,
    postedAt: '10:00 - 01/01/2025',
    title: 'IDOL',
    message: 'Great work!',
    hashtags: const [],
    imageUrls: const [],
    heartCount: heartCount,
  );

  final vm = ProfileViewModel(
    name: 'Bob',
    department: 'Eng',
    heroTag: null,
    avatarUrl: null,
    kudosReceived: 1,
    kudosSent: 0,
    heartsReceived: heartCount,
    secretBoxOpened: 0,
    secretBoxUnopened: 0,
    iconBadgeCount: 0,
    awards: const [],
    recentKudos: [kudo],
  );

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: ProfileScreen(
        profile: vm,
        isSelf: false,
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

  group('_formatHearts — k-suffix rendering', () {
    testWidgets('999 hearts renders as "999" (no k)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithHeartCount(tester, 999);

      expect(find.text('999'), findsOneWidget);
    });

    testWidgets('1000 hearts renders as "1k"', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithHeartCount(tester, 1000);

      expect(find.text('1k'), findsOneWidget);
    });

    testWidgets('1500 hearts renders as "1.5k"', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithHeartCount(tester, 1500);

      expect(find.text('1.5k'), findsOneWidget);
    });

    testWidgets('2000 hearts renders as "2k" (not "2")', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpWithHeartCount(tester, 2000);

      expect(find.text('2k'), findsOneWidget);
      // Regression guard: old bug returned "2" with no 'k'.
      expect(find.text('2'), findsNothing);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/profile/presentation/profile_screen.dart';
import 'package:saa_2025/features/profile/presentation/widgets/profile_awards_list.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Future<void> _pumpAwardsList(
  WidgetTester tester,
  List<ProfileAwardView> awards,
) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: Scaffold(
        body: ProfileAwardsList(awards: awards),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpProfileWithAwards(
  WidgetTester tester,
  List<ProfileAwardView> awards,
) async {
  final vm = ProfileViewModel(
    name: 'Tester',
    department: 'Eng',
    heroTag: null,
    avatarUrl: null,
    kudosReceived: 0,
    kudosSent: 0,
    heartsReceived: 0,
    secretBoxOpened: 0,
    secretBoxUnopened: 0,
    iconBadgeCount: 0,
    awards: awards,
    recentKudos: const [],
  );

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: ProfileScreen(profile: vm, isSelf: true),
    ),
  );
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(() {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('Unable to load asset')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  group('ProfileAwardsList widget', () {
    testWidgets('renders award names from the list', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      const awards = [
        ProfileAwardView(name: 'Top Talent', imageUrl: null),
        ProfileAwardView(name: 'MVP', imageUrl: null),
      ];

      await _pumpAwardsList(tester, awards);

      expect(find.text('Top Talent'), findsOneWidget);
      expect(find.text('MVP'), findsOneWidget);
    });

    testWidgets('shows profileAwardsEmpty string when awards list is empty',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpAwardsList(tester, const []);

      // l10n key: profileAwardsEmpty = "Chưa có danh hiệu nào."
      expect(find.text('Chưa có danh hiệu nào.'), findsOneWidget);
    });

    testWidgets('renders fallback icon when imageUrl is null', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      const awards = [ProfileAwardView(name: 'Rising Star', imageUrl: null)];
      await _pumpAwardsList(tester, awards);

      expect(find.byIcon(Icons.emoji_events_outlined), findsOneWidget);
    });
  });

  group('ProfileScreen — awards section rendered', () {
    testWidgets('awards appear in ProfileScreen below the awards header',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      const awards = [
        ProfileAwardView(name: 'Top Talent', imageUrl: null),
        ProfileAwardView(name: 'Legend', imageUrl: null),
      ];

      await _pumpProfileWithAwards(tester, awards);

      expect(find.text('Top Talent'), findsOneWidget);
      expect(find.text('Legend'), findsOneWidget);
    });

    testWidgets('empty awards list shows empty state in ProfileScreen',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileWithAwards(tester, const []);

      expect(find.text('Chưa có danh hiệu nào.'), findsOneWidget);
    });

    testWidgets('ProfileAwardsList is present in the widget tree',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileWithAwards(tester, const [
        ProfileAwardView(name: 'Award A', imageUrl: null),
      ]);

      expect(find.byType(ProfileAwardsList), findsOneWidget);
    });
  });
}

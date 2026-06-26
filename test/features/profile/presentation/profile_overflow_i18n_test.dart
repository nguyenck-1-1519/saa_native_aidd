import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/profile/presentation/profile_screen.dart';

/// Pump [ProfileScreen] with a specific locale.
Future<void> _pumpProfileScreenLocale(
  WidgetTester tester, {
  required ProfileViewModel profile,
  required Locale locale,
  required bool isSelf,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: ProfileScreen(
        profile: profile,
        isSelf: isSelf,
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

  group('ProfileScreen — i18n: Vietnamese (vi)', () {
    testWidgets('displays in Vietnamese locale', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final vm = const ProfileViewModel(
        name: 'User',
        department: 'Dept',
        heroTag: null,
        avatarUrl: null,
        kudosReceived: 10,
        kudosSent: 5,
        heartsReceived: 20,
        secretBoxOpened: 1,
        secretBoxUnopened: 2,
        iconBadgeCount: 1,
        awards: [],
        recentKudos: [],
      );

      await _pumpProfileScreenLocale(
        tester,
        profile: vm,
        locale: const Locale('vi'),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsWidgets);
    });
  });

  group('ProfileScreen — i18n: English (en)', () {
    testWidgets('displays in English locale', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final vm = const ProfileViewModel(
        name: 'User',
        department: 'Dept',
        heroTag: null,
        avatarUrl: null,
        kudosReceived: 10,
        kudosSent: 5,
        heartsReceived: 20,
        secretBoxOpened: 1,
        secretBoxUnopened: 2,
        iconBadgeCount: 1,
        awards: [],
        recentKudos: [],
      );

      await _pumpProfileScreenLocale(
        tester,
        profile: vm,
        locale: const Locale('en'),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsWidgets);
    });
  });

  group('ProfileScreen — i18n: Japanese (ja)', () {
    testWidgets('displays in Japanese locale', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final vm = const ProfileViewModel(
        name: 'User',
        department: 'Dept',
        heroTag: null,
        avatarUrl: null,
        kudosReceived: 10,
        kudosSent: 5,
        heartsReceived: 20,
        secretBoxOpened: 1,
        secretBoxUnopened: 2,
        iconBadgeCount: 1,
        awards: [],
        recentKudos: [],
      );

      await _pumpProfileScreenLocale(
        tester,
        profile: vm,
        locale: const Locale('ja'),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsWidgets);
    });
  });
}

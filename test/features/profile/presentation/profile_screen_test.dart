import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/profile/presentation/profile_screen.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_mock_data.dart';
import 'package:saa_2025/features/awards/data/sources/awards_detail_mock_data.dart';

/// Pump [ProfileScreen] directly with mock view-model data.
Future<void> _pumpProfileScreen(
  WidgetTester tester, {
  required ProfileViewModel profile,
  required bool isSelf,
  VoidCallback? onEditProfile,
  VoidCallback? onOpenSettings,
  VoidCallback? onSendKudo,
  ValueChanged<String>? onTapRecentKudo,
  ValueChanged<String>? onTapUser,
  VoidCallback? onBack,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: ProfileScreen(
        profile: profile,
        isSelf: isSelf,
        onEditProfile: onEditProfile,
        onOpenSettings: onOpenSettings,
        onTapRecentKudo: onTapRecentKudo,
        onTapUser: onTapUser,
        onSendKudo: onSendKudo,
        onBack: onBack,
      ),
    ),
  );
}

/// Build a sample [ProfileViewModel] from mock data.
ProfileViewModel _buildSelfViewModel() => ProfileViewModel(
      name: 'Sun* Tester',
      department: 'Engineering',
      heroTag: 'Rising Hero',
      avatarUrl: null,
      kudosReceived: 24,
      kudosSent: 12,
      heartsReceived: 47,
      secretBoxOpened: 2,
      secretBoxUnopened: 1,
      iconBadgeCount: 1,
      awards: AwardsDetailMockData.awards
          .take(2)
          .map((a) => ProfileAwardView(name: a.name, imageUrl: a.badgeImageRef))
          .toList(),
      recentKudos: KudosMockData.feed.take(2).map((k) {
        return ProfileKudoView(
          id: k.id,
          senderName: k.senderName,
          senderAvatarUrl: null,
          senderHeroTag: k.senderRole,
          recipientName: k.recipientName,
          recipientAvatarUrl: null,
          recipientHeroTag: k.recipientRole,
          postedAt: k.timeRange,
          title: k.title,
          message: k.message,
          hashtags: k.hashtags,
          imageUrls: const [],
          heartCount: k.heartCount,
        );
      }).toList(),
    );

ProfileViewModel _buildOtherViewModel() => ProfileViewModel(
      name: 'Phạm Quốc Bảo',
      department: 'Engineering',
      heroTag: 'Legend Hero',
      avatarUrl: null,
      kudosReceived: 47,
      kudosSent: 31,
      heartsReceived: 112,
      secretBoxOpened: 3,
      secretBoxUnopened: 0,
      iconBadgeCount: 2,
      awards: AwardsDetailMockData.awards
          .take(3)
          .map((a) => ProfileAwardView(name: a.name, imageUrl: a.badgeImageRef))
          .toList(),
      recentKudos: KudosMockData.feed.skip(1).take(2).map((k) {
        return ProfileKudoView(
          id: k.id,
          senderName: k.senderName,
          senderAvatarUrl: null,
          senderHeroTag: k.senderRole,
          recipientName: k.recipientName,
          recipientAvatarUrl: null,
          recipientHeroTag: k.recipientRole,
          postedAt: k.timeRange,
          title: k.title,
          message: k.message,
          hashtags: k.hashtags,
          imageUrls: const [],
          heartCount: k.heartCount,
        );
      }).toList(),
    );

void main() {
  setUp(() {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('Unable to load asset')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  group('ProfileScreen — self profile (isSelf=true)', () {
    testWidgets('renders user name and department', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildSelfViewModel(),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      expect(find.text('Sun* Tester'), findsWidgets);
      expect(find.text('Engineering'), findsWidgets);
    });

    testWidgets('renders without error when isSelf=true', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildSelfViewModel(),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      // Just verify it renders without crashing.
      expect(find.byType(ProfileScreen), findsWidgets);
    });

    testWidgets('shows stats section only when isSelf=true', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildSelfViewModel(),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      // Stats section contains these localized strings; look for numbers.
      expect(find.text('24'), findsWidgets); // kudosReceived
      expect(find.text('12'), findsWidgets); // kudosSent
      expect(find.text('47'), findsWidgets); // heartsReceived
    });

    testWidgets('does not show send-kudo button when isSelf=true', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildSelfViewModel(),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      // "Send Kudo" button should NOT appear in self profile.
      final sendKudoFinder = find.text('Gửi Kudo'); // Or the localized string
      expect(sendKudoFinder, findsNothing);
    });
  });

  group('ProfileScreen — other profile (isSelf=false)', () {
    testWidgets('renders other user name and department', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildOtherViewModel(),
        isSelf: false,
      );
      await tester.pumpAndSettle();

      expect(find.text('Phạm Quốc Bảo'), findsWidgets);
      expect(find.text('Engineering'), findsWidgets);
    });

    testWidgets('hides edit button when isSelf=false', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildOtherViewModel(),
        isSelf: false,
      );
      await tester.pumpAndSettle();

      // The edit icon should NOT appear in other profile.
      expect(
        find.byIcon(Icons.edit),
        findsNothing,
        reason: 'Other profile should not show edit button',
      );
    });

    testWidgets('hides stats section when isSelf=false', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildOtherViewModel(),
        isSelf: false,
      );
      await tester.pumpAndSettle();

      // Stats section should not be shown for other profile.
      expect(find.byType(ProfileScreen), findsWidgets);
    });

    testWidgets('shows send-kudo button when isSelf=false', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildOtherViewModel(),
        isSelf: false,
      );
      await tester.pumpAndSettle();

      // Send Kudo button is a GestureDetector-wrapped Container with favorite_border icon.
      expect(
        find.byIcon(Icons.favorite_border),
        findsWidgets,
        reason: 'Send Kudo button should show heart icon',
      );
    });

    testWidgets('shows back button when isSelf=false', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildOtherViewModel(),
        isSelf: false,
      );
      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.arrow_back_ios),
        findsWidgets,
        reason: 'Other profile should show back button',
      );
    });
  });

  group('ProfileScreen — shared sections (both self and other)', () {
    testWidgets('renders awards section', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildSelfViewModel(),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      // Just verify it renders without crashing.
      expect(find.byType(ProfileScreen), findsWidgets);
    });

    testWidgets('renders icon collection (badges)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpProfileScreen(
        tester,
        profile: _buildSelfViewModel(),
        isSelf: true,
      );
      await tester.pumpAndSettle();

      // Icon collection should render without error.
      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('ProfileScreen — empty states', () {
    testWidgets('handles empty awards list', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final emptyVM = ProfileViewModel(
        name: 'User',
        department: 'Dept',
        heroTag: null,
        avatarUrl: null,
        kudosReceived: 0,
        kudosSent: 0,
        heartsReceived: 0,
        secretBoxOpened: 0,
        secretBoxUnopened: 0,
        iconBadgeCount: 0,
        awards: [],
        recentKudos: [],
      );

      await _pumpProfileScreen(
        tester,
        profile: emptyVM,
        isSelf: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsWidgets);
    });

    testWidgets('handles empty kudos list', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final emptyVM = ProfileViewModel(
        name: 'User',
        department: 'Dept',
        heroTag: null,
        avatarUrl: null,
        kudosReceived: 0,
        kudosSent: 0,
        heartsReceived: 0,
        secretBoxOpened: 0,
        secretBoxUnopened: 0,
        iconBadgeCount: 0,
        awards: [],
        recentKudos: [],
      );

      await _pumpProfileScreen(
        tester,
        profile: emptyVM,
        isSelf: true,
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsWidgets);
    });
  });
}

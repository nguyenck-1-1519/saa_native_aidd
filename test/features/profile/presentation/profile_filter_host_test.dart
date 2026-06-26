import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/profile/presentation/profile_filter_host.dart';
import 'package:saa_2025/features/profile/presentation/profile_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Two distinct kudos — one where Alice is the recipient, one where she is the
/// sender — so the filter slice can be validated.
ProfileKudoView _receivedKudo() => const ProfileKudoView(
      id: 'k-received',
      senderName: 'Bob',
      senderAvatarUrl: null,
      senderHeroTag: null,
      recipientName: 'Alice',
      recipientAvatarUrl: null,
      recipientHeroTag: null,
      postedAt: '10:00 - 01/01/2025',
      title: 'IDOL',
      message: 'Alice received this kudo',
      hashtags: [],
      imageUrls: [],
      heartCount: 5,
    );

ProfileKudoView _sentKudo() => const ProfileKudoView(
      id: 'k-sent',
      senderName: 'Alice',
      senderAvatarUrl: null,
      senderHeroTag: null,
      recipientName: 'Bob',
      recipientAvatarUrl: null,
      recipientHeroTag: null,
      postedAt: '11:00 - 02/01/2025',
      title: 'STAR',
      message: 'Alice sent this kudo',
      hashtags: [],
      imageUrls: [],
      heartCount: 3,
    );

ProfileViewModel _buildVM({List<ProfileKudoView>? kudos}) => ProfileViewModel(
      name: 'Alice',
      department: 'Engineering',
      heroTag: null,
      avatarUrl: null,
      kudosReceived: 1,
      kudosSent: 1,
      heartsReceived: 8,
      secretBoxOpened: 0,
      secretBoxUnopened: 0,
      iconBadgeCount: 0,
      awards: const [],
      recentKudos: kudos ?? [_receivedKudo(), _sentKudo()],
    );

Future<void> _pump(WidgetTester tester, ProfileViewModel vm) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: ProfileFilterHost(
        profile: vm,
        isSelf: true,
      ),
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

  group('ProfileFilterHost — filter updates visible kudos list', () {
    testWidgets(
        'default (received) shows only kudos where profile name is recipient',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester, _buildVM());

      // Default filter is KudosFilter.received — only "Alice received" message.
      expect(find.text('Alice received this kudo'), findsOneWidget);
      expect(find.text('Alice sent this kudo'), findsNothing);
    });

    testWidgets('tapping "sent" filter shows only kudos sent by profile user',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester, _buildVM());

      // Open the filter dropdown.
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();

      // Tap the "Đã gửi" option in the bottom sheet.
      await tester.tap(find.textContaining('Đã gửi'));
      await tester.pumpAndSettle();

      // Now only the sent kudo should be visible.
      expect(find.text('Alice sent this kudo'), findsOneWidget);
      expect(find.text('Alice received this kudo'), findsNothing);
    });

    testWidgets(
        'switching filter back to received shows received kudo again',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pump(tester, _buildVM());

      // Switch to sent.
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Đã gửi'));
      await tester.pumpAndSettle();

      // Switch back to received.
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Đã nhận'));
      await tester.pumpAndSettle();

      expect(find.text('Alice received this kudo'), findsOneWidget);
      expect(find.text('Alice sent this kudo'), findsNothing);
    });
  });
}

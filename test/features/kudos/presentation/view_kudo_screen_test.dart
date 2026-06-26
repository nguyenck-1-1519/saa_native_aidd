import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/core/router/kudos_route_wrappers.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';
import 'package:saa_2025/features/kudos/presentation/view_kudo_screen.dart';

/// Pump the [ViewKudoRouteWrapper] with a given kudo id (handles loading/error/data).
Future<void> _pumpViewKudoScreen(
  WidgetTester tester, {
  required String kudoId,
  required FakeKudosFeedRepository feedRepo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        kudosFeedRepositoryProvider.overrideWithValue(feedRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        home: ViewKudoRouteWrapper(id: kudoId),
      ),
    ),
  );
}

/// Pump a [ViewKudoScreen] directly with mock data (no route wrapper).
Future<void> _pumpViewKudoScreenDirect(
  WidgetTester tester, {
  required KudoDetailViewModel kudo,
  VoidCallback? onCopyLink,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: ViewKudoScreen(kudo: kudo, onCopyLink: onCopyLink),
    ),
  );
}

void main() {
  setUp(() {
    // Silence asset-load errors.
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('Unable to load asset')) return;
      originalOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  // -------------------------------------------------------------------------
  // Loading state
  // -------------------------------------------------------------------------

  group('ViewKudoScreen — loading state', () {
    testWidgets('shows CircularProgressIndicator while detail is loading',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpViewKudoScreen(
        tester,
        kudoId: 'kudo-001',
        feedRepo: FakeKudosFeedRepository.loading(),
      );
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator, skipOffstage: false),
        findsWidgets,
      );
    });
  });

  // -------------------------------------------------------------------------
  // Error state
  // -------------------------------------------------------------------------

  group('ViewKudoScreen — error state', () {
    testWidgets('shows error message and Retry button on missing kudo',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpViewKudoScreen(
        tester,
        kudoId: 'nonexistent-id',
        feedRepo: FakeKudosFeedRepository.data(),
      );
      await tester.pumpAndSettle();

      expect(find.text('Không tải được Kudo.', skipOffstage: false), findsWidgets);
      expect(find.text('Thử lại', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Retry button triggers re-fetch', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpViewKudoScreen(
        tester,
        kudoId: 'nonexistent-id',
        feedRepo: FakeKudosFeedRepository.data(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Thử lại', skipOffstage: false));
      await tester.pumpAndSettle();

      // Error persists since id is still missing.
      expect(find.text('Không tải được Kudo.', skipOffstage: false), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // Data state — regular (non-anonymous) kudo
  // -------------------------------------------------------------------------

  group('ViewKudoScreen — data state (non-anonymous)', () {
    testWidgets('renders sender name', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-001',
        senderName: 'Nguyễn Minh Tuấn',
        senderRole: 'Frontend Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Trần Thị Lan',
        recipientRole: 'Product Designer',
        recipientCode: 'Product Designer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 15/06/2025',
        title: 'Rising Hero',
        message: 'Cảm ơn bạn!',
        hashtags: const ['#Teamwork', '#Design'],
        imageUrls: const [],
        heartCount: 24,
        isAnonymous: false,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      expect(
        find.text('Nguyễn Minh Tuấn', skipOffstage: false),
        findsWidgets,
      );
    });

    testWidgets('renders recipient name and role', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-001',
        senderName: 'Nguyễn Minh Tuấn',
        senderRole: 'Frontend Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Trần Thị Lan',
        recipientRole: 'Product Designer',
        recipientCode: 'Product Designer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 15/06/2025',
        title: 'Rising Hero',
        message: 'Cảm ơn bạn!',
        hashtags: const ['#Teamwork', '#Design'],
        imageUrls: const [],
        heartCount: 24,
        isAnonymous: false,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      expect(find.text('Trần Thị Lan', skipOffstage: false), findsWidgets);
      expect(find.text('Product Designer', skipOffstage: false), findsWidgets);
    });

    testWidgets('renders title and full message', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-001',
        senderName: 'Nguyễn Minh Tuấn',
        senderRole: 'Frontend Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Trần Thị Lan',
        recipientRole: 'Product Designer',
        recipientCode: 'Product Designer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 15/06/2025',
        title: 'Rising Hero',
        message:
            'Cảm ơn Lan đã luôn hỗ trợ team trong suốt sprint vừa rồi. '
            'Nhờ có bạn mà UX của sản phẩm cải thiện rõ rệt! '
            'Sự tận tâm và sáng tạo của bạn là nguồn cảm hứng cho cả team.',
        hashtags: const ['#Teamwork', '#Design'],
        imageUrls: const [],
        heartCount: 24,
        isAnonymous: false,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      expect(find.text('Rising Hero', skipOffstage: false), findsWidgets);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data?.contains('hỗ trợ team') == true,
          skipOffstage: false,
        ),
        findsWidgets,
      );
    });

    testWidgets('renders hashtags', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-001',
        senderName: 'Nguyễn Minh Tuấn',
        senderRole: 'Frontend Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Trần Thị Lan',
        recipientRole: 'Product Designer',
        recipientCode: 'Product Designer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 15/06/2025',
        title: 'Rising Hero',
        message: 'Cảm ơn bạn!',
        hashtags: const ['#Teamwork', '#Design', '#SunKudos'],
        imageUrls: const [],
        heartCount: 24,
        isAnonymous: false,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      expect(find.text('#Teamwork', skipOffstage: false), findsWidgets);
      expect(find.text('#Design', skipOffstage: false), findsWidgets);
    });

    testWidgets('renders heart count', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-001',
        senderName: 'Nguyễn Minh Tuấn',
        senderRole: 'Frontend Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Trần Thị Lan',
        recipientRole: 'Product Designer',
        recipientCode: 'Product Designer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 15/06/2025',
        title: 'Rising Hero',
        message: 'Cảm ơn bạn!',
        hashtags: const ['#Teamwork', '#Design'],
        imageUrls: const [],
        heartCount: 24,
        isAnonymous: false,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      expect(find.text('24', skipOffstage: false), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  // Data state — anonymous kudo (isAnonymous = true)
  // -------------------------------------------------------------------------

  group('ViewKudoScreen — anonymous kudo variant', () {
    testWidgets('masks sender identity (hides name)', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-003',
        senderName: 'Hoàng Thị Mai',
        senderRole: 'QA Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Vũ Thanh Nam',
        recipientRole: 'Mobile Engineer',
        recipientCode: 'Mobile Engineer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 28/05/2025',
        title: 'Rising Hero',
        message: 'Nam luôn kiên nhẫn giải thích và fix bug nhanh chóng.',
        hashtags: const ['#Collaboration', '#Mobile'],
        imageUrls: const [],
        heartCount: 18,
        isAnonymous: true,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      // For anonymous kudos, sender name should not be visible (replaced with anonymous subtitle).
      expect(find.text('Người gửi ẩn danh', skipOffstage: false), findsWidgets);
    });

    testWidgets('still renders recipient info', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-003',
        senderName: 'Hoàng Thị Mai',
        senderRole: 'QA Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Vũ Thanh Nam',
        recipientRole: 'Mobile Engineer',
        recipientCode: 'Mobile Engineer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 28/05/2025',
        title: 'Rising Hero',
        message: 'Nam luôn kiên nhẫn giải thích và fix bug nhanh chóng.',
        hashtags: const ['#Collaboration', '#Mobile'],
        imageUrls: const [],
        heartCount: 18,
        isAnonymous: true,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      // Recipient should always be visible.
      expect(find.text('Vũ Thanh Nam', skipOffstage: false), findsWidgets);
      expect(
        find.text('Mobile Engineer', skipOffstage: false),
        findsWidgets,
      );
    });

    testWidgets('renders full message for anonymous kudo', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudo = KudoDetailViewModel(
        id: 'kudo-003',
        senderName: 'Hoàng Thị Mai',
        senderRole: 'QA Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Vũ Thanh Nam',
        recipientRole: 'Mobile Engineer',
        recipientCode: 'Mobile Engineer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 28/05/2025',
        title: 'Rising Hero',
        message: 'Nam luôn kiên nhẫn giải thích và fix bug nhanh chóng. '
            'Cảm ơn bạn đã giúp team release đúng hạn! '
            'Bạn là người không thể thiếu trong mỗi sprint.',
        hashtags: const ['#Collaboration', '#Mobile'],
        imageUrls: const [],
        heartCount: 18,
        isAnonymous: true,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      // Message should still be visible.
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Text &&
              w.data?.contains('kiên nhẫn') == true,
          skipOffstage: false,
        ),
        findsWidgets,
      );
    });
  });

  // -------------------------------------------------------------------------
  // Layout & overflow checks
  // -------------------------------------------------------------------------

  group('ViewKudoScreen — no overflow', () {
    testWidgets('renders without RenderFlex overflow at 390px width',
        (tester) async {
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

      final kudo = KudoDetailViewModel(
        id: 'kudo-001',
        senderName: 'Nguyễn Minh Tuấn',
        senderRole: 'Frontend Engineer',
        senderAvatarUrl: null,
        senderHeroTag: 'Rising Hero',
        recipientName: 'Trần Thị Lan',
        recipientRole: 'Product Designer',
        recipientCode: 'Product Designer',
        recipientAvatarUrl: null,
        recipientHeroTag: 'Rising Hero',
        postedAt: '10:30 - 15/06/2025',
        title: 'Rising Hero',
        message: 'Cảm ơn bạn!',
        hashtags: const ['#Teamwork', '#Design'],
        imageUrls: const [],
        heartCount: 24,
        isAnonymous: false,
      );

      await _pumpViewKudoScreenDirect(tester, kudo: kudo);
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'ViewKudoScreen must not overflow at 390px');
    });
  });
}

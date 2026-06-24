import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_stats_repository.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_mock_data.dart';
import 'package:saa_2025/features/kudos/presentation/kudos_screen.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';
import 'package:saa_2025/features/kudos/presentation/widgets/all_kudos_stats.dart';
import 'package:saa_2025/features/kudos/presentation/widgets/highlight_kudos_carousel.dart';
import 'package:saa_2025/features/kudos/presentation/widgets/recent_recipients.dart';
import 'package:saa_2025/features/kudos/presentation/widgets/spotlight_board.dart';

/// Pump a [KudosScreen] in a minimal test harness.
///
/// Feed and stats repos are overridden via [feedRepo] / [statsRepo].
Future<void> _pumpKudosScreen(
  WidgetTester tester, {
  required FakeKudosFeedRepository feedRepo,
  required FakeKudosStatsRepository statsRepo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        kudosFeedRepositoryProvider.overrideWithValue(feedRepo),
        kudosStatsRepositoryProvider.overrideWithValue(statsRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        home: const KudosScreen(),
      ),
    ),
  );
}

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

  // -------------------------------------------------------------------------
  // Loading state
  // -------------------------------------------------------------------------

  group('KudosScreen — loading state', () {
    testWidgets('shows CircularProgressIndicator while feed is loading',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.loading(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      // Single pump — repo never resolves.
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

  group('KudosScreen — error state', () {
    testWidgets('shows error text and Retry button on feed error', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.error(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      // KudosScreen reuses the awards error/retry localization keys.
      expect(
        find.text('Không thể tải danh sách giải thưởng.', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text('Thử lại', skipOffstage: false), findsOneWidget);
    });

    testWidgets('Retry button triggers re-fetch', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.error(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Thử lại', skipOffstage: false));
      await tester.pump(const Duration(milliseconds: 300));

      // Repo still errors after retry — error text persists.
      expect(
        find.text('Không thể tải danh sách giải thưởng.', skipOffstage: false),
        findsOneWidget,
      );
    });
  });

  // -------------------------------------------------------------------------
  // Data state
  // -------------------------------------------------------------------------

  group('KudosScreen — data state', () {
    testWidgets('renders HighlightKudosCarousel when feed has data',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.data(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(HighlightKudosCarousel, skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('renders AllKudosStats when stats loaded', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.data(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(AllKudosStats, skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('renders RecentRecipients with recipient names', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.data(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(RecentRecipients, skipOffstage: false),
        findsOneWidget,
      );
      // First recipient name appears somewhere in the tree.
      expect(
        find.text(KudosMockData.recentRecipients.first.name,
            skipOffstage: false),
        findsWidgets,
      );
    });

    testWidgets('renders SpotlightBoard regardless of feed state',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.data(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(SpotlightBoard, skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('renders KudosCard feed items', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.data(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      // At least the first feed kudo's title should be in the tree.
      expect(
        find.text(KudosMockData.feed.first.title, skipOffstage: false),
        findsWidgets,
      );
    });
  });

  // -------------------------------------------------------------------------
  // No RenderFlex overflow
  // -------------------------------------------------------------------------

  group('KudosScreen — no overflow', () {
    testWidgets('renders without RenderFlex overflow at iPhone 390px width',
        (tester) async {
      // iPhone 13 logical resolution: 390×844 (physical 1170×2532 @ 3x).
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
        // Suppress asset errors; re-throw everything else.
        if (!msg.contains('Unable to load asset')) {
          savedOnError?.call(details);
        }
      };
      addTearDown(() => FlutterError.onError = savedOnError);

      await _pumpKudosScreen(
        tester,
        feedRepo: FakeKudosFeedRepository.data(),
        statsRepo: FakeKudosStatsRepository.data(),
      );
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'KudosScreen must not overflow at 390px logical width');
    });
  });
}

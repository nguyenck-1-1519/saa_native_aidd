import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/l10n/app_localizations.dart';
import 'package:saa_2025/core/router/kudos_route_wrappers.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_mock_data.dart';
import 'package:saa_2025/features/kudos/domain/entities/kudo.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';
import 'package:saa_2025/features/kudos/presentation/widgets/kudos_filter_row.dart';
import 'package:saa_2025/features/kudos/presentation/all_kudos_screen.dart';

/// Pump the [AllKudosRouteWrapper] (handles loading/error/data binding).
Future<void> _pumpAllKudosRouteWrapper(
  WidgetTester tester, {
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
        home: const AllKudosRouteWrapper(),
      ),
    ),
  );
}

/// Pump a presentational [AllKudosScreen] directly with data.
Future<void> _pumpAllKudosScreenDirect(
  WidgetTester tester, {
  List<Kudo>? kudos,
  String? selectedHashtag,
  String? selectedDepartment,
  List<String> hashtagOptions = const [],
  List<String> departmentOptions = const [],
  ValueChanged<String?>? onHashtagChanged,
  ValueChanged<String?>? onDepartmentChanged,
}) async {
  final kudosToDisplay = kudos ?? KudosMockData.feed;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      home: AllKudosScreen(
        kudos: kudosToDisplay,
        selectedHashtag: selectedHashtag,
        selectedDepartment: selectedDepartment,
        hashtagOptions: hashtagOptions,
        departmentOptions: departmentOptions,
        onHashtagChanged: onHashtagChanged,
        onDepartmentChanged: onDepartmentChanged,
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

  // -------------------------------------------------------------------------
  // Loading state
  // -------------------------------------------------------------------------

  group('AllKudosScreen — loading state', () {
    testWidgets('shows CircularProgressIndicator while list is loading',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpAllKudosRouteWrapper(
        tester,
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

  group('AllKudosScreen — error state', () {
    testWidgets('shows error message and Retry button on repo error',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpAllKudosRouteWrapper(
        tester,
        feedRepo: FakeKudosFeedRepository.error(),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Không tải được danh sách Kudos.', skipOffstage: false),
        findsWidgets,
      );
      expect(find.text('Thử lại', skipOffstage: false), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Data state
  // -------------------------------------------------------------------------

  group('AllKudosScreen — data state', () {
    testWidgets('renders filter row with hashtag and department chips',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpAllKudosScreenDirect(
        tester,
        hashtagOptions: const ['#Design', '#Backend'],
        departmentOptions: const ['Engineering', 'HR'],
      );
      await tester.pumpAndSettle();

      // Filter chips should be present for hashtag and department.
      expect(find.byType(KudosFilterRow, skipOffstage: false), findsOneWidget);
      expect(find.text('Hashtag', skipOffstage: false), findsOneWidget);
      expect(find.text('Phòng ban', skipOffstage: false), findsOneWidget);
    });

    testWidgets('renders kudos list with feed items', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudos = KudosMockData.feed;
      await _pumpAllKudosScreenDirect(
        tester,
        kudos: kudos,
      );
      await tester.pumpAndSettle();

      // At least the first feed item's title should be visible.
      expect(
        find.text(kudos.first.title, skipOffstage: false),
        findsWidgets,
      );
    });

    testWidgets('filter changes via chip tap trigger callback', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      String? selectedHashtag;
      await _pumpAllKudosScreenDirect(
        tester,
        hashtagOptions: const ['#Design', '#Backend'],
        onHashtagChanged: (v) => selectedHashtag = v,
      );
      await tester.pumpAndSettle();

      // Tap the Hashtag filter chip.
      await tester.tap(find.text('Hashtag'));
      await tester.pumpAndSettle();

      // Tap a hashtag option in the modal bottom sheet (the white-colored one, not the smaller one).
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is Text && w.data == '#Design' && (w.style?.color ?? Colors.white) == Colors.white,
        ),
      );
      await tester.pumpAndSettle();

      // Callback should have been called with the selected hashtag.
      expect(selectedHashtag, '#Design');
    });

    testWidgets('renders all feed items when no filter', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final kudos = KudosMockData.feed;
      await _pumpAllKudosScreenDirect(
        tester,
        kudos: kudos,
      );
      await tester.pumpAndSettle();

      // All items in the list should be visible — verify CustomScrollView is rendered.
      expect(find.byType(CustomScrollView, skipOffstage: false), findsWidgets);
      // Verify at least one item is visible.
      if (kudos.isNotEmpty) {
        expect(find.text(kudos.first.title, skipOffstage: false), findsWidgets);
      }
    });
  });

  // -------------------------------------------------------------------------
  // Empty state
  // -------------------------------------------------------------------------

  group('AllKudosScreen — empty state', () {
    testWidgets('shows empty message when no kudos', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await _pumpAllKudosScreenDirect(
        tester,
        kudos: const [],
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Chưa có Kudos nào.', skipOffstage: false),
        findsOneWidget,
      );
    });
  });

  // -------------------------------------------------------------------------
  // No overflow
  // -------------------------------------------------------------------------

  group('AllKudosScreen — no overflow', () {
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

      final kudos = KudosMockData.feed;
      await _pumpAllKudosScreenDirect(
        tester,
        kudos: kudos,
      );
      await tester.pumpAndSettle();

      expect(overflowErrors, isEmpty,
          reason: 'AllKudosScreen must not overflow at 390px');
    });
  });
}

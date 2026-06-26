import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_mock_data.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';
import 'package:saa_2025/features/kudos/presentation/widgets/highlight_kudos_carousel.dart';

/// Regression: selecting a hashtag/department filter on the feed HIGHLIGHT
/// section must filter IN PLACE and never navigate away (previously it pushed
/// `/kudos/all` on every selection — jarring screen jump).
void main() {
  setUp(() {
    final original = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('Unable to load asset')) return;
      original?.call(details);
    };
    addTearDown(() => FlutterError.onError = null);
  });

  Future<void> pumpCarousel(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // No-delay repo so the hashtag/department option providers resolve
          // before we open the picker.
          kudosFeedRepositoryProvider
              .overrideWithValue(FakeKudosFeedRepository.data()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HighlightKudosCarousel(kudos: KudosMockData.highlights),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('selecting a feed hashtag filter stays on the carousel (no nav)',
      (tester) async {
    await pumpCarousel(tester);
    expect(find.byType(HighlightKudosCarousel), findsOneWidget);

    // Open the Hashtag picker (bottom sheet) and choose a concrete option.
    await tester.tap(find.text('Hashtag'));
    await tester.pumpAndSettle();

    final tiles = find.byType(ListTile);
    expect(tiles, findsWidgets); // 'Tất cả' + hashtag options
    await tester.tap(tiles.at(1)); // index 0 = 'Tất cả' (clear); 1 = first real option
    await tester.pumpAndSettle();

    // The carousel is still mounted — selection filtered in place, did not
    // push the All Kudos route.
    expect(find.byType(HighlightKudosCarousel), findsOneWidget);
  });
}

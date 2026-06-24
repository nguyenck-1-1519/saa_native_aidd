import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_stats_repository.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_mock_data.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';

/// Builds a [ProviderContainer] with feed and stats repos overridden.
ProviderContainer _container({
  FakeKudosFeedRepository? feed,
  FakeKudosStatsRepository? stats,
}) {
  return ProviderContainer(
    overrides: [
      if (feed != null)
        kudosFeedRepositoryProvider.overrideWithValue(feed),
      if (stats != null)
        kudosStatsRepositoryProvider.overrideWithValue(stats),
    ],
  );
}

void main() {
  // -------------------------------------------------------------------------
  // KudosFeedController
  // -------------------------------------------------------------------------

  group('KudosFeedController', () {
    test('loads feed, highlights, and recipients on build', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
      );
      addTearDown(container.dispose);

      // Wait for the async notifier to complete.
      final result = await container
          .read(kudosFeedControllerProvider.future);

      expect(result.feed, equals(KudosMockData.feed));
      expect(result.highlights, equals(KudosMockData.highlights));
      expect(result.recipients, equals(KudosMockData.recentRecipients));
    });

    test('returns empty lists when repo is empty', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.empty(),
      );
      addTearDown(container.dispose);

      final result = await container
          .read(kudosFeedControllerProvider.future);

      expect(result.feed, isEmpty);
      expect(result.highlights, isEmpty);
      expect(result.recipients, isEmpty);
    });

    test('enters error state when repo throws', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.error(),
      );
      addTearDown(container.dispose);

      // The future should throw.
      await expectLater(
        container.read(kudosFeedControllerProvider.future),
        throwsA(anything),
      );

      final state = container.read(kudosFeedControllerProvider);
      expect(state.hasError, isTrue);
    });

    test('refresh() recovers from error when repo switches to .data()',
        () async {
      // Start with error repo.
      final container = ProviderContainer(
        overrides: [
          kudosFeedRepositoryProvider
              .overrideWithValue(FakeKudosFeedRepository.error()),
        ],
      );
      addTearDown(container.dispose);

      // Wait for initial error.
      await expectLater(
        container.read(kudosFeedControllerProvider.future),
        throwsA(anything),
      );

      // Override with a data repo.
      container.updateOverrides([
        kudosFeedRepositoryProvider
            .overrideWithValue(FakeKudosFeedRepository.data()),
      ]);

      // Call refresh — should now succeed.
      await container
          .read(kudosFeedControllerProvider.notifier)
          .refresh();

      final state = container.read(kudosFeedControllerProvider);
      expect(state.hasValue, isTrue);
      expect(state.value!.feed, isNotEmpty);
    });

    test('starts in loading state before repo resolves', () {
      final container = _container(
        feed: FakeKudosFeedRepository.loading(),
      );
      addTearDown(container.dispose);

      // Read synchronously — should be loading before any pump.
      final state = container.read(kudosFeedControllerProvider);
      expect(state.isLoading, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // kudosStatsProvider
  // -------------------------------------------------------------------------

  group('kudosStatsProvider', () {
    test('resolves to KudosMockData.stats with .data() repo', () async {
      final container = _container(
        stats: FakeKudosStatsRepository.data(),
      );
      addTearDown(container.dispose);

      final stats = await container.read(kudosStatsProvider.future);
      expect(stats, equals(KudosMockData.stats));
    });

    test('enters error state when stats repo throws', () async {
      final container = _container(
        stats: FakeKudosStatsRepository.error(),
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(kudosStatsProvider.future),
        throwsA(anything),
      );

      final state = container.read(kudosStatsProvider);
      expect(state.hasError, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // recentRecipientsProvider
  // -------------------------------------------------------------------------

  group('recentRecipientsProvider', () {
    test('returns recipients derived from feed controller when data loaded',
        () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
      );
      addTearDown(container.dispose);

      // Await feed to complete first.
      await container.read(kudosFeedControllerProvider.future);

      final recipients = container.read(recentRecipientsProvider);
      expect(recipients, equals(KudosMockData.recentRecipients));
    });

    test('returns empty list while feed is loading', () {
      final container = _container(
        feed: FakeKudosFeedRepository.loading(),
      );
      addTearDown(container.dispose);

      // Read synchronously before feed resolves.
      final recipients = container.read(recentRecipientsProvider);
      expect(recipients, isEmpty);
    });

    test('returns empty list when feed errors', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.error(),
      );
      addTearDown(container.dispose);

      // Allow error to settle.
      await expectLater(
        container.read(kudosFeedControllerProvider.future),
        throwsA(anything),
      );

      final recipients = container.read(recentRecipientsProvider);
      expect(recipients, isEmpty);
    });
  });
}

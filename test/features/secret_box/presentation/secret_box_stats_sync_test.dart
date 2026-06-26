import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_stats_repository.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';
import 'package:saa_2025/features/secret_box/data/repositories/fake_secret_box_repository.dart';
import 'package:saa_2025/features/secret_box/presentation/providers/secret_box_providers.dart';

/// Builds a [ProviderContainer] with overrides for stats and secret-box repos.
ProviderContainer _container({
  FakeKudosStatsRepository? stats,
  FakeSecretBoxRepository? secretBox,
}) {
  return ProviderContainer(
    overrides: [
      if (stats != null)
        kudosStatsRepositoryProvider.overrideWithValue(stats),
      secretBoxRepositoryProvider
          .overrideWithValue(secretBox ?? FakeSecretBoxRepository.empty()),
    ],
  );
}

void main() {
  group('Secret Box — Stats Sync (FR7)', () {
    test(
        'kudosStatsProvider merges secret-box unopened/opened counts from shared repo',
        () async {
      // FakeSecretBoxRepository.empty() → unopenedCount=1, openedRewards=[].
      final container = _container(
        stats: FakeKudosStatsRepository.data(),
      );
      addTearDown(container.dispose);

      final stats = await container.read(kudosStatsProvider.future);

      // Secret-box counts should reflect the fake repo's state.
      expect(stats.secretBoxUnopened, equals(1));
      expect(stats.secretBoxOpened, equals(0));
    });

    test('reflects custom secret-box state in merged counts', () async {
      // Use a custom fake repo that returns 0 unopened.
      final customRepo = FakeSecretBoxRepository.none();
      final container = _container(
        stats: FakeKudosStatsRepository.data(),
        secretBox: customRepo,
      );
      addTearDown(container.dispose);

      final stats = await container.read(kudosStatsProvider.future);

      expect(stats.secretBoxUnopened, equals(0));
      expect(stats.secretBoxOpened, equals(0));
    });

    test('error in secret-box repo propagates to kudosStatsProvider',
        () async {
      final container = _container(
        stats: FakeKudosStatsRepository.data(),
        secretBox: FakeSecretBoxRepository.error(),
      );
      addTearDown(container.dispose);

      // Should throw when reading the future.
      await expectLater(
        container.read(kudosStatsProvider.future),
        throwsA(anything),
      );

      final state = container.read(kudosStatsProvider);
      expect(state.hasError, isTrue);
    });
  });
}

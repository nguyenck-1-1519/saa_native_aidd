import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/awards/data/repositories/fake_awards_detail_repository.dart';
import 'package:saa_2025/features/awards/data/sources/awards_detail_mock_data.dart';
import 'package:saa_2025/features/awards/domain/entities/award_detail.dart';
import 'package:saa_2025/features/awards/presentation/providers/awards_providers.dart';

void main() {
  group('AwardsProviders', () {
    group('awardsDetailControllerProvider', () {
      test('loads 5 awards from repository', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.data(),
            ),
          ],
        );

        final state = await container.read(awardsDetailControllerProvider.future);

        expect(state, isA<List<AwardDetail>>());
        expect(state.length, equals(5));
        expect(state, equals(AwardsDetailMockData.awards));
      });

      test('reports loading state while fetching', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.loading(),
            ),
          ],
        );

        final state = container.read(awardsDetailControllerProvider);
        expect(state.isLoading, isTrue);
        expect(state.hasValue, isFalse);
      });

      test('reports error state on repository failure', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.error(),
            ),
          ],
        );

        // Try to await the error result - it should throw.
        expect(
          () => container.read(awardsDetailControllerProvider.future),
          throwsA(isA<UnknownFailure>()),
        );
      });

      test('refresh() re-fetches from repository', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.data(),
            ),
          ],
        );

        // Load initial state.
        final initialState =
            await container.read(awardsDetailControllerProvider.future);
        expect(initialState.length, equals(5));

        // Refresh and verify we can read the state again.
        await container
            .read(awardsDetailControllerProvider.notifier)
            .refresh();
        final refreshedState =
            await container.read(awardsDetailControllerProvider.future);

        expect(refreshedState.length, equals(5));
      });

      test('refresh() recovers from error when repo changes', () async {
        // Start with error repo.
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.error(),
            ),
          ],
        );

        // Switch to data repo.
        container.updateOverrides([
          awardsDetailRepositoryProvider.overrideWithValue(
            FakeAwardsDetailRepository.data(),
          ),
        ]);

        // Refresh and wait for recovery.
        await container
            .read(awardsDetailControllerProvider.notifier)
            .refresh();

        // Wait for the new data to load after refresh.
        final recovered =
            await container.read(awardsDetailControllerProvider.future);

        // Verify recovered state has data.
        expect(recovered, isA<List<AwardDetail>>());
        expect(recovered.length, equals(5));
      });
    });

    group('selectedAwardIdProvider', () {
      test('defaults to top-talent (first award)', () {
        final container = ProviderContainer();

        final selectedId = container.read(selectedAwardIdProvider);

        expect(selectedId, equals('top-talent'));
      });

      test('can be changed via notifier', () {
        final container = ProviderContainer();

        container.read(selectedAwardIdProvider.notifier).state =
            'mvp';

        final selectedId = container.read(selectedAwardIdProvider);
        expect(selectedId, equals('mvp'));
      });

      test('persists across multiple reads', () {
        final container = ProviderContainer();

        container.read(selectedAwardIdProvider.notifier).state =
            'best-manager';

        expect(container.read(selectedAwardIdProvider), equals('best-manager'));
        expect(container.read(selectedAwardIdProvider), equals('best-manager'));
      });
    });

    group('selectedAwardDetailProvider', () {
      test('derives correct award for selected id', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.data(),
            ),
          ],
        );

        // Wait for awards to load.
        await container.read(awardsDetailControllerProvider.future);

        // Set selection to 'mvp' and watch the derived value.
        container.read(selectedAwardIdProvider.notifier).state = 'mvp';

        final selected =
            container.read(selectedAwardDetailProvider);

        expect(selected, isNotNull);
        expect(selected?.id, equals('mvp'));
        expect(selected?.name, equals('MVP (Most Valuable Person)'));
      });

      test('returns null while controller is loading', () {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.loading(),
            ),
          ],
        );

        final selected = container.read(selectedAwardDetailProvider);

        expect(selected, isNull);
      });

      test('updates when selectedAwardIdProvider changes', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.data(),
            ),
          ],
        );

        // Wait for initial load.
        await container.read(awardsDetailControllerProvider.future);

        // Start with default (top-talent).
        var selected = container.read(selectedAwardDetailProvider);
        expect(selected?.id, equals('top-talent'));

        // Switch to best-manager.
        container.read(selectedAwardIdProvider.notifier).state =
            'best-manager';
        selected = container.read(selectedAwardDetailProvider);
        expect(selected?.id, equals('best-manager'));

        // Switch to signature-creator.
        container.read(selectedAwardIdProvider.notifier).state =
            'signature-creator';
        selected = container.read(selectedAwardDetailProvider);
        expect(selected?.id, equals('signature-creator'));
      });

      test('returns null when repository returns empty list', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.empty(),
            ),
          ],
        );

        // Wait for empty list to load.
        await container.read(awardsDetailControllerProvider.future);

        final selected = container.read(selectedAwardDetailProvider);

        expect(selected, isNull);
      });

      test('falls back to first award if selected id not found', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.data(),
            ),
          ],
        );

        // Wait for initial load.
        await container.read(awardsDetailControllerProvider.future);

        // Set to an invalid id.
        container.read(selectedAwardIdProvider.notifier).state =
            'nonexistent-award';

        final selected = container.read(selectedAwardDetailProvider);

        expect(selected, isNotNull);
        // Falls back to first (top-talent).
        expect(selected?.id, equals('top-talent'));
      });

      test('switching selection cycles through all 5 awards', () async {
        final container = ProviderContainer(
          overrides: [
            awardsDetailRepositoryProvider.overrideWithValue(
              FakeAwardsDetailRepository.data(),
            ),
          ],
        );

        // Wait for initial load.
        await container.read(awardsDetailControllerProvider.future);

        final awardIds = [
          'top-talent',
          'top-project-leader',
          'best-manager',
          'signature-creator',
          'mvp',
        ];

        for (final id in awardIds) {
          container.read(selectedAwardIdProvider.notifier).state = id;
          final selected = container.read(selectedAwardDetailProvider);

          expect(selected?.id, equals(id),
              reason: 'Should select $id correctly');
        }
      });
    });
  });
}

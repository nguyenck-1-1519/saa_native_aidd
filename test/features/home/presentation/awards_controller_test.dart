import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/home/presentation/providers/home_providers.dart';
import 'package:saa_2025/features/home/data/repositories/fake_awards_repository.dart';
import 'package:saa_2025/features/home/data/sources/home_mock_data.dart';
import 'package:saa_2025/core/error/failures.dart';

void main() {
  group('AwardsController', () {
    test('data state loads awards successfully', () async {
      final container = ProviderContainer(
        overrides: [
          awardsRepositoryProvider.overrideWithValue(
            FakeAwardsRepository.data(),
          ),
        ],
      );

      // For AsyncNotifierProvider, we need to wait for the async value
      await container.read(awardsControllerProvider.future);

      final state = container.read(awardsControllerProvider);
      expect(state.hasValue, isTrue);
      expect(state.valueOrNull, HomeMockData.awards);
      expect(state.valueOrNull!.length, 3);
    });

    test('empty state returns no awards', () async {
      final container = ProviderContainer(
        overrides: [
          awardsRepositoryProvider.overrideWithValue(
            FakeAwardsRepository.empty(),
          ),
        ],
      );

      // For AsyncNotifierProvider, wait for completion
      await container.read(awardsControllerProvider.future);

      final state = container.read(awardsControllerProvider);
      expect(state.hasValue, isTrue);
      expect(state.valueOrNull, isEmpty);
    });

    test('error state surfaces when repository throws', () async {
      final container = ProviderContainer(
        overrides: [
          awardsRepositoryProvider.overrideWithValue(
            FakeAwardsRepository.error(),
          ),
        ],
      );

      // For AsyncNotifierProvider with error, wait and check
      try {
        await container.read(awardsControllerProvider.future);
      } catch (_) {
        // Expected to throw
      }

      final state = container.read(awardsControllerProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<UnknownFailure>());
    });
  });
}

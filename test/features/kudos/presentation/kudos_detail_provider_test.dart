import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_detail_providers.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';

/// Builds a [ProviderContainer] with feed repo overridden.
ProviderContainer _container({required FakeKudosFeedRepository feed}) {
  return ProviderContainer(
    overrides: [
      kudosFeedRepositoryProvider.overrideWithValue(feed),
    ],
  );
}

void main() {
  // -------------------------------------------------------------------------
  // kudoDetailProvider — family provider keyed by kudo id
  // -------------------------------------------------------------------------

  group('kudoDetailProvider', () {
    test('loads detail for kudo-001 with .data() repo', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
      );
      addTearDown(container.dispose);

      final detail = await container.read(kudoDetailProvider('kudo-001').future);

      expect(detail.id, equals('kudo-001'));
      expect(detail.senderName, equals('Nguyễn Minh Tuấn'));
      expect(detail.recipientName, equals('Trần Thị Lan'));
      expect(detail.isAnonymous, isFalse);
    });

    test('loads anonymous detail for kudo-003', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
      );
      addTearDown(container.dispose);

      final detail = await container.read(kudoDetailProvider('kudo-003').future);

      expect(detail.id, equals('kudo-003'));
      expect(detail.isAnonymous, isTrue);
    });

    test('enters error state for missing id', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(kudoDetailProvider('nonexistent').future),
        throwsA(anything),
      );

      final state = container.read(kudoDetailProvider('nonexistent'));
      expect(state.hasError, isTrue);
    });

    test('enters loading state before repo resolves', () {
      final container = _container(
        feed: FakeKudosFeedRepository.loading(),
      );
      addTearDown(container.dispose);

      final state = container.read(kudoDetailProvider('kudo-001'));
      expect(state.isLoading, isTrue);
    });

    test('different ids are cached independently', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
      );
      addTearDown(container.dispose);

      final detail1 =
          await container.read(kudoDetailProvider('kudo-001').future);
      final detail2 =
          await container.read(kudoDetailProvider('kudo-002').future);

      expect(detail1.id, equals('kudo-001'));
      expect(detail2.id, equals('kudo-002'));
      expect(detail1.senderName, isNot(equals(detail2.senderName)));
    });

    test('recovers from error when repo switches to .data()', () async {
      final container = ProviderContainer(
        overrides: [
          kudosFeedRepositoryProvider
              .overrideWithValue(FakeKudosFeedRepository.error()),
        ],
      );
      addTearDown(container.dispose);

      // Initial error.
      await expectLater(
        container.read(kudoDetailProvider('kudo-001').future),
        throwsA(anything),
      );

      // Switch to data repo.
      container.updateOverrides([
        kudosFeedRepositoryProvider
            .overrideWithValue(FakeKudosFeedRepository.data()),
      ]);

      // Invalidate the cache to force a re-fetch.
      container.invalidate(kudoDetailProvider('kudo-001'));

      final state = container.read(kudoDetailProvider('kudo-001'));
      expect(state.isLoading, isTrue);

      // Now resolve the future.
      final detail = await container.read(kudoDetailProvider('kudo-001').future);
      expect(detail.id, equals('kudo-001'));
    });
  });
}

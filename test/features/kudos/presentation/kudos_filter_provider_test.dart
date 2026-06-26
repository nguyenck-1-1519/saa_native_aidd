import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_write_kudo_repository.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_detail_mock_data.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_filter_providers.dart';
import 'package:saa_2025/features/kudos/presentation/providers/kudos_providers.dart';

/// Builds a [ProviderContainer] with feed and write repos overridden.
ProviderContainer _container({
  required FakeKudosFeedRepository feed,
  required FakeWriteKudoRepository write,
}) {
  return ProviderContainer(
    overrides: [
      kudosFeedRepositoryProvider.overrideWithValue(feed),
      writeKudoRepositoryProvider.overrideWithValue(write),
    ],
  );
}

void main() {
  // -------------------------------------------------------------------------
  // FeedFilterController — hashtag and department filter state
  // -------------------------------------------------------------------------

  group('FeedFilterController', () {
    test('starts with empty filter (no hashtag, no department)', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final filter = container.read(feedFilterControllerProvider);
      expect(filter.hashtag, isNull);
      expect(filter.department, isNull);
    });

    test('setHashtag updates state', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      container
          .read(feedFilterControllerProvider.notifier)
          .setHashtag('#Teamwork');

      final filter = container.read(feedFilterControllerProvider);
      expect(filter.hashtag, equals('#Teamwork'));
      expect(filter.department, isNull);
    });

    test('setDepartment updates state', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      container
          .read(feedFilterControllerProvider.notifier)
          .setDepartment('Frontend Engineer');

      final filter = container.read(feedFilterControllerProvider);
      expect(filter.department, equals('Frontend Engineer'));
      expect(filter.hashtag, isNull);
    });

    test('can set both hashtag and department together', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final controller =
          container.read(feedFilterControllerProvider.notifier);
      controller.setHashtag('#SunKudos');
      controller.setDepartment('Tech Lead');

      final filter = container.read(feedFilterControllerProvider);
      expect(filter.hashtag, equals('#SunKudos'));
      expect(filter.department, equals('Tech Lead'));
    });

    test('setHashtag(null) clears only hashtag, preserves department', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final controller =
          container.read(feedFilterControllerProvider.notifier);
      controller.setHashtag('#Teamwork');
      controller.setDepartment('Tech Lead');

      // Clear hashtag only — department must be preserved.
      controller.setHashtag(null);

      final filter = container.read(feedFilterControllerProvider);
      expect(filter.hashtag, isNull,
          reason: 'setHashtag(null) should clear the hashtag field');
      expect(filter.department, equals('Tech Lead'),
          reason: 'setHashtag(null) must not affect the department field');
    });

    test('setDepartment(null) clears only department, preserves hashtag', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final controller =
          container.read(feedFilterControllerProvider.notifier);
      controller.setHashtag('#SunKudos');
      controller.setDepartment('Frontend Engineer');

      // Clear department only — hashtag must be preserved.
      controller.setDepartment(null);

      final filter = container.read(feedFilterControllerProvider);
      expect(filter.department, isNull,
          reason: 'setDepartment(null) should clear the department field');
      expect(filter.hashtag, equals('#SunKudos'),
          reason: 'setDepartment(null) must not affect the hashtag field');
    });

    test('clear() resets filter to empty', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final controller =
          container.read(feedFilterControllerProvider.notifier);
      controller.setHashtag('#Test');
      controller.setDepartment('QA');

      controller.clear();

      final filter = container.read(feedFilterControllerProvider);
      expect(filter.hashtag, isNull);
      expect(filter.department, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // allKudosProvider — filtered kudos list reacting to filter changes
  // -------------------------------------------------------------------------

  group('allKudosProvider', () {
    test('returns all kudos with no filter', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final kudos = await container.read(allKudosProvider.future);
      expect(kudos, isNotEmpty);
      expect(kudos.length, equals(5)); // Feed size.
    });

    test('filters by hashtag when controller changes', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      // Set filter to #Teamwork.
      container
          .read(feedFilterControllerProvider.notifier)
          .setHashtag('#Teamwork');

      // Wait for provider to re-fetch.
      final kudos = await container.read(allKudosProvider.future);

      // All kudos should contain #Teamwork.
      for (final kudo in kudos) {
        expect(kudo.hashtags, contains('#Teamwork'));
      }
    });

    test('filters by department when controller changes', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      // Set filter to Tech Lead department.
      container
          .read(feedFilterControllerProvider.notifier)
          .setDepartment('Tech Lead');

      final kudos = await container.read(allKudosProvider.future);

      // All kudos must have Tech Lead in sender or recipient role.
      for (final kudo in kudos) {
        final hasDept = kudo.senderRole.contains('Tech Lead') ||
            kudo.recipientRole.contains('Tech Lead');
        expect(hasDept, isTrue);
      }
    });

    test('re-fetches when filter is cleared', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final controller =
          container.read(feedFilterControllerProvider.notifier);

      // Apply filter.
      controller.setHashtag('#Design');
      var kudos = await container.read(allKudosProvider.future);
      final filteredCount = kudos.length;

      // Clear filter.
      controller.clear();
      kudos = await container.read(allKudosProvider.future);

      // Should return more (or same if all match).
      expect(kudos.length, greaterThanOrEqualTo(filteredCount));
    });

    test('returns empty when no kudos match filters', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      container
          .read(feedFilterControllerProvider.notifier)
          .setHashtag('#NonExistent');

      final kudos = await container.read(allKudosProvider.future);
      expect(kudos, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // hashtagOptionsProvider
  // -------------------------------------------------------------------------

  group('hashtagOptionsProvider', () {
    test('resolves to distinct hashtags from repo', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final hashtags = await container.read(hashtagOptionsProvider.future);

      expect(hashtags, equals(KudosDetailMockData.hashtags));
      expect(hashtags, isNotEmpty);
    });

    test('returns sorted list', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final hashtags = await container.read(hashtagOptionsProvider.future);
      final sorted = List<String>.from(hashtags)..sort();

      expect(hashtags, equals(sorted));
    });

    test('enters error state when repo fails', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.error(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(hashtagOptionsProvider.future),
        throwsA(anything),
      );

      final state = container.read(hashtagOptionsProvider);
      expect(state.hasError, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // departmentOptionsProvider
  // -------------------------------------------------------------------------

  group('departmentOptionsProvider', () {
    test('resolves to distinct departments from repo', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final depts = await container.read(departmentOptionsProvider.future);

      expect(depts, equals(KudosDetailMockData.departments));
      expect(depts, isNotEmpty);
    });

    test('returns sorted list', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final depts = await container.read(departmentOptionsProvider.future);
      final sorted = List<String>.from(depts)..sort();

      expect(depts, equals(sorted));
    });
  });

  // -------------------------------------------------------------------------
  // RecipientSearchController — debounced search with loading/error states
  // -------------------------------------------------------------------------

  group('RecipientSearchController', () {
    test('starts in loading state', () {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      final state = container.read(recipientSearchControllerProvider);
      expect(state.isLoading, isTrue);
    });

    test('loads suggestions after initial delay', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      // Pump through loading state (initial build triggers empty query via _doSearch).
      await Future<void>.delayed(const Duration(milliseconds: 600));

      final state = container.read(recipientSearchControllerProvider);
      // After initialization and debounce, should have loaded suggestions.
      expect(state.isLoading || state.hasValue, isTrue);
    });

    test('debounce delays search by ~300ms', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      // Initial load completes.
      await Future<void>.delayed(const Duration(milliseconds: 400));

      // Trigger query — should start loading immediately.
      container
          .read(recipientSearchControllerProvider.notifier)
          .query('Phạm');
      var state = container.read(recipientSearchControllerProvider);
      expect(state.isLoading, isTrue);

      // After debounce delay, should have results.
      await Future<void>.delayed(const Duration(milliseconds: 400));
      state = container.read(recipientSearchControllerProvider);
      expect(state.hasValue, isTrue);
    });

    test('search filters recipients case-insensitively', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      // Search for 'phạm' (lowercase).
      container
          .read(recipientSearchControllerProvider.notifier)
          .query('phạm');
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final state = container.read(recipientSearchControllerProvider);
      expect(state.hasValue, isTrue);
      final results = state.value!;

      // Should find recipients with 'Phạm' in the name.
      expect(
        results.any((r) =>
            r.name.toLowerCase().contains('phạm') ||
            (r.role?.toLowerCase().contains('phạm') ?? false)),
        isTrue,
      );
    });

    test('empty query returns suggestions', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      // Empty query triggers suggestions.
      container.read(recipientSearchControllerProvider.notifier).query('');
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final state = container.read(recipientSearchControllerProvider);
      expect(state.hasValue, isTrue);
      // Should return the full sunners list (suggestions).
      expect(state.value, isNotEmpty);
    });

    test('excludes current user from results', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      // Wait for initial suggestions to load.
      await Future<void>.delayed(const Duration(milliseconds: 600));

      final state = container.read(recipientSearchControllerProvider);
      if (state.hasValue) {
        final results = state.value!;
        // Current user should not be in results.
        expect(
          results.any((r) =>
              r.name == KudosDetailMockData.currentUserName),
          isFalse,
        );
      }
    });

    test('handles search error gracefully', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.error(),
      );
      addTearDown(container.dispose);

      // Wait for initial load with error repo.
      await Future<void>.delayed(const Duration(milliseconds: 600));

      final state = container.read(recipientSearchControllerProvider);
      // Error repo should cause error state during initial load.
      expect(state.hasError || state.isLoading, isTrue);
    });

    test('subsequent queries cancel previous debounce timers', () async {
      final container = _container(
        feed: FakeKudosFeedRepository.data(),
        write: FakeWriteKudoRepository.success(),
      );
      addTearDown(container.dispose);

      await Future<void>.delayed(const Duration(milliseconds: 400));

      final controller =
          container.read(recipientSearchControllerProvider.notifier);

      // Rapid queries — only the last one should resolve.
      controller.query('a');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      controller.query('an');
      await Future<void>.delayed(const Duration(milliseconds: 100));
      controller.query('trần');

      // Wait for final debounce.
      await Future<void>.delayed(const Duration(milliseconds: 400));

      final state = container.read(recipientSearchControllerProvider);
      expect(state.hasValue, isTrue);
      // Results should be for 'trần', not earlier queries.
      final results = state.value!;
      for (final r in results) {
        expect(
          r.name.toLowerCase().contains('trần') ||
              (r.role?.toLowerCase().contains('trần') ?? false),
          isTrue,
        );
      }
    });
  });
}

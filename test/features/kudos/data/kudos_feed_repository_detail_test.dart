import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_detail_mock_data.dart';

void main() {
  // -------------------------------------------------------------------------
  // FakeKudosFeedRepository — getKudoById
  // -------------------------------------------------------------------------

  group('FakeKudosFeedRepository.getKudoById', () {
    test('.data() returns correct detail for kudo-001', () async {
      final repo = FakeKudosFeedRepository.data();
      final detail = await repo.getKudoById('kudo-001');

      expect(detail.id, equals('kudo-001'));
      expect(detail.senderName, equals('Nguyễn Minh Tuấn'));
      expect(detail.recipientName, equals('Trần Thị Lan'));
      expect(detail.title, equals('Rising Hero'));
      expect(detail.isAnonymous, isFalse);
    });

    test('.data() returns anonymous detail for kudo-003', () async {
      final repo = FakeKudosFeedRepository.data();
      final detail = await repo.getKudoById('kudo-003');

      expect(detail.id, equals('kudo-003'));
      expect(detail.isAnonymous, isTrue);
      // Sender name is still set but should be masked by UI.
      expect(detail.senderName, isNotEmpty);
    });

    test('.data() throws UnknownFailure for missing id', () async {
      final repo = FakeKudosFeedRepository.data();

      await expectLater(
        repo.getKudoById('nonexistent-id'),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.empty() throws UnknownFailure on getKudoById', () async {
      final repo = FakeKudosFeedRepository.empty();

      await expectLater(
        repo.getKudoById('kudo-001'),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.error() throws UnknownFailure on getKudoById', () async {
      final repo = FakeKudosFeedRepository.error();

      await expectLater(
        repo.getKudoById('kudo-001'),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.loading() never completes', () async {
      final repo = FakeKudosFeedRepository.loading();
      var completed = false;
      repo.getKudoById('kudo-001').then((_) => completed = true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completed, isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // FakeKudosFeedRepository — getAllKudos with filters
  // -------------------------------------------------------------------------

  group('FakeKudosFeedRepository.getAllKudos', () {
    test('.data() returns all feed kudos when no filter', () async {
      final repo = FakeKudosFeedRepository.data();
      final all = await repo.getAllKudos();

      expect(all, isNotEmpty);
      // Should match the feed size from KudosMockData.
      expect(all.length, equals(5));
    });

    test('.data() filters by hashtag correctly', () async {
      final repo = FakeKudosFeedRepository.data();
      final filtered = await repo.getAllKudos(hashtag: '#Teamwork');

      expect(filtered, isNotEmpty);
      // All results must contain #Teamwork.
      for (final kudo in filtered) {
        expect(kudo.hashtags, contains('#Teamwork'));
      }
    });

    test('.data() filters by department correctly', () async {
      final repo = FakeKudosFeedRepository.data();
      final filtered =
          await repo.getAllKudos(department: 'Frontend Engineer');

      expect(filtered, isNotEmpty);
      // All results must have the department in sender or recipient role.
      for (final kudo in filtered) {
        final hasDept = kudo.senderRole
                .toLowerCase()
                .contains('frontend engineer') ||
            kudo.recipientRole
                .toLowerCase()
                .contains('frontend engineer');
        expect(hasDept, isTrue);
      }
    });

    test('.data() filters by both hashtag and department', () async {
      final repo = FakeKudosFeedRepository.data();
      final filtered = await repo
          .getAllKudos(hashtag: '#SunKudos', department: 'Tech Lead');

      // Results must match both filters.
      for (final kudo in filtered) {
        expect(kudo.hashtags, contains('#SunKudos'));
        final hasDept = kudo.senderRole.toLowerCase().contains('tech lead') ||
            kudo.recipientRole.toLowerCase().contains('tech lead');
        expect(hasDept, isTrue);
      }
    });

    test('.data() returns empty for non-matching hashtag', () async {
      final repo = FakeKudosFeedRepository.data();
      final filtered = await repo.getAllKudos(hashtag: '#NonExistent');

      expect(filtered, isEmpty);
    });

    test('.empty() returns empty list', () async {
      final repo = FakeKudosFeedRepository.empty();
      final all = await repo.getAllKudos();

      expect(all, isEmpty);
    });

    test('.error() throws UnknownFailure', () async {
      final repo = FakeKudosFeedRepository.error();

      await expectLater(
        repo.getAllKudos(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // FakeKudosFeedRepository — getHashtags
  // -------------------------------------------------------------------------

  group('FakeKudosFeedRepository.getHashtags', () {
    test('.data() returns hashtags from KudosDetailMockData', () async {
      final repo = FakeKudosFeedRepository.data();
      final hashtags = await repo.getHashtags();

      expect(hashtags, equals(KudosDetailMockData.hashtags));
      expect(hashtags, isNotEmpty);
    });

    test('.data() returns distinct hashtags', () async {
      final repo = FakeKudosFeedRepository.data();
      final hashtags = await repo.getHashtags();

      expect(hashtags.toSet().length, equals(hashtags.length));
    });

    test('.data() returns sorted hashtags', () async {
      final repo = FakeKudosFeedRepository.data();
      final hashtags = await repo.getHashtags();
      final sorted = List<String>.from(hashtags)..sort();

      expect(hashtags, equals(sorted));
    });

    test('.empty() returns empty list', () async {
      final repo = FakeKudosFeedRepository.empty();
      final hashtags = await repo.getHashtags();

      expect(hashtags, isEmpty);
    });

    test('.error() throws UnknownFailure', () async {
      final repo = FakeKudosFeedRepository.error();

      await expectLater(
        repo.getHashtags(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // FakeKudosFeedRepository — getDepartments
  // -------------------------------------------------------------------------

  group('FakeKudosFeedRepository.getDepartments', () {
    test('.data() returns departments from KudosDetailMockData', () async {
      final repo = FakeKudosFeedRepository.data();
      final depts = await repo.getDepartments();

      expect(depts, equals(KudosDetailMockData.departments));
      expect(depts, isNotEmpty);
    });

    test('.data() returns distinct departments', () async {
      final repo = FakeKudosFeedRepository.data();
      final depts = await repo.getDepartments();

      expect(depts.toSet().length, equals(depts.length));
    });

    test('.data() returns sorted departments', () async {
      final repo = FakeKudosFeedRepository.data();
      final depts = await repo.getDepartments();
      final sorted = List<String>.from(depts)..sort();

      expect(depts, equals(sorted));
    });

    test('.empty() returns empty list', () async {
      final repo = FakeKudosFeedRepository.empty();
      final depts = await repo.getDepartments();

      expect(depts, isEmpty);
    });

    test('.error() throws UnknownFailure', () async {
      final repo = FakeKudosFeedRepository.error();

      await expectLater(
        repo.getDepartments(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });
}

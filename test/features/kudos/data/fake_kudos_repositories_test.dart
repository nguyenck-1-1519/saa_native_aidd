import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_feed_repository.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_kudos_stats_repository.dart';
import 'package:saa_2025/features/kudos/data/repositories/fake_write_kudo_repository.dart';
import 'package:saa_2025/features/kudos/data/sources/kudos_mock_data.dart';
import 'package:saa_2025/features/kudos/domain/entities/kudo_draft.dart';

void main() {
  // -------------------------------------------------------------------------
  // FakeKudosFeedRepository
  // -------------------------------------------------------------------------

  group('FakeKudosFeedRepository', () {
    test('.data() returns non-empty feed', () async {
      final repo = FakeKudosFeedRepository.data();
      final feed = await repo.getKudos();
      expect(feed, isNotEmpty);
      expect(feed, equals(KudosMockData.feed));
    });

    test('.data() returns non-empty highlights', () async {
      final repo = FakeKudosFeedRepository.data();
      final highlights = await repo.getHighlightKudos();
      expect(highlights, isNotEmpty);
      expect(highlights, equals(KudosMockData.highlights));
    });

    test('.data() returns non-empty recent recipients', () async {
      final repo = FakeKudosFeedRepository.data();
      final recipients = await repo.getRecentRecipients();
      expect(recipients, isNotEmpty);
      expect(recipients, equals(KudosMockData.recentRecipients));
    });

    test('.empty() returns empty feed', () async {
      final repo = FakeKudosFeedRepository.empty();
      final feed = await repo.getKudos();
      expect(feed, isEmpty);
    });

    test('.empty() returns empty highlights', () async {
      final repo = FakeKudosFeedRepository.empty();
      final highlights = await repo.getHighlightKudos();
      expect(highlights, isEmpty);
    });

    test('.empty() returns empty recipients', () async {
      final repo = FakeKudosFeedRepository.empty();
      final recipients = await repo.getRecentRecipients();
      expect(recipients, isEmpty);
    });

    test('.error() throws UnknownFailure on getKudos()', () async {
      final repo = FakeKudosFeedRepository.error();
      await expectLater(
        repo.getKudos,
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.error() throws UnknownFailure on getHighlightKudos()', () async {
      final repo = FakeKudosFeedRepository.error();
      await expectLater(
        repo.getHighlightKudos,
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.error() throws UnknownFailure on getRecentRecipients()', () async {
      final repo = FakeKudosFeedRepository.error();
      await expectLater(
        repo.getRecentRecipients,
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.loading() never completes', () async {
      final repo = FakeKudosFeedRepository.loading();
      var completed = false;
      repo.getKudos().then((_) => completed = true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completed, isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // FakeKudosStatsRepository
  // -------------------------------------------------------------------------

  group('FakeKudosStatsRepository', () {
    test('.data() returns non-empty stats equal to KudosMockData.stats',
        () async {
      final repo = FakeKudosStatsRepository.data();
      final stats = await repo.getStats();
      expect(stats, equals(KudosMockData.stats));
      expect(stats.received, greaterThan(0));
    });

    test('.error() throws UnknownFailure on getStats()', () async {
      final repo = FakeKudosStatsRepository.error();
      await expectLater(
        repo.getStats,
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.loading() never completes', () async {
      final repo = FakeKudosStatsRepository.loading();
      var completed = false;
      repo.getStats().then((_) => completed = true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completed, isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // FakeWriteKudoRepository
  // -------------------------------------------------------------------------

  group('FakeWriteKudoRepository', () {
    const draft = KudoDraft(
      recipientId: 'user-001',
      title: 'Title',
      message: 'Message',
      hashtags: ['#Test'],
      isAnonymous: false,
    );

    test('.success() resolves without error', () async {
      final repo = FakeWriteKudoRepository.success();
      await expectLater(repo.submitKudo(draft), completes);
    });

    test('.error() throws UnknownFailure', () async {
      final repo = FakeWriteKudoRepository.error();
      await expectLater(
        () => repo.submitKudo(draft),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.loading() never completes', () async {
      final repo = FakeWriteKudoRepository.loading();
      var completed = false;
      repo.submitKudo(draft).then((_) => completed = true);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(completed, isFalse);
    });
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/awards/data/repositories/fake_awards_detail_repository.dart';
import 'package:saa_2025/features/awards/data/sources/awards_detail_mock_data.dart';
import 'package:saa_2025/features/awards/domain/entities/award_detail.dart';

void main() {
  group('FakeAwardsDetailRepository', () {
    test('.data() returns 5 awards immediately', () async {
      final repo = FakeAwardsDetailRepository.data();
      final result = await repo.getAwardDetails();

      expect(result, isA<List<AwardDetail>>());
      expect(result.length, equals(5));
      expect(result, equals(AwardsDetailMockData.awards));
    });

    test('.data() awards have required fields', () async {
      final repo = FakeAwardsDetailRepository.data();
      final result = await repo.getAwardDetails();

      for (final award in result) {
        expect(award.id, isNotEmpty);
        expect(award.name, isNotEmpty);
        expect(award.description, isNotEmpty);
        expect(award.badgeImageRef, isNotEmpty);
        expect(award.quantityValue, isNotEmpty);
        expect(award.quantityUnit, isNotEmpty);
        expect(award.prizeValue, isNotEmpty);
        expect(award.prizeNote, isNotEmpty);
      }
    });

    test('.data() contains all 5 award ids', () async {
      final repo = FakeAwardsDetailRepository.data();
      final result = await repo.getAwardDetails();

      final ids = result.map((a) => a.id).toList();
      expect(ids, containsAll([
        'top-talent',
        'top-project-leader',
        'best-manager',
        'signature-creator',
        'mvp',
      ]));
    });

    test('.empty() returns empty list immediately', () async {
      final repo = FakeAwardsDetailRepository.empty();
      final result = await repo.getAwardDetails();

      expect(result, isA<List<AwardDetail>>());
      expect(result.isEmpty, isTrue);
    });

    test('.error() throws UnknownFailure immediately', () async {
      final repo = FakeAwardsDetailRepository.error();

      expect(
        () => repo.getAwardDetails(),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('.loading() never completes', () async {
      final repo = FakeAwardsDetailRepository.loading();
      final future = repo.getAwardDetails();

      // Pump event loop briefly to ensure it's still pending.
      await Future.delayed(const Duration(milliseconds: 10));

      // Future should still be pending (not completed).
      expect(future, isA<Future<List<AwardDetail>>>());
      expect(future.timeout(const Duration(milliseconds: 5)),
          throwsA(isA<TimeoutException>()));
    });
  });
}

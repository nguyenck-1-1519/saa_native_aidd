import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/home/data/repositories/fake_awards_repository.dart';
import 'package:saa_2025/features/home/data/sources/home_mock_data.dart';

void main() {
  group('FakeAwardsRepository', () {
    test('.data() returns design-sourced awards immediately', () async {
      final repo = FakeAwardsRepository.data();
      final awards = await repo.getAwards();
      expect(awards, HomeMockData.awards);
      expect(awards, isNotEmpty);
    });

    test('.empty() returns empty list immediately', () async {
      final repo = FakeAwardsRepository.empty();
      final awards = await repo.getAwards();
      expect(awards, isEmpty);
    });

    test('.error() throws UnknownFailure immediately', () async {
      final repo = FakeAwardsRepository.error();
      expect(() => repo.getAwards(), throwsA(isA<UnknownFailure>()));
    });

    test('.loading() returns a future that does not complete synchronously',
        () async {
      final repo = FakeAwardsRepository.loading();
      var completed = false;
      // ignore: unawaited_futures
      repo.getAwards().then((_) => completed = true);
      // Yield control once — the loading future must not have resolved.
      await Future<void>.value();
      expect(completed, isFalse);
    });

    test('HomeMockData has exactly 3 award cards', () {
      expect(HomeMockData.awards.length, 3);
    });

    test('award IDs are unique', () {
      final ids = HomeMockData.awards.map((a) => a.id).toSet();
      expect(ids.length, HomeMockData.awards.length);
    });

    test('all award cards have non-empty imageRef', () {
      for (final card in HomeMockData.awards) {
        expect(card.imageRef, isNotEmpty);
      }
    });
  });
}

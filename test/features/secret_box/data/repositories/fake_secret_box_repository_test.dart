import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/secret_box/data/repositories/fake_secret_box_repository.dart';

void main() {
  group('FakeSecretBoxRepository', () {
    group('.empty()', () {
      test('returns state with 1 unopened, 0 opened', () async {
        final repo = FakeSecretBoxRepository.empty();
        final state = await repo.getState();

        expect(state.unopenedCount, equals(1));
        expect(state.openedRewards, isEmpty);
      });

      test('returns a reward on open()', () async {
        final repo = FakeSecretBoxRepository.empty();
        final reward = await repo.open();

        expect(reward.id, equals('fake-reward-1'));
        expect(reward.name, equals('Test Reward'));
      });

      test('resolves immediately (no delay)', () async {
        final repo = FakeSecretBoxRepository.empty();
        final startTime = DateTime.now();

        await repo.getState();

        final duration = DateTime.now().difference(startTime);
        // Should complete in < 100 ms (no artificial delay like StubSecretBoxRepository).
        expect(duration.inMilliseconds, lessThan(100));
      });
    });

    group('.none()', () {
      test('returns state with 0 unopened, 0 opened', () async {
        final repo = FakeSecretBoxRepository.none();
        final state = await repo.getState();

        expect(state.unopenedCount, equals(0));
        expect(state.openedRewards, isEmpty);
      });

      test('throws UnknownFailure on open()', () async {
        final repo = FakeSecretBoxRepository.none();

        expect(
          () => repo.open(),
          throwsA(isA<UnknownFailure>()),
        );
      });
    });

    group('.error()', () {
      test('throws UnknownFailure on getState()', () async {
        final repo = FakeSecretBoxRepository.error();

        expect(
          () => repo.getState(),
          throwsA(isA<UnknownFailure>()),
        );
      });

      test('throws UnknownFailure on open()', () async {
        final repo = FakeSecretBoxRepository.error();

        expect(
          () => repo.open(),
          throwsA(isA<UnknownFailure>()),
        );
      });
    });

    group('.loading()', () {
      test('never completes for getState()', () async {
        final repo = FakeSecretBoxRepository.loading();
        bool resolved = false;

        repo.getState().then((_) {
          resolved = true;
        });

        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(resolved, isFalse);
      });

      test('never completes for open()', () async {
        final repo = FakeSecretBoxRepository.loading();
        bool resolved = false;

        repo.open().then((_) {
          resolved = true;
        });

        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(resolved, isFalse);
      });
    });
  });
}

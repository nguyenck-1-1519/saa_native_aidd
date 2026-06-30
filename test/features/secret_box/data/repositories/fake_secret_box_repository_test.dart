import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/secret_box/data/repositories/fake_secret_box_repository.dart';
import 'package:saa_2025/features/secret_box/domain/entities/secret_box_reward.dart';
import 'package:saa_2025/features/secret_box/domain/usecases/draw_secret_box_reward.dart';

void main() {
  group('FakeSecretBoxRepository', () {
    group('.empty()', () {
      test('returns state with 7 unopened, 0 opened', () async {
        final repo = FakeSecretBoxRepository.empty();
        final state = await repo.getState();

        expect(state.unopenedCount, equals(7));
        expect(state.openedRewards, isEmpty);
        expect(state.collectedIconIds, isEmpty);
      });

      test('draw() returns a DrawResult with an icon reward', () async {
        final repo = FakeSecretBoxRepository.empty();
        final result = await repo.draw();

        expect(result, isA<DrawResult>());
        expect(result.reward.kind, equals(SecretBoxRewardKind.icon));
        expect(result.reward.iconId, isNotNull);
        expect(result.nextState.unopenedCount, equals(6));
        expect(result.nextState.collectedIconIds, hasLength(1));
      });

      test('draw() completes the set and returns gift on 6th draw', () async {
        // Domain rule (DrawSecretBoxReward): when only 1 icon remains uncollected
        // the draw that picks it returns the GIFT (set-completion reveal), not
        // an icon. So draws 1–5 yield icons, draw 6 returns the gift.
        final repo = FakeSecretBoxRepository.empty();

        // Draws 1–5: all icon reveals.
        final collectedIds = <String>{};
        for (var i = 0; i < 5; i++) {
          final result = await repo.draw();
          expect(
            result.reward.kind,
            equals(SecretBoxRewardKind.icon),
            reason: 'draw ${i + 1} should be an icon (only ${6 - i} unowned left)',
          );
          collectedIds.add(result.reward.iconId!);
        }
        expect(collectedIds, hasLength(5));

        // Draw 6: 1 unowned icon left → domain returns gift (set-completion).
        final giftResult = await repo.draw();
        expect(giftResult.reward.kind, equals(SecretBoxRewardKind.gift));
        expect(giftResult.nextState.unopenedCount, equals(1));

        // Draw 7: set fully collected → gift again (all-collected path).
        final giftResult2 = await repo.draw();
        expect(giftResult2.reward.kind, equals(SecretBoxRewardKind.gift));
        expect(giftResult2.nextState.unopenedCount, equals(0));
      });

      test('resolves immediately (no delay)', () async {
        final repo = FakeSecretBoxRepository.empty();
        final startTime = DateTime.now();

        await repo.getState();

        final duration = DateTime.now().difference(startTime);
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

      test('draw() throws UnknownFailure', () async {
        final repo = FakeSecretBoxRepository.none();

        expect(
          () => repo.draw(),
          throwsA(isA<UnknownFailure>()),
        );
      });
    });

    group('.error()', () {
      test('throws UnknownFailure on getState()', () {
        final repo = FakeSecretBoxRepository.error();

        expect(
          () => repo.getState(),
          throwsA(isA<UnknownFailure>()),
        );
      });

      test('throws UnknownFailure on draw()', () {
        final repo = FakeSecretBoxRepository.error();

        expect(
          () => repo.draw(),
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

      test('never completes for draw()', () async {
        final repo = FakeSecretBoxRepository.loading();
        bool resolved = false;

        repo.draw().then((_) {
          resolved = true;
        });

        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(resolved, isFalse);
      });
    });

    group('.withReward()', () {
      test('returns the specified reward on first draw', () async {
        const reward = SecretBoxReward(
          id: 'test-icon',
          kind: SecretBoxRewardKind.icon,
          name: 'TEST ICON',
          descriptor: '',
          iconId: 'TEST',
        );
        final repo = FakeSecretBoxRepository.withReward(reward);
        final result = await repo.draw();

        expect(result.reward, equals(reward));
        expect(result.nextState.unopenedCount, equals(0));
      });

      test('throws UnknownFailure on second draw', () async {
        const reward = SecretBoxReward(
          id: 'test-icon',
          kind: SecretBoxRewardKind.icon,
          name: 'TEST ICON',
          descriptor: '',
          iconId: 'TEST',
        );
        final repo = FakeSecretBoxRepository.withReward(reward);
        await repo.draw(); // first draw

        expect(
          () => repo.draw(),
          throwsA(isA<UnknownFailure>()),
        );
      });
    });
  });
}

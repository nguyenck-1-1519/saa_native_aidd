import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/secret_box/domain/entities/secret_box_reward.dart';
import 'package:saa_2025/features/secret_box/domain/entities/secret_box_state.dart';

void main() {
  group('SecretBoxState', () {
    test('constructs with unopenedCount and empty openedRewards', () {
      const state = SecretBoxState(
        unopenedCount: 5,
        openedRewards: [],
      );

      expect(state.unopenedCount, equals(5));
      expect(state.openedRewards, isEmpty);
    });

    test('constructs with unopenedCount and list of openedRewards', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        name: 'Gift 1',
        descriptor: 'Desc 1',
      );
      const reward2 = SecretBoxReward(
        id: 'r2',
        name: 'Gift 2',
        descriptor: 'Desc 2',
      );
      final state = SecretBoxState(
        unopenedCount: 3,
        openedRewards: [reward1, reward2],
      );

      expect(state.unopenedCount, equals(3));
      expect(state.openedRewards, equals([reward1, reward2]));
    });

    test('supports unopenedCount of 0 (none-left state)', () {
      const state = SecretBoxState(
        unopenedCount: 0,
        openedRewards: [],
      );

      expect(state.unopenedCount, equals(0));
    });

    test('supports equality comparison by value', () {
      const reward = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
      );
      const state1 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
      );
      const state2 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
      );

      expect(state1, equals(state2));
    });

    test('distinguishes by unopenedCount', () {
      const state1 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [],
      );
      const state2 = SecretBoxState(
        unopenedCount: 3,
        openedRewards: [],
      );

      expect(state1, isNot(equals(state2)));
    });

    test('distinguishes by openedRewards list', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        name: 'Gift 1',
        descriptor: 'Desc 1',
      );
      const reward2 = SecretBoxReward(
        id: 'r2',
        name: 'Gift 2',
        descriptor: 'Desc 2',
      );
      const state1 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward1],
      );
      const state2 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward1, reward2],
      );

      expect(state1, isNot(equals(state2)));
    });

    test('hashCode is consistent across equal instances', () {
      const reward = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
      );
      const state1 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
      );
      const state2 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
      );

      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('toString produces readable output', () {
      const state = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [],
      );

      expect(
        state.toString(),
        contains('SecretBoxState('),
      );
      expect(state.toString(), contains('unopenedCount: 2'));
    });
  });
}

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
      expect(state.collectedIconIds, isEmpty);
    });

    test('constructs with collectedIconIds', () {
      const state = SecretBoxState(
        unopenedCount: 3,
        openedRewards: [],
        collectedIconIds: {'REVIVAL', 'STAY_GOLD'},
      );

      expect(state.collectedIconIds, containsAll(['REVIVAL', 'STAY_GOLD']));
      expect(state.collectedIconIds, hasLength(2));
    });

    test('constructs with unopenedCount and list of openedRewards', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift 1',
        descriptor: 'Desc 1',
        iconId: 'ICON_1',
      );
      const reward2 = SecretBoxReward(
        id: 'r2',
        kind: SecretBoxRewardKind.gift,
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

    test('copyWith updates individual fields', () {
      const reward = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'REVIVAL',
        descriptor: '',
        iconId: 'REVIVAL',
      );
      const state = SecretBoxState(unopenedCount: 5, openedRewards: []);
      final updated = state.copyWith(
        unopenedCount: 4,
        openedRewards: [reward],
        collectedIconIds: {'REVIVAL'},
      );

      expect(updated.unopenedCount, equals(4));
      expect(updated.openedRewards, equals([reward]));
      expect(updated.collectedIconIds, contains('REVIVAL'));
    });

    test('supports equality comparison by value', () {
      const reward = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift',
        descriptor: 'Desc',
        iconId: 'G1',
      );
      const state1 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
        collectedIconIds: {'G1'},
      );
      const state2 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
        collectedIconIds: {'G1'},
      );

      expect(state1, equals(state2));
    });

    test('distinguishes by unopenedCount', () {
      const state1 = SecretBoxState(unopenedCount: 2, openedRewards: []);
      const state2 = SecretBoxState(unopenedCount: 3, openedRewards: []);

      expect(state1, isNot(equals(state2)));
    });

    test('distinguishes by collectedIconIds', () {
      const state1 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [],
        collectedIconIds: {'REVIVAL'},
      );
      const state2 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [],
        collectedIconIds: {'STAY_GOLD'},
      );

      expect(state1, isNot(equals(state2)));
    });

    test('distinguishes by openedRewards list', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift 1',
        descriptor: 'Desc 1',
        iconId: 'R1',
      );
      const reward2 = SecretBoxReward(
        id: 'r2',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift 2',
        descriptor: 'Desc 2',
        iconId: 'R2',
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
        kind: SecretBoxRewardKind.icon,
        name: 'Gift',
        descriptor: 'Desc',
        iconId: 'G1',
      );
      const state1 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
        collectedIconIds: {'G1'},
      );
      const state2 = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [reward],
        collectedIconIds: {'G1'},
      );

      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('toString produces readable output', () {
      const state = SecretBoxState(
        unopenedCount: 2,
        openedRewards: [],
      );

      expect(state.toString(), contains('SecretBoxState('));
      expect(state.toString(), contains('unopenedCount: 2'));
    });
  });
}

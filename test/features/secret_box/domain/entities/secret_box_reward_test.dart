import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/secret_box/domain/entities/secret_box_reward.dart';

void main() {
  group('SecretBoxReward', () {
    test('constructs with all fields including optional assetRef', () {
      const reward = SecretBoxReward(
        id: 'reward-1',
        kind: SecretBoxRewardKind.gift,
        name: 'Khăn Root Further',
        descriptor: 'Quà từ BTC SAA 2025',
        assetRef: 'assets/images/reward.png',
      );

      expect(reward.id, equals('reward-1'));
      expect(reward.kind, equals(SecretBoxRewardKind.gift));
      expect(reward.name, equals('Khăn Root Further'));
      expect(reward.descriptor, equals('Quà từ BTC SAA 2025'));
      expect(reward.assetRef, equals('assets/images/reward.png'));
    });

    test('constructs with nullable assetRef', () {
      const reward = SecretBoxReward(
        id: 'reward-2',
        kind: SecretBoxRewardKind.icon,
        name: 'Mystery Item',
        descriptor: 'Special Gift',
        iconId: 'MYSTERY',
      );

      expect(reward.assetRef, isNull);
      expect(reward.iconId, equals('MYSTERY'));
    });

    test('icon reward has non-null iconId', () {
      const reward = SecretBoxReward(
        id: 'icon-revival',
        kind: SecretBoxRewardKind.icon,
        name: 'REVIVAL',
        descriptor: '',
        iconId: 'REVIVAL',
      );

      expect(reward.kind, equals(SecretBoxRewardKind.icon));
      expect(reward.iconId, equals('REVIVAL'));
    });

    test('gift reward has null iconId', () {
      const reward = SecretBoxReward(
        id: 'gift-1',
        kind: SecretBoxRewardKind.gift,
        name: 'Khăn Root Further',
        descriptor: 'Quà từ BTC SAA 2025',
      );

      expect(reward.kind, equals(SecretBoxRewardKind.gift));
      expect(reward.iconId, isNull);
    });

    test('supports equality comparison by value', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift A',
        descriptor: 'Desc A',
        iconId: 'A',
        assetRef: null,
      );
      const reward2 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift A',
        descriptor: 'Desc A',
        iconId: 'A',
        assetRef: null,
      );

      expect(reward1, equals(reward2));
    });

    test('distinguishes by id', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift',
        descriptor: 'Desc',
        iconId: 'X',
      );
      const reward2 = SecretBoxReward(
        id: 'r2',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift',
        descriptor: 'Desc',
        iconId: 'X',
      );

      expect(reward1, isNot(equals(reward2)));
    });

    test('distinguishes by kind', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.icon,
        name: 'Gift',
        descriptor: 'Desc',
        iconId: 'X',
      );
      const reward2 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.gift,
        name: 'Gift',
        descriptor: 'Desc',
      );

      expect(reward1, isNot(equals(reward2)));
    });

    test('distinguishes by assetRef', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.gift,
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path1.png',
      );
      const reward2 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.gift,
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path2.png',
      );

      expect(reward1, isNot(equals(reward2)));
    });

    test('hashCode is consistent across equal instances', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.gift,
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path.png',
      );
      const reward2 = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.gift,
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path.png',
      );

      expect(reward1.hashCode, equals(reward2.hashCode));
    });

    test('toString produces readable output', () {
      const reward = SecretBoxReward(
        id: 'r1',
        kind: SecretBoxRewardKind.gift,
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path.png',
      );

      expect(reward.toString(), contains('SecretBoxReward('));
      expect(reward.toString(), contains('id: r1'));
      expect(reward.toString(), contains('name: Gift'));
      expect(reward.toString(), contains('kind:'));
    });
  });
}

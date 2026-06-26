import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/secret_box/domain/entities/secret_box_reward.dart';

void main() {
  group('SecretBoxReward', () {
    test('constructs with all fields including optional assetRef', () {
      const reward = SecretBoxReward(
        id: 'reward-1',
        name: 'Khăn Root Further',
        descriptor: 'Quà từ BTC SAA 2025',
        assetRef: 'assets/images/reward.png',
      );

      expect(reward.id, equals('reward-1'));
      expect(reward.name, equals('Khăn Root Further'));
      expect(reward.descriptor, equals('Quà từ BTC SAA 2025'));
      expect(reward.assetRef, equals('assets/images/reward.png'));
    });

    test('constructs with nullable assetRef', () {
      const reward = SecretBoxReward(
        id: 'reward-2',
        name: 'Mystery Item',
        descriptor: 'Special Gift',
      );

      expect(reward.assetRef, isNull);
    });

    test('supports equality comparison by value', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        name: 'Gift A',
        descriptor: 'Desc A',
        assetRef: null,
      );
      const reward2 = SecretBoxReward(
        id: 'r1',
        name: 'Gift A',
        descriptor: 'Desc A',
        assetRef: null,
      );

      expect(reward1, equals(reward2));
    });

    test('distinguishes by id', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
      );
      const reward2 = SecretBoxReward(
        id: 'r2',
        name: 'Gift',
        descriptor: 'Desc',
      );

      expect(reward1, isNot(equals(reward2)));
    });

    test('distinguishes by assetRef', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path1.png',
      );
      const reward2 = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path2.png',
      );

      expect(reward1, isNot(equals(reward2)));
    });

    test('hashCode is consistent across equal instances', () {
      const reward1 = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path.png',
      );
      const reward2 = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path.png',
      );

      expect(reward1.hashCode, equals(reward2.hashCode));
    });

    test('toString produces readable output', () {
      const reward = SecretBoxReward(
        id: 'r1',
        name: 'Gift',
        descriptor: 'Desc',
        assetRef: 'path.png',
      );

      expect(
        reward.toString(),
        contains('SecretBoxReward('),
      );
      expect(reward.toString(), contains('id: r1'));
      expect(reward.toString(), contains('name: Gift'));
    });
  });
}

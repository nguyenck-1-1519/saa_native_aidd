import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/secret_box/data/repositories/fake_secret_box_repository.dart';
import 'package:saa_2025/features/secret_box/domain/entities/secret_box_reward.dart';
import 'package:saa_2025/features/secret_box/domain/usecases/open_secret_box.dart';

void main() {
  group('OpenSecretBox', () {
    test('returns a SecretBoxReward when boxes remain', () async {
      final repo = FakeSecretBoxRepository.empty();
      final usecase = OpenSecretBox(repo);

      final reward = await usecase.call();

      expect(reward, isA<SecretBoxReward>());
      expect(reward.id, equals('fake-reward-1'));
      expect(reward.name, equals('Test Reward'));
    });

    test('throws UnknownFailure when no boxes remain', () async {
      final repo = FakeSecretBoxRepository.none();
      final usecase = OpenSecretBox(repo);

      expect(
        () => usecase.call(),
        throwsA(isA<UnknownFailure>()),
      );
    });

    test('throws exception when repo throws an error', () async {
      final repo = FakeSecretBoxRepository.error();
      final usecase = OpenSecretBox(repo);

      expect(
        () => usecase.call(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });
}

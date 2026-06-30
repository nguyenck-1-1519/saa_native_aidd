import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/secret_box/data/repositories/fake_secret_box_repository.dart';
import 'package:saa_2025/features/secret_box/domain/usecases/draw_secret_box_reward.dart';
import 'package:saa_2025/features/secret_box/domain/usecases/open_secret_box.dart';

void main() {
  group('OpenSecretBox', () {
    test('returns a DrawResult with a reward when boxes remain', () async {
      final repo = FakeSecretBoxRepository.empty();
      final usecase = OpenSecretBox(repo);

      final result = await usecase.call();

      expect(result, isA<DrawResult>());
      expect(result.reward.id, isNotEmpty);
      expect(result.nextState.unopenedCount, lessThan(7));
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

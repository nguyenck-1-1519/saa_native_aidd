import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/secret_box/data/repositories/fake_secret_box_repository.dart';
import 'package:saa_2025/features/secret_box/domain/entities/secret_box_state.dart';
import 'package:saa_2025/features/secret_box/domain/usecases/get_secret_box_state.dart';

void main() {
  group('GetSecretBoxState', () {
    test('returns SecretBoxState with unopenedCount and openedRewards', () async {
      final repo = FakeSecretBoxRepository.empty();
      final usecase = GetSecretBoxState(repo);

      final state = await usecase.call();

      expect(state, isA<SecretBoxState>());
      expect(state.unopenedCount, equals(1));
      expect(state.openedRewards, isEmpty);
    });

    test('reflects unopenedCount=0 in none-left state', () async {
      final repo = FakeSecretBoxRepository.none();
      final usecase = GetSecretBoxState(repo);

      final state = await usecase.call();

      expect(state.unopenedCount, equals(0));
      expect(state.openedRewards, isEmpty);
    });

    test('throws UnknownFailure when repo throws error', () async {
      final repo = FakeSecretBoxRepository.error();
      final usecase = GetSecretBoxState(repo);

      expect(
        () => usecase.call(),
        throwsA(isA<UnknownFailure>()),
      );
    });
  });
}

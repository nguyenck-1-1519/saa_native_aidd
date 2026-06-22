import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';
import 'package:saa_2025/features/auth/domain/repositories/auth_repository.dart';
import 'package:saa_2025/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:saa_2025/features/auth/domain/usecases/sign_out.dart';
import 'package:saa_2025/features/auth/domain/usecases/watch_auth_state.dart';

/// Mock [AuthRepository] using mocktail.
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  group('SignInWithGoogle', () {
    test('calls repository.signInWithGoogle and returns user (FUN_005)', () async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
        displayName: 'Test User',
      );
      when(() => mockRepo.signInWithGoogle()).thenAnswer((_) async => user);

      final usecase = SignInWithGoogle(mockRepo);
      final result = await usecase.call();

      expect(result, equals(user));
      verify(() => mockRepo.signInWithGoogle()).called(1);
    });

    test('propagates NetworkFailure from repository', () async {
      when(() => mockRepo.signInWithGoogle())
          .thenThrow(const NetworkFailure('No network'));

      final usecase = SignInWithGoogle(mockRepo);
      expect(
        () => usecase.call(),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('propagates AccountDisabled from repository', () async {
      when(() => mockRepo.signInWithGoogle())
          .thenThrow(const AccountDisabled('Account locked'));

      final usecase = SignInWithGoogle(mockRepo);
      expect(
        () => usecase.call(),
        throwsA(isA<AccountDisabled>()),
      );
    });

    test('propagates AuthCancelled from repository (FUN_010)', () async {
      when(() => mockRepo.signInWithGoogle())
          .thenThrow(const AuthCancelled('User cancelled'));

      final usecase = SignInWithGoogle(mockRepo);
      expect(
        () => usecase.call(),
        throwsA(isA<AuthCancelled>()),
      );
    });
  });

  group('SignOut', () {
    test('calls repository.signOut', () async {
      when(() => mockRepo.signOut()).thenAnswer((_) async {});

      final usecase = SignOut(mockRepo);
      await usecase.call();

      verify(() => mockRepo.signOut()).called(1);
    });
  });

  group('WatchAuthState', () {
    test('returns stream from repository', () async {
      final user = const AuthUser(
        id: 'user-123',
        email: 'user@example.com',
      );
      when(() => mockRepo.watchAuthState()).thenAnswer(
        (_) => Stream.fromIterable([null, user]),
      );

      final usecase = WatchAuthState(mockRepo);
      final stream = usecase.call();

      expect(stream, emitsInOrder([null, user]));
    });
  });
}

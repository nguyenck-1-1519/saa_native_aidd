import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/error/failures.dart';
import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';

void main() {
  group('FakeAuthRepository', () {
    test('signInWithGoogle success returns user (FUN_011)', () async {
      final fake = FakeAuthRepository();

      final user = await fake.signInWithGoogle();

      expect(user.id, 'fake-user-id');
      expect(user.email, 'sunner@sun-asterisk.com');
    });

    test('signInWithGoogle increments call count', () async {
      final fake = FakeAuthRepository();

      expect(fake.signInCallCount, 0);
      await fake.signInWithGoogle();
      expect(fake.signInCallCount, 1);
      await fake.signInWithGoogle();
      expect(fake.signInCallCount, 2);
    });

    test('signInWithGoogle throws nextFailure once then clears it', () async {
      final fake = FakeAuthRepository();
      final failure = NetworkFailure('Test error');
      fake.nextFailure = failure;

      expect(
        () => fake.signInWithGoogle(),
        throwsA(isA<NetworkFailure>()),
      );
      // Wait a bit for the async operation to complete
      await Future.delayed(const Duration(milliseconds: 100));
      expect(fake.nextFailure, isNull);

      // Next call succeeds
      final user = await fake.signInWithGoogle();
      expect(user.id, 'fake-user-id');
    });

    test('watchAuthState emits initial then updates', () async {
      final initialUser = const AuthUser(
        id: 'initial-user',
        email: 'initial@example.com',
      );
      final fake = FakeAuthRepository(initialUser: initialUser);

      final stream = fake.watchAuthState();

      expect(
        stream,
        emitsInOrder([
          initialUser,
          const AuthUser(
            id: 'fake-user-id',
            email: 'sunner@sun-asterisk.com',
            displayName: 'Sun* Tester',
          ),
        ]),
      );

      await fake.signInWithGoogle();
    });

    test('signOut clears current user', () async {
      final fake = FakeAuthRepository();
      await fake.signInWithGoogle();
      expect(fake.currentUser, isNotNull);

      await fake.signOut();

      expect(fake.currentUser, isNull);
    });

    test('currentUser returns seeded user initially', () async {
      final user = const AuthUser(
        id: 'seeded-user',
        email: 'seeded@example.com',
      );
      final fake = FakeAuthRepository(initialUser: user);

      expect(fake.currentUser, user);
    });

    test('dispose closes the stream', () async {
      final fake = FakeAuthRepository();
      final stream = fake.watchAuthState();
      final subscription = stream.listen((_) {});

      // Wait for initial event before closing
      await Future.delayed(const Duration(milliseconds: 50));
      fake.dispose();

      // Stream should be closed now
      await expectLater(
        subscription.asFuture(),
        completes,
      );
    });

    test('signInDelay delays the response', () async {
      final fake = FakeAuthRepository(
        signInDelay: const Duration(milliseconds: 100),
      );

      final stopwatch = Stopwatch()..start();
      await fake.signInWithGoogle();
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
    });
  });
}

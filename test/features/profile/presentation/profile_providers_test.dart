import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:saa_2025/features/auth/domain/entities/auth_user.dart';
import 'package:saa_2025/features/auth/presentation/providers/auth_providers.dart';
import 'package:saa_2025/features/profile/data/repositories/fake_profile_repository.dart';
import 'package:saa_2025/features/profile/data/sources/profile_mock_data.dart';
import 'package:saa_2025/features/profile/presentation/providers/profile_providers.dart';

/// Helper to build a [ProviderContainer] with overrides.
ProviderContainer _container({
  FakeProfileRepository? profileRepo,
  AuthUser? authUser,
}) {
  return ProviderContainer(
    overrides: [
      if (profileRepo != null)
        profileRepositoryProvider.overrideWithValue(profileRepo),
      authRepositoryProvider.overrideWithValue(
        FakeAuthRepository(initialUser: authUser),
      ),
    ],
  );
}

void main() {
  group('profileProvider', () {
    test('loads ProfileData for a given userId', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final result = await container
          .read(profileProvider(ProfileMockData.selfUserId).future);

      expect(result.user.name, 'Sun* Tester');
      expect(result.stats.received, 24);
    });

    test('distinguishes self vs other by userId', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final self =
          await container.read(profileProvider(ProfileMockData.selfUserId).future);
      final other =
          await container.read(profileProvider(ProfileMockData.otherUserId).future);

      expect(self.user.name, 'Sun* Tester');
      expect(other.user.name, 'Phạm Quốc Bảo');
    });

    test('handles empty state (FakeProfileRepository.empty)', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.empty(),
      );
      addTearDown(container.dispose);

      final result = await container
          .read(profileProvider(ProfileMockData.selfUserId).future);

      expect(result, isNotNull);
      // empty() returns a genuinely zeroed profile — empty awards + kudos.
      expect(result.awards, isEmpty);
      expect(result.recentKudos, isEmpty);
      expect(result.stats.received, 0);
      expect(result.stats.sent, 0);
    });

    test('enters loading state when repo is loading', () {
      final container = _container(
        profileRepo: FakeProfileRepository.loading(),
      );
      addTearDown(container.dispose);

      final state = container.read(profileProvider(ProfileMockData.selfUserId));
      expect(state.isLoading, isTrue);
    });

    test('enters error state when repo throws', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.error(),
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(profileProvider(ProfileMockData.selfUserId).future),
        throwsA(anything),
      );

      final state = container.read(profileProvider(ProfileMockData.selfUserId));
      expect(state.hasError, isTrue);
    });

    test('caches result per userId (same id = same cached entry)', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final result1 =
          await container.read(profileProvider(ProfileMockData.selfUserId).future);
      final result2 =
          await container.read(profileProvider(ProfileMockData.selfUserId).future);

      // Same cached instance (Riverpod caching).
      expect(identical(result1, result2), isTrue);
    });

    test('separate cache entries per userId', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final self =
          await container.read(profileProvider(ProfileMockData.selfUserId).future);
      final other =
          await container.read(profileProvider(ProfileMockData.otherUserId).future);

      // Different ids = different cache entries.
      expect(identical(self, other), isFalse);
      expect(self.user.id, isNot(other.user.id));
    });
  });

  group('currentUserIdProvider', () {
    test('provider is defined and readable', () {
      // currentUserIdProvider reads from authStateProvider.
      // In unit tests without full widget context, authStateProvider
      // is typically not initialized, so this just verifies it's wired.
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Should be readable without crashing (may be null in unit test context).
      final userId = container.read(currentUserIdProvider);
      expect(userId, isA<String?>());
    });
  });

  group('getProfileProvider', () {
    test('provides GetProfile usecase with injected repository', () {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final usecase = container.read(getProfileProvider);

      expect(usecase, isNotNull);
      // Usecase is callable.
      expect(usecase.call, isA<Function>());
    });

    test('usecase can call the profile repo', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final usecase = container.read(getProfileProvider);
      final result = await usecase(ProfileMockData.selfUserId);

      expect(result.user.name, 'Sun* Tester');
    });
  });

  group('Integration: profileProvider + manual userId', () {
    test('profileProvider loads self profile when passed self userId', () async {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final profileAsync = await container
          .read(profileProvider(ProfileMockData.selfUserId).future);

      expect(profileAsync.user.name, 'Sun* Tester');
    });

    test('profileProvider loads other profile when passed other userId',
        () async {
      final container = _container(
        profileRepo: FakeProfileRepository.data(),
      );
      addTearDown(container.dispose);

      final profileAsync = await container
          .read(profileProvider(ProfileMockData.otherUserId).future);

      expect(profileAsync.user.name, 'Phạm Quốc Bảo');
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:saa_2025/features/profile/domain/repositories/profile_repository.dart';
import 'package:saa_2025/features/profile/domain/usecases/get_profile.dart';
import 'package:saa_2025/features/profile/data/sources/profile_mock_data.dart';

/// Mock [ProfileRepository] for unit tests.
class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  group('GetProfile usecase', () {
    late MockProfileRepository mockRepo;
    late GetProfile getProfile;

    setUp(() {
      mockRepo = MockProfileRepository();
      getProfile = GetProfile(mockRepo);
    });

    test('calls repository.getProfile with the provided userId', () async {
      final testData = ProfileMockData.forUser(ProfileMockData.selfUserId);
      when(() => mockRepo.getProfile(any()))
          .thenAnswer((_) async => testData);

      await getProfile(ProfileMockData.selfUserId);

      verify(() => mockRepo.getProfile(ProfileMockData.selfUserId)).called(1);
    });

    test('returns ProfileData on success', () async {
      final testData = ProfileMockData.forUser(ProfileMockData.selfUserId);
      when(() => mockRepo.getProfile(any()))
          .thenAnswer((_) async => testData);

      final result = await getProfile(ProfileMockData.selfUserId);

      expect(result, equals(testData));
      expect(result.user.name, 'Sun* Tester');
      expect(result.user.id, ProfileMockData.selfUserId);
    });

    test('throws Failure when repository throws', () async {
      when(() => mockRepo.getProfile(any()))
          .thenThrow(Exception('Network error'));

      expect(
        () => getProfile('unknown-id'),
        throwsException,
      );
    });

    test('distinguishes self vs other user profiles', () async {
      final selfData = ProfileMockData.forUser(ProfileMockData.selfUserId);
      final otherData = ProfileMockData.forUser(ProfileMockData.otherUserId);

      when(() => mockRepo.getProfile(ProfileMockData.selfUserId))
          .thenAnswer((_) async => selfData);
      when(() => mockRepo.getProfile(ProfileMockData.otherUserId))
          .thenAnswer((_) async => otherData);

      final self = await getProfile(ProfileMockData.selfUserId);
      final other = await getProfile(ProfileMockData.otherUserId);

      expect(self.user.name, 'Sun* Tester');
      expect(other.user.name, 'Phạm Quốc Bảo');
      expect(self != other, isTrue);
    });
  });
}

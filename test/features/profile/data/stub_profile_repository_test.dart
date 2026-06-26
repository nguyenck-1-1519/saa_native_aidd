import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/profile/data/repositories/stub_profile_repository.dart';
import 'package:saa_2025/features/profile/data/sources/profile_mock_data.dart';

void main() {
  group('StubProfileRepository', () {
    late StubProfileRepository repo;

    setUp(() {
      repo = StubProfileRepository();
    });

    test('returns self profile data for self userId', () async {
      final result = await repo.getProfile(ProfileMockData.selfUserId);

      expect(result, isNotNull);
      expect(result.user.id, equals(ProfileMockData.selfUserId));
      expect(result.user.name, 'Sun* Tester');
      expect(result.stats.received, 24);
    });

    test('returns other profile data for other userId', () async {
      final result = await repo.getProfile(ProfileMockData.otherUserId);

      expect(result, isNotNull);
      expect(result.user.id, equals(ProfileMockData.otherUserId));
      expect(result.user.name, 'Phạm Quốc Bảo');
      expect(result.stats.received, 47);
    });

    test('returns sensible default for unknown userId (no crash)', () async {
      final result = await repo.getProfile('unknown-random-id');

      expect(result, isNotNull);
      expect(result.user.name, 'Phạm Quốc Bảo'); // Falls back to _other
    });

    test('returns complete ProfileData structure with composed data', () async {
      final result = await repo.getProfile(ProfileMockData.selfUserId);

      // ProfileData shape
      expect(result.user, isNotNull);
      expect(result.stats, isNotNull);
      expect(result.awards, isList);
      expect(result.recentKudos, isList);

      // User fields
      expect(result.user.id, isNotEmpty);
      expect(result.user.name, isNotEmpty);
      expect(result.user.role, isNotEmpty);
      expect(result.user.department, isNotEmpty);

      // Stats fields
      expect(result.stats.received, greaterThanOrEqualTo(0));
      expect(result.stats.sent, greaterThanOrEqualTo(0));
      expect(result.stats.heartsReceived, greaterThanOrEqualTo(0));
      expect(result.stats.secretBoxOpened, greaterThanOrEqualTo(0));
      expect(result.stats.secretBoxUnopened, greaterThanOrEqualTo(0));

      // Awards and kudos are lists (may be empty)
      expect(result.awards, isList);
      expect(result.recentKudos, isList);
    });

    test('self and other profiles are different', () async {
      final self = await repo.getProfile(ProfileMockData.selfUserId);
      final other = await repo.getProfile(ProfileMockData.otherUserId);

      expect(self == other, isFalse);
      expect(self.user.name, isNot(other.user.name));
      expect(self.stats.received, isNot(other.stats.received));
    });

    test('honors StubEnumBehavior enum pattern (default is .data)', () async {
      // StubProfileRepository uses StubEnumBehavior for control.
      // Default behavior is .data (returns mock data).
      // The stub has 800ms delay, but it still returns data.
      final result = await repo.getProfile(ProfileMockData.selfUserId);
      expect(result, isNotNull);
      expect(result.user.name, isNotEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/core/router/app_router.dart';

void main() {
  group('ProfileScreen — routing', () {
    test('Routes.profile constant is the self-profile literal path', () {
      expect(Routes.profile, '/profile');
    });

    test('Routes.profileUserPath(userId) generates parameterized path', () {
      expect(
        Routes.profileUserPath('user-123'),
        '/profile/user-123',
      );
    });

    test('Routes.profileUserPath handles special characters', () {
      expect(
        Routes.profileUserPath('uuid-abc-def-123'),
        '/profile/uuid-abc-def-123',
      );
    });

    test('route shadow guard: literal /profile != /profile/:userId', () {
      // This test documents the critical route-shadow prevention.
      // GoRouter matches in declaration order: literal routes before parameterized.
      // The app router declares:
      //   1. ShellRoute with /profile inside (literal, self-profile)
      //   2. GoRoute for /profile/:userId outside (parameterized, other-profile)
      //
      // So /profile goes to literal SelfProfileRouteWrapper.
      // And /profile/abc goes to parameterized OtherProfileRouteWrapper.
      // NO shadowing occurs.

      final selfPath = Routes.profile;
      final otherPath = Routes.profileUserPath('other-user');

      expect(selfPath, '/profile');
      expect(otherPath, '/profile/other-user');
      expect(selfPath != otherPath, true);

      // Verify selfPath is a perfect substring match but otherPath is longer
      final selfIsPrefixOfOther = otherPath.startsWith('$selfPath/');
      expect(selfIsPrefixOfOther, true,
          reason: 'Parameterized route extends literal');
    });
  });

  group('ProfileScreen — navigation assertions', () {
    test('profile and other-profile are distinct routes', () {
      final routes = [
        Routes.profile,
        Routes.profileUserPath('uid-1'),
        Routes.profileUserPath('uid-2'),
      ];

      // All routes should be unique.
      expect(routes.toSet().length, equals(routes.length));
    });

    test('Routes.profileUserPath consistent with _profileUserBase', () {
      // Verify the path pattern is consistent.
      final path = Routes.profileUserPath('test-id');
      expect(path.startsWith('/profile/'), isTrue);
      expect(path.split('/').length, equals(3)); // '', 'profile', 'test-id'
    });
  });
}

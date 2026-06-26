import 'package:flutter_test/flutter_test.dart';

import 'package:saa_2025/features/kudos/data/sources/kudos_detail_mock_data.dart';
import 'package:saa_2025/features/kudos/domain/value_objects/hero_tag.dart';

void main() {
  // -------------------------------------------------------------------------
  // KudosDetailMockData — detail records validation
  // -------------------------------------------------------------------------

  group('KudosDetailMockData — details', () {
    test('has exactly 5 detail records matching KudosMockData feed ids',
        () {
      expect(KudosDetailMockData.details, hasLength(5));
      expect(KudosDetailMockData.details[0].id, equals('kudo-001'));
      expect(KudosDetailMockData.details[1].id, equals('kudo-002'));
      expect(KudosDetailMockData.details[2].id, equals('kudo-003'));
      expect(KudosDetailMockData.details[3].id, equals('kudo-004'));
      expect(KudosDetailMockData.details[4].id, equals('kudo-005'));
    });

    test('all details have non-empty sender/recipient names and roles', () {
      for (final detail in KudosDetailMockData.details) {
        expect(detail.senderName, isNotEmpty);
        expect(detail.senderRole, isNotEmpty);
        expect(detail.recipientName, isNotEmpty);
        expect(detail.recipientRole, isNotEmpty);
      }
    });

    test('all details have valid HeroTag enum values', () {
      final validTags = HeroTag.values.map((t) => t.displayName).toSet();
      for (final detail in KudosDetailMockData.details) {
        expect(validTags.contains(detail.heroTag.displayName), isTrue);
      }
    });

    test('all details have non-empty title, message, hashtags', () {
      for (final detail in KudosDetailMockData.details) {
        expect(detail.title, isNotEmpty);
        expect(detail.message, isNotEmpty);
        expect(detail.hashtags, isNotEmpty);
        expect(detail.hashtags, isNotEmpty);
      }
    });

    test('all details have non-negative heartCount', () {
      for (final detail in KudosDetailMockData.details) {
        expect(detail.heartCount, greaterThanOrEqualTo(0));
      }
    });

    test('isAnonymous=true for kudo-003, false for others', () {
      expect(KudosDetailMockData.details[0].isAnonymous, isFalse);
      expect(KudosDetailMockData.details[1].isAnonymous, isFalse);
      expect(KudosDetailMockData.details[2].isAnonymous, isTrue);
      expect(KudosDetailMockData.details[3].isAnonymous, isFalse);
      expect(KudosDetailMockData.details[4].isAnonymous, isFalse);
    });

    test('linkUrl is present for all details', () {
      for (final detail in KudosDetailMockData.details) {
        expect(detail.linkUrl, isNotNull);
        expect(detail.linkUrl, isNotEmpty);
      }
    });

    test('all createdAt dates are valid and in 2025', () {
      for (final detail in KudosDetailMockData.details) {
        expect(detail.createdAt.year, equals(2025));
        expect(detail.createdAt.isBefore(DateTime.now()), isTrue);
      }
    });
  });

  // -------------------------------------------------------------------------
  // KudosDetailMockData — recipient search list
  // -------------------------------------------------------------------------

  group('KudosDetailMockData — sunners', () {
    test('has exactly 12 recipients', () {
      expect(KudosDetailMockData.sunners, hasLength(12));
    });

    test('all recipients have non-empty name and role', () {
      for (final recipient in KudosDetailMockData.sunners) {
        expect(recipient.name, isNotEmpty);
        expect(recipient.role, isNotEmpty);
      }
    });

    test('current user (Nguyễn Minh Tuấn) is defined as constant', () {
      // Current user is stored as a constant for exclusion from search results.
      expect(KudosDetailMockData.currentUserName, equals('Nguyễn Minh Tuấn'));
      // Verify it's not in sunners (excluded by design).
      final found = KudosDetailMockData.sunners
          .where((r) => r.name == KudosDetailMockData.currentUserName)
          .firstOrNull;
      expect(found, isNull);
    });

    test('recipient names are unique', () {
      final names =
          KudosDetailMockData.sunners.map((r) => r.name).toList();
      expect(names.toSet().length, equals(names.length));
    });
  });

  // -------------------------------------------------------------------------
  // KudosDetailMockData — filter options derived from details
  // -------------------------------------------------------------------------

  group('KudosDetailMockData — hashtags', () {
    test('returns non-empty distinct hashtag list', () {
      final hashtags = KudosDetailMockData.hashtags;
      expect(hashtags, isNotEmpty);
      // All hashtags should be unique.
      expect(hashtags.toSet().length, equals(hashtags.length));
    });

    test('contains expected hashtags from details', () {
      final hashtags = KudosDetailMockData.hashtags;
      expect(hashtags, contains('#Design'));
      expect(hashtags, contains('#Teamwork'));
    });

    test('hashtags are sorted', () {
      final hashtags = KudosDetailMockData.hashtags;
      final sorted = List<String>.from(hashtags)..sort();
      expect(hashtags, equals(sorted));
    });
  });

  group('KudosDetailMockData — departments', () {
    test('returns non-empty distinct department list', () {
      final depts = KudosDetailMockData.departments;
      expect(depts, isNotEmpty);
      // All departments should be unique.
      expect(depts.toSet().length, equals(depts.length));
    });

    test('contains expected roles from details', () {
      final depts = KudosDetailMockData.departments;
      expect(depts, contains('Frontend Engineer'));
      expect(depts, contains('Tech Lead'));
      expect(depts, contains('Product Designer'));
    });

    test('departments are sorted', () {
      final depts = KudosDetailMockData.departments;
      final sorted = List<String>.from(depts)..sort();
      expect(depts, equals(sorted));
    });
  });
}

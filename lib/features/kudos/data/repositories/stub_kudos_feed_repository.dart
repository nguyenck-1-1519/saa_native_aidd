import '../../../../core/error/failures.dart';
import '../../domain/entities/kudo.dart';
import '../../domain/entities/kudo_detail.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/repositories/kudos_feed_repository.dart';
import '../sources/kudos_detail_mock_data.dart';
import '../sources/kudos_mock_data.dart';

/// Behavior modes for [StubKudosFeedRepository].
enum StubKudosFeedBehavior { data, empty, error }

/// Stub implementation of [KudosFeedRepository] for development and manual QA.
///
/// Adds an artificial delay to exercise loading state in the UI.
///   - [StubKudosFeedBehavior.data]  → returns design-sourced kudos
///   - [StubKudosFeedBehavior.empty] → returns empty lists
///   - [StubKudosFeedBehavior.error] → throws [UnknownFailure]
class StubKudosFeedRepository implements KudosFeedRepository {
  StubKudosFeedRepository({
    this.behavior = StubKudosFeedBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  });

  final StubKudosFeedBehavior behavior;
  final Duration delay;

  @override
  Future<List<Kudo>> getKudos() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosFeedBehavior.data => KudosMockData.feed,
      StubKudosFeedBehavior.empty => const [],
      StubKudosFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated kudos feed fetch error'),
    };
  }

  @override
  Future<List<Kudo>> getHighlightKudos() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosFeedBehavior.data => KudosMockData.highlights,
      StubKudosFeedBehavior.empty => const [],
      StubKudosFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated kudos highlights fetch error'),
    };
  }

  @override
  Future<List<KudoRecipient>> getRecentRecipients() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosFeedBehavior.data => KudosMockData.recentRecipients,
      StubKudosFeedBehavior.empty => const [],
      StubKudosFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated recent recipients fetch error'),
    };
  }

  @override
  Future<KudoDetail> getKudoById(String id) async {
    await Future<void>.delayed(delay);
    if (behavior == StubKudosFeedBehavior.error) {
      throw const UnknownFailure('Stub: simulated kudo detail fetch error');
    }
    final detail = KudosDetailMockData.details
        .where((d) => d.id == id)
        .firstOrNull;
    if (detail == null) {
      throw UnknownFailure('Stub: kudo not found for id=$id');
    }
    return detail;
  }

  @override
  Future<List<Kudo>> getAllKudos({String? hashtag, String? department}) async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated getAllKudos error'),
      StubKudosFeedBehavior.empty => const [],
      StubKudosFeedBehavior.data => _filterFeed(
          KudosMockData.feed,
          hashtag: hashtag,
          department: department,
        ),
    };
  }

  @override
  Future<List<String>> getHashtags() async {
    await Future<void>.delayed(delay);
    if (behavior == StubKudosFeedBehavior.error) {
      throw const UnknownFailure('Stub: simulated getHashtags error');
    }
    return KudosDetailMockData.hashtags;
  }

  @override
  Future<List<String>> getDepartments() async {
    await Future<void>.delayed(delay);
    if (behavior == StubKudosFeedBehavior.error) {
      throw const UnknownFailure('Stub: simulated getDepartments error');
    }
    return KudosDetailMockData.departments;
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  List<Kudo> _filterFeed(
    List<Kudo> all, {
    String? hashtag,
    String? department,
  }) {
    var result = all;
    if (hashtag != null && hashtag.isNotEmpty) {
      result = result
          .where((k) => k.hashtags.contains(hashtag))
          .toList();
    }
    if (department != null && department.isNotEmpty) {
      final dep = department.toLowerCase();
      result = result
          .where((k) =>
              k.senderRole.toLowerCase().contains(dep) ||
              k.recipientRole.toLowerCase().contains(dep))
          .toList();
    }
    return result;
  }
}

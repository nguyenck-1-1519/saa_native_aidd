import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/kudo.dart';
import '../../domain/entities/kudo_detail.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/repositories/kudos_feed_repository.dart';
import '../sources/kudos_detail_mock_data.dart';
import '../sources/kudos_mock_data.dart';

/// Deterministic, delay-free [KudosFeedRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.data()`    → returns design-sourced kudos immediately
///   - `.empty()`   → returns empty lists immediately
///   - `.error()`   → throws [UnknownFailure] immediately
///   - `.loading()` → never resolves — pins the controller in loading state
class FakeKudosFeedRepository implements KudosFeedRepository {
  FakeKudosFeedRepository._({
    required Future<List<Kudo>> Function() feedHandler,
    required Future<List<Kudo>> Function() highlightsHandler,
    required Future<List<KudoRecipient>> Function() recipientsHandler,
    required Future<KudoDetail> Function(String) detailHandler,
    required Future<List<Kudo>> Function({
      String? hashtag,
      String? department,
    }) allKudosHandler,
    required Future<List<String>> Function() hashtagsHandler,
    required Future<List<String>> Function() departmentsHandler,
  })  : _feedHandler = feedHandler,
        _highlightsHandler = highlightsHandler,
        _recipientsHandler = recipientsHandler,
        _detailHandler = detailHandler,
        _allKudosHandler = allKudosHandler,
        _hashtagsHandler = hashtagsHandler,
        _departmentsHandler = departmentsHandler;

  factory FakeKudosFeedRepository.data() => FakeKudosFeedRepository._(
        feedHandler: () async => KudosMockData.feed,
        highlightsHandler: () async => KudosMockData.highlights,
        recipientsHandler: () async => KudosMockData.recentRecipients,
        detailHandler: (id) async {
          final detail = KudosDetailMockData.details
              .where((d) => d.id == id)
              .firstOrNull;
          if (detail == null) {
            throw UnknownFailure('Fake: kudo not found for id=$id');
          }
          return detail;
        },
        allKudosHandler: ({String? hashtag, String? department}) async =>
            _applyFilters(
              KudosMockData.feed,
              hashtag: hashtag,
              department: department,
            ),
        hashtagsHandler: () async => KudosDetailMockData.hashtags,
        departmentsHandler: () async => KudosDetailMockData.departments,
      );

  factory FakeKudosFeedRepository.empty() => FakeKudosFeedRepository._(
        feedHandler: () async => const [],
        highlightsHandler: () async => const [],
        recipientsHandler: () async => const [],
        detailHandler: (id) async =>
            throw UnknownFailure('Fake: kudo not found for id=$id'),
        allKudosHandler: ({String? hashtag, String? department}) async =>
            const [],
        hashtagsHandler: () async => const [],
        departmentsHandler: () async => const [],
      );

  factory FakeKudosFeedRepository.error() => FakeKudosFeedRepository._(
        feedHandler: () async =>
            throw const UnknownFailure('Fake: simulated kudos feed error'),
        highlightsHandler: () async =>
            throw const UnknownFailure('Fake: simulated highlights error'),
        recipientsHandler: () async =>
            throw const UnknownFailure('Fake: simulated recipients error'),
        detailHandler: (_) async =>
            throw const UnknownFailure('Fake: simulated detail error'),
        allKudosHandler: ({String? hashtag, String? department}) async =>
            throw const UnknownFailure('Fake: simulated getAllKudos error'),
        hashtagsHandler: () async =>
            throw const UnknownFailure('Fake: simulated hashtags error'),
        departmentsHandler: () async =>
            throw const UnknownFailure('Fake: simulated departments error'),
      );

  /// Returns futures that never complete — useful for testing loading skeletons.
  factory FakeKudosFeedRepository.loading() => FakeKudosFeedRepository._(
        feedHandler: () => Completer<List<Kudo>>().future,
        highlightsHandler: () => Completer<List<Kudo>>().future,
        recipientsHandler: () => Completer<List<KudoRecipient>>().future,
        detailHandler: (_) => Completer<KudoDetail>().future,
        allKudosHandler: ({String? hashtag, String? department}) =>
            Completer<List<Kudo>>().future,
        hashtagsHandler: () => Completer<List<String>>().future,
        departmentsHandler: () => Completer<List<String>>().future,
      );

  final Future<List<Kudo>> Function() _feedHandler;
  final Future<List<Kudo>> Function() _highlightsHandler;
  final Future<List<KudoRecipient>> Function() _recipientsHandler;
  final Future<KudoDetail> Function(String) _detailHandler;
  final Future<List<Kudo>> Function({
    String? hashtag,
    String? department,
  }) _allKudosHandler;
  final Future<List<String>> Function() _hashtagsHandler;
  final Future<List<String>> Function() _departmentsHandler;

  @override
  Future<List<Kudo>> getKudos() => _feedHandler();

  @override
  Future<List<Kudo>> getHighlightKudos() => _highlightsHandler();

  @override
  Future<List<KudoRecipient>> getRecentRecipients() => _recipientsHandler();

  @override
  Future<KudoDetail> getKudoById(String id) => _detailHandler(id);

  @override
  Future<List<Kudo>> getAllKudos({String? hashtag, String? department}) =>
      _allKudosHandler(hashtag: hashtag, department: department);

  @override
  Future<List<String>> getHashtags() => _hashtagsHandler();

  @override
  Future<List<String>> getDepartments() => _departmentsHandler();

  // ---------------------------------------------------------------------------
  // Internal helpers (static — no instance state)
  // ---------------------------------------------------------------------------

  static List<Kudo> _applyFilters(
    List<Kudo> all, {
    String? hashtag,
    String? department,
  }) {
    var result = all;
    if (hashtag != null && hashtag.isNotEmpty) {
      result = result.where((k) => k.hashtags.contains(hashtag)).toList();
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

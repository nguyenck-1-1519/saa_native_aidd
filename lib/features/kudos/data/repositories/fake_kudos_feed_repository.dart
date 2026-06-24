import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/kudo.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/repositories/kudos_feed_repository.dart';
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
  })  : _feedHandler = feedHandler,
        _highlightsHandler = highlightsHandler,
        _recipientsHandler = recipientsHandler;

  factory FakeKudosFeedRepository.data() => FakeKudosFeedRepository._(
        feedHandler: () async => KudosMockData.feed,
        highlightsHandler: () async => KudosMockData.highlights,
        recipientsHandler: () async => KudosMockData.recentRecipients,
      );

  factory FakeKudosFeedRepository.empty() => FakeKudosFeedRepository._(
        feedHandler: () async => const [],
        highlightsHandler: () async => const [],
        recipientsHandler: () async => const [],
      );

  factory FakeKudosFeedRepository.error() => FakeKudosFeedRepository._(
        feedHandler: () async =>
            throw const UnknownFailure('Fake: simulated kudos feed error'),
        highlightsHandler: () async =>
            throw const UnknownFailure('Fake: simulated highlights error'),
        recipientsHandler: () async =>
            throw const UnknownFailure('Fake: simulated recipients error'),
      );

  /// Returns futures that never complete — useful for testing loading skeletons.
  factory FakeKudosFeedRepository.loading() => FakeKudosFeedRepository._(
        feedHandler: () => Completer<List<Kudo>>().future,
        highlightsHandler: () => Completer<List<Kudo>>().future,
        recipientsHandler: () => Completer<List<KudoRecipient>>().future,
      );

  final Future<List<Kudo>> Function() _feedHandler;
  final Future<List<Kudo>> Function() _highlightsHandler;
  final Future<List<KudoRecipient>> Function() _recipientsHandler;

  @override
  Future<List<Kudo>> getKudos() => _feedHandler();

  @override
  Future<List<Kudo>> getHighlightKudos() => _highlightsHandler();

  @override
  Future<List<KudoRecipient>> getRecentRecipients() => _recipientsHandler();
}

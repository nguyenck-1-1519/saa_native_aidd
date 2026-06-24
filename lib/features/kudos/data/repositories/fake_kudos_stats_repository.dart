import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/kudos_stats.dart';
import '../../domain/repositories/kudos_stats_repository.dart';
import '../sources/kudos_mock_data.dart';

/// Deterministic, delay-free [KudosStatsRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.data()`    → returns design-sourced stats immediately
///   - `.error()`   → throws [UnknownFailure] immediately
///   - `.loading()` → never resolves — pins the provider in loading state
class FakeKudosStatsRepository implements KudosStatsRepository {
  FakeKudosStatsRepository._({
    required Future<KudosStats> Function() handler,
  }) : _handler = handler;

  factory FakeKudosStatsRepository.data() => FakeKudosStatsRepository._(
        handler: () async => KudosMockData.stats,
      );

  factory FakeKudosStatsRepository.error() => FakeKudosStatsRepository._(
        handler: () async =>
            throw const UnknownFailure('Fake: simulated kudos stats error'),
      );

  /// Returns a future that never completes — useful for testing loading state.
  factory FakeKudosStatsRepository.loading() => FakeKudosStatsRepository._(
        handler: () => Completer<KudosStats>().future,
      );

  final Future<KudosStats> Function() _handler;

  @override
  Future<KudosStats> getStats() => _handler();
}

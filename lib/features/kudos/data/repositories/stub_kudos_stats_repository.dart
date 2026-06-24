import '../../../../core/error/failures.dart';
import '../../domain/entities/kudos_stats.dart';
import '../../domain/repositories/kudos_stats_repository.dart';
import '../sources/kudos_mock_data.dart';

/// Behavior modes for [StubKudosStatsRepository].
enum StubKudosStatsBehavior { data, error }

/// Stub implementation of [KudosStatsRepository] for development and manual QA.
///
/// Adds an artificial delay to exercise loading state in the UI.
///   - [StubKudosStatsBehavior.data]  → returns design-sourced stats
///   - [StubKudosStatsBehavior.error] → throws [UnknownFailure]
class StubKudosStatsRepository implements KudosStatsRepository {
  StubKudosStatsRepository({
    this.behavior = StubKudosStatsBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  });

  final StubKudosStatsBehavior behavior;
  final Duration delay;

  @override
  Future<KudosStats> getStats() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosStatsBehavior.data => KudosMockData.stats,
      StubKudosStatsBehavior.error =>
        throw const UnknownFailure('Stub: simulated kudos stats fetch error'),
    };
  }
}

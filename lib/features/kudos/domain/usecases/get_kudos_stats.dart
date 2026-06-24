import '../entities/kudos_stats.dart';
import '../repositories/kudos_stats_repository.dart';

/// Returns the current user's kudos stats aggregate.
class GetKudosStats {
  const GetKudosStats(this._repo);

  final KudosStatsRepository _repo;

  Future<KudosStats> call() => _repo.getStats();
}

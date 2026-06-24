import '../entities/kudos_stats.dart';

/// Contract for fetching aggregate kudos statistics.
///
/// Implementations live in `data/repositories/`. Throws a [Failure] subtype
/// on any error so the presentation layer can use `AsyncValue.guard`.
abstract interface class KudosStatsRepository {
  /// Returns the current user's kudos stats aggregate. Throws [Failure] on error.
  Future<KudosStats> getStats();
}

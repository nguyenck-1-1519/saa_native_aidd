import '../entities/kudo.dart';
import '../repositories/kudos_feed_repository.dart';

/// Returns all kudos for the main feed.
///
/// Delegates to [KudosFeedRepository]; the data source decides whether
/// to return stubs or throw a [Failure].
class GetKudosFeed {
  const GetKudosFeed(this._repo);

  final KudosFeedRepository _repo;

  Future<List<Kudo>> call() => _repo.getKudos();
}

import '../entities/kudo.dart';
import '../repositories/kudos_feed_repository.dart';

/// Returns the highlighted kudos subset shown in the carousel / spotlight.
class GetHighlightKudos {
  const GetHighlightKudos(this._repo);

  final KudosFeedRepository _repo;

  Future<List<Kudo>> call() => _repo.getHighlightKudos();
}

import '../entities/kudo_detail.dart';
import '../repositories/kudos_feed_repository.dart';

/// Returns the full [KudoDetail] for a single kudo by its [id].
///
/// Delegates to [KudosFeedRepository.getKudoById]; throws [Failure] on miss.
class GetKudoById {
  const GetKudoById(this._repo);

  final KudosFeedRepository _repo;

  Future<KudoDetail> call(String id) => _repo.getKudoById(id);
}

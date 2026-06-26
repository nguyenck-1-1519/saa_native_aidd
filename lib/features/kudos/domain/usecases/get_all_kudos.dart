import '../entities/kudo.dart';
import '../repositories/kudos_feed_repository.dart';

/// Returns all kudos, optionally filtered by [hashtag] and/or [department].
///
/// Filtering is applied in-memory by the repository implementation.
/// Throws [Failure] on error.
class GetAllKudos {
  const GetAllKudos(this._repo);

  final KudosFeedRepository _repo;

  Future<List<Kudo>> call({String? hashtag, String? department}) =>
      _repo.getAllKudos(hashtag: hashtag, department: department);
}

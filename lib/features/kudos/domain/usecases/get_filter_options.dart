import '../repositories/kudos_feed_repository.dart';

/// Returns the available filter options (hashtags and departments) for the
/// All Kudos screen filter dropdowns.
///
/// Both lists are derived from the current mock data set.
/// Throws [Failure] on error.
class GetFilterOptions {
  const GetFilterOptions(this._repo);

  final KudosFeedRepository _repo;

  Future<List<String>> hashtags() => _repo.getHashtags();

  Future<List<String>> departments() => _repo.getDepartments();
}

import '../entities/award_detail.dart';
import '../repositories/awards_detail_repository.dart';

/// Fetches the full list of SAA 2025 award details.
///
/// Delegates to [AwardsDetailRepository]; the data source decides whether
/// to hit a network, return stubs, or throw a [Failure].
class GetAwardDetails {
  const GetAwardDetails(this._repo);

  final AwardsDetailRepository _repo;

  Future<List<AwardDetail>> call() => _repo.getAwardDetails();
}

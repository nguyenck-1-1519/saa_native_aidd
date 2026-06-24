import '../entities/award_card.dart';
import '../repositories/awards_repository.dart';

/// Fetches the list of award cards for the Home carousel.
///
/// Delegates to [AwardsRepository]. Throws a [Failure] subtype on error,
/// which surfaces as `AsyncValue.hasError` in the controller.
class GetAwards {
  const GetAwards(this._repository);

  final AwardsRepository _repository;

  Future<List<AwardCard>> call() => _repository.getAwards();
}

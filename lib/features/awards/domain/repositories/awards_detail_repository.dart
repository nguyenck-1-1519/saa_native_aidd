import '../entities/award_detail.dart';

/// Contract for fetching award detail data shown on the Awards screen.
///
/// Implementations live in `data/repositories/`. Throws a [Failure] subtype
/// on any error so the presentation layer can use `AsyncValue.guard`.
abstract interface class AwardsDetailRepository {
  /// Returns the list of all award details. Throws [Failure] on error.
  Future<List<AwardDetail>> getAwardDetails();
}

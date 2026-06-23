import '../entities/award_card.dart';

/// Contract for fetching award categories shown in the Home carousel.
///
/// Implementations live in `data/repositories/`. Throws a [Failure] subtype
/// on any error so the presentation layer can use `AsyncValue.guard`.
abstract interface class AwardsRepository {
  /// Returns the list of award cards. Throws [Failure] on error.
  Future<List<AwardCard>> getAwards();
}

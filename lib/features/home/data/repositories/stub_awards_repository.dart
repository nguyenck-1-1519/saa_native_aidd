import '../../../../core/error/failures.dart';
import '../../domain/entities/award_card.dart';
import '../../domain/repositories/awards_repository.dart';
import '../sources/home_mock_data.dart';

/// Behavior modes for [StubAwardsRepository].
enum StubAwardsBehavior { data, empty, error }

/// Stub implementation of [AwardsRepository] for development and manual QA.
///
/// Adds an artificial delay to exercise loading state in the UI.
/// Inject different [behavior] values to verify each UI state:
///   - [StubAwardsBehavior.data]  → returns design-sourced sample awards
///   - [StubAwardsBehavior.empty] → returns an empty list (empty state)
///   - [StubAwardsBehavior.error] → throws [UnknownFailure] (error + Retry)
class StubAwardsRepository implements AwardsRepository {
  StubAwardsRepository({
    this.behavior = StubAwardsBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  });

  final StubAwardsBehavior behavior;
  final Duration delay;

  @override
  Future<List<AwardCard>> getAwards() async {
    await Future<void>.delayed(delay);

    return switch (behavior) {
      StubAwardsBehavior.data => HomeMockData.awards,
      StubAwardsBehavior.empty => const [],
      StubAwardsBehavior.error =>
        throw const UnknownFailure('Stub: simulated awards fetch error'),
    };
  }
}

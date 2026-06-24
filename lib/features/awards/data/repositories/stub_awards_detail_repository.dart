import '../../../../core/error/failures.dart';
import '../../domain/entities/award_detail.dart';
import '../../domain/repositories/awards_detail_repository.dart';
import '../sources/awards_detail_mock_data.dart';

/// Behavior modes for [StubAwardsDetailRepository].
enum StubAwardsDetailBehavior { data, empty, error }

/// Stub implementation of [AwardsDetailRepository] for development and manual QA.
///
/// Adds an artificial 800 ms delay to exercise loading state in the UI.
/// Inject different [behavior] values to verify each UI state:
///   - [StubAwardsDetailBehavior.data]  → returns design-sourced 5 awards
///   - [StubAwardsDetailBehavior.empty] → returns an empty list (empty state)
///   - [StubAwardsDetailBehavior.error] → throws [UnknownFailure] (error + Retry)
class StubAwardsDetailRepository implements AwardsDetailRepository {
  StubAwardsDetailRepository({
    this.behavior = StubAwardsDetailBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  });

  final StubAwardsDetailBehavior behavior;
  final Duration delay;

  @override
  Future<List<AwardDetail>> getAwardDetails() async {
    await Future<void>.delayed(delay);

    return switch (behavior) {
      StubAwardsDetailBehavior.data => AwardsDetailMockData.awards,
      StubAwardsDetailBehavior.empty => const [],
      StubAwardsDetailBehavior.error =>
        throw const UnknownFailure('Stub: simulated awards detail fetch error'),
    };
  }
}

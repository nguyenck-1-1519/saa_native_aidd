import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/award_detail.dart';
import '../../domain/repositories/awards_detail_repository.dart';
import '../sources/awards_detail_mock_data.dart';

/// Deterministic, delay-free [AwardsDetailRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.data()`    → returns design-sourced 5 awards immediately
///   - `.empty()`   → returns an empty list immediately
///   - `.error()`   → throws [UnknownFailure] immediately
///   - `.loading()` → never resolves — pins the controller in loading state
class FakeAwardsDetailRepository implements AwardsDetailRepository {
  FakeAwardsDetailRepository._({
    required Future<List<AwardDetail>> Function() handler,
  }) : _handler = handler;

  factory FakeAwardsDetailRepository.data() => FakeAwardsDetailRepository._(
        handler: () async => AwardsDetailMockData.awards,
      );

  factory FakeAwardsDetailRepository.empty() => FakeAwardsDetailRepository._(
        handler: () async => const [],
      );

  factory FakeAwardsDetailRepository.error() => FakeAwardsDetailRepository._(
        handler: () async =>
            throw const UnknownFailure('Fake: simulated awards detail error'),
      );

  /// Returns a future that never completes — useful for testing loading skeletons.
  factory FakeAwardsDetailRepository.loading() =>
      FakeAwardsDetailRepository._(
        handler: () => Completer<List<AwardDetail>>().future,
      );

  final Future<List<AwardDetail>> Function() _handler;

  @override
  Future<List<AwardDetail>> getAwardDetails() => _handler();
}

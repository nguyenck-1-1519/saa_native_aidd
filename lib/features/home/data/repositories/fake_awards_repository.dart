import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/award_card.dart';
import '../../domain/repositories/awards_repository.dart';
import '../sources/home_mock_data.dart';

/// Deterministic, delay-free [AwardsRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.data()`    → returns design-sourced sample awards immediately
///   - `.empty()`   → returns an empty list immediately
///   - `.error()`   → throws [UnknownFailure] immediately
///   - `.loading()` → never resolves — pins the controller in loading state
class FakeAwardsRepository implements AwardsRepository {
  FakeAwardsRepository._({
    required Future<List<AwardCard>> Function() handler,
  }) : _handler = handler;

  factory FakeAwardsRepository.data() => FakeAwardsRepository._(
        handler: () async => HomeMockData.awards,
      );

  factory FakeAwardsRepository.empty() => FakeAwardsRepository._(
        handler: () async => const [],
      );

  factory FakeAwardsRepository.error() => FakeAwardsRepository._(
        handler: () async =>
            throw const UnknownFailure('Fake: simulated awards error'),
      );

  /// Returns a future that never completes — useful for testing loading skeletons.
  factory FakeAwardsRepository.loading() => FakeAwardsRepository._(
        handler: () => Completer<List<AwardCard>>().future,
      );

  final Future<List<AwardCard>> Function() _handler;

  @override
  Future<List<AwardCard>> getAwards() => _handler();
}

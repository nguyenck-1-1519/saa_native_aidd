import '../../../../core/error/failures.dart';
import '../../domain/entities/profile_data.dart';
import '../../domain/repositories/profile_repository.dart';
import '../sources/profile_mock_data.dart';

/// Behavior modes for [StubProfileRepository].
enum StubProfileBehavior { data, error }

/// Stub implementation of [ProfileRepository] for development and manual QA.
///
/// Adds an artificial delay to exercise loading state in the UI.
///   - [StubProfileBehavior.data]  → returns design-sourced [ProfileData]
///   - [StubProfileBehavior.error] → throws [UnknownFailure]
///
/// Override with [FakeProfileRepository] in unit/widget tests for
/// deterministic, delay-free control (code-standards §8).
class StubProfileRepository implements ProfileRepository {
  StubProfileRepository({
    this.behavior = StubProfileBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  });

  final StubProfileBehavior behavior;
  final Duration delay;

  @override
  Future<ProfileData> getProfile(String userId) async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubProfileBehavior.data => ProfileMockData.forUser(userId),
      StubProfileBehavior.error =>
        throw const UnknownFailure('Stub: simulated profile fetch error'),
    };
  }
}

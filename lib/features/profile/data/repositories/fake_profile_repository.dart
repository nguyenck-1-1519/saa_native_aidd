import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../../kudos/domain/entities/kudos_stats.dart';
import '../../domain/entities/profile_data.dart';
import '../../domain/entities/profile_user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../sources/profile_mock_data.dart';

/// Deterministic, delay-free [ProfileRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.data()`    → returns design-sourced [ProfileData] immediately
///   - `.empty()`   → returns minimal empty-stats [ProfileData] immediately
///   - `.error()`   → throws [UnknownFailure] immediately
///   - `.loading()` → never resolves — pins the provider in loading state
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository._({
    required Future<ProfileData> Function(String) handler,
  }) : _handler = handler;

  factory FakeProfileRepository.data() => FakeProfileRepository._(
        handler: (userId) async => ProfileMockData.forUser(userId),
      );

  /// Returns a genuinely zeroed/empty [ProfileData] — no awards, no kudos,
  /// zeroed stats — so empty-state widget tests render the correct empty UI.
  factory FakeProfileRepository.empty() => FakeProfileRepository._(
        handler: (_) async => const ProfileData(
          user: ProfileUser(
            id: 'empty-user-id',
            name: '',
            role: '',
            department: '',
          ),
          stats: KudosStats(
            received: 0,
            sent: 0,
            heartsReceived: 0,
            secretBoxOpened: 0,
            secretBoxUnopened: 0,
          ),
          awards: [],
          recentKudos: [],
        ),
      );

  factory FakeProfileRepository.error() => FakeProfileRepository._(
        handler: (_) async =>
            throw const UnknownFailure('Fake: simulated profile fetch error'),
      );

  /// Returns a future that never completes — useful for loading-state tests.
  factory FakeProfileRepository.loading() => FakeProfileRepository._(
        handler: (_) => Completer<ProfileData>().future,
      );

  final Future<ProfileData> Function(String) _handler;

  @override
  Future<ProfileData> getProfile(String userId) => _handler(userId);
}

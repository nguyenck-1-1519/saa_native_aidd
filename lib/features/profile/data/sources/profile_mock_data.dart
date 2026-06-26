import '../../../awards/data/sources/awards_detail_mock_data.dart';
import '../../../kudos/data/sources/kudos_mock_data.dart';
import '../../../kudos/domain/entities/kudos_stats.dart';
import '../../domain/entities/profile_data.dart';
import '../../domain/entities/profile_user.dart';

/// Design-sourced mock data for the Profile feature.
///
/// Self profile id matches [selfUserId] — the id emitted by [FakeAuthRepository]
/// (id: 'fake-user-id'). The mock data layer uses this constant as the lookup
/// key so that when the app boots in demo/test mode the self-profile route
/// resolves to the correct stub data.
///
/// [otherUserId] is the fallback id for any OTHER user. Unknown ids also
/// resolve to [_other] — no crash on an unrecognised userId (B2 requirement).
///
/// Award and kudo instances are composed directly from [AwardsDetailMockData]
/// and [KudosMockData] — no data is duplicated.
abstract final class ProfileMockData {
  // ---------------------------------------------------------------------------
  // Known user ids
  // ---------------------------------------------------------------------------

  /// Matches the id used by [FakeAuthRepository._defaultUser] ('fake-user-id').
  /// The real Supabase user will have a UUID; the stub ignores this mismatch
  /// because the data layer is never active in production (local stub only).
  static const String selfUserId = 'fake-user-id';

  /// Id for the secondary mock user (e.g. a colleague whose profile is viewed
  /// after tapping a kudo card).
  static const String otherUserId = 'pham-quoc-bao-id';

  // ---------------------------------------------------------------------------
  // Static ProfileData instances
  // ---------------------------------------------------------------------------

  static final ProfileData _self = ProfileData(
    user: const ProfileUser(
      id: selfUserId,
      name: 'Sun* Tester',
      role: 'Frontend Engineer',
      department: 'Engineering',
      avatarUrl: null, // null → grey placeholder (F003/F004 convention)
      heroLevel: 'Rising Hero',
      badges: ['Top Talent'],
    ),
    stats: const KudosStats(
      received: 24,
      sent: 12,
      heartsReceived: 47,
      secretBoxOpened: 2,
      secretBoxUnopened: 1,
    ),
    // Compose a subset of the awards mock so numbers feel coherent with F003.
    awards: AwardsDetailMockData.awards.take(2).toList(),
    // Compose kudos where this user is the recipient (kudo-001 recipient = Trần Thị Lan,
    // but for the self stub we reuse the first two entries as representative shape).
    recentKudos: KudosMockData.feed.take(2).toList(),
  );

  static final ProfileData _other = ProfileData(
    user: const ProfileUser(
      id: otherUserId,
      name: 'Phạm Quốc Bảo',
      role: 'Tech Lead',
      department: 'Engineering',
      avatarUrl: null,
      heroLevel: 'Legend Hero',
      badges: ['MVP', 'Top Talent'],
    ),
    stats: const KudosStats(
      received: 47,
      sent: 31,
      heartsReceived: 112,
      secretBoxOpened: 3,
      secretBoxUnopened: 0,
    ),
    // Bảo won the top three awards per F003 mock coherence.
    awards: AwardsDetailMockData.awards.take(3).toList(),
    // kudo-002 has Bảo as the recipient — most representative.
    recentKudos: KudosMockData.feed.skip(1).take(2).toList(),
  );

  // ---------------------------------------------------------------------------
  // Public lookup
  // ---------------------------------------------------------------------------

  /// Returns [ProfileData] for [userId].
  ///
  /// - [selfUserId]  → self profile
  /// - [otherUserId] → other profile
  /// - anything else → [_other] (sensible default; never throws)
  static ProfileData forUser(String userId) {
    return switch (userId) {
      selfUserId => _self,
      _ => _other,
    };
  }
}

import '../../../awards/domain/entities/award_detail.dart';
import '../../../kudos/domain/entities/kudo.dart';
import '../../../kudos/domain/entities/kudos_stats.dart';
import 'profile_user.dart';

/// Aggregate for a user's full profile page.
///
/// Composes existing domain entities from the awards and kudos features —
/// no duplication. [ProfileUser] is the only net-new entity here.
///
/// [stats]       — kudos received/sent/hearts (reuses [KudosStats]).
/// [awards]      — award categories the user has won (reuses [AwardDetail]).
/// [recentKudos] — latest kudos received (reuses [Kudo]; all needed fields
///                 are present — no thin view-object needed per YAGNI).
class ProfileData {
  const ProfileData({
    required this.user,
    required this.stats,
    required this.awards,
    required this.recentKudos,
  });

  final ProfileUser user;
  final KudosStats stats;
  final List<AwardDetail> awards;
  final List<Kudo> recentKudos;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileData &&
          other.user == user &&
          other.stats == stats &&
          _listEquals(other.awards, awards) &&
          _listEquals(other.recentKudos, recentKudos);

  @override
  int get hashCode => Object.hash(
      user, stats, Object.hashAll(awards), Object.hashAll(recentKudos));

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

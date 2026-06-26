import '../entities/profile_data.dart';
import '../repositories/profile_repository.dart';

/// Returns the [ProfileData] aggregate for a given user id.
///
/// Works for self and other profiles — the caller passes the relevant userId.
/// Throws a [Failure] subtype on error (propagated from the repository).
class GetProfile {
  const GetProfile(this._repo);

  final ProfileRepository _repo;

  Future<ProfileData> call(String userId) => _repo.getProfile(userId);
}

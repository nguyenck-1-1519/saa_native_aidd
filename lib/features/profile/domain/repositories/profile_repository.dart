import '../entities/profile_data.dart';

/// Contract for fetching a user's profile aggregate.
///
/// Implementations live in `data/repositories/`. Throws a [Failure] subtype
/// on any error so the presentation layer can use `AsyncValue.guard`.
abstract interface class ProfileRepository {
  /// Returns the [ProfileData] for [userId].
  ///
  /// Works for both self and other profiles — the caller decides which id to
  /// pass. [isSelf] is a presentation concern; the repository is id-agnostic.
  ///
  /// Throws [Failure] on error.
  Future<ProfileData> getProfile(String userId);
}

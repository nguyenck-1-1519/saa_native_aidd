import '../entities/kudo.dart';
import '../entities/kudo_detail.dart';
import '../entities/kudo_recipient.dart';

/// Contract for fetching kudos feed data shown on the Kudos screen.
///
/// Implementations live in `data/repositories/`. Throws a [Failure] subtype
/// on any error so the presentation layer can use `AsyncValue.guard`.
abstract interface class KudosFeedRepository {
  /// Returns all kudos for the main feed. Throws [Failure] on error.
  Future<List<Kudo>> getKudos();

  /// Returns the highlighted kudos subset (carousel / spotlight).
  /// Throws [Failure] on error.
  Future<List<Kudo>> getHighlightKudos();

  /// Returns the most recent gift recipients list.
  /// Throws [Failure] on error.
  Future<List<KudoRecipient>> getRecentRecipients();

  /// Returns the full [KudoDetail] for [id].
  /// Throws [UnknownFailure] when no matching record is found.
  Future<KudoDetail> getKudoById(String id);

  /// Returns all kudos, optionally filtered in-memory by [hashtag] and/or
  /// [department]. Both filters applied when both are non-null.
  Future<List<Kudo>> getAllKudos({String? hashtag, String? department});

  /// Returns the distinct hashtag strings present in the mock data set.
  Future<List<String>> getHashtags();

  /// Returns the distinct department / role strings present in the mock data set.
  Future<List<String>> getDepartments();
}

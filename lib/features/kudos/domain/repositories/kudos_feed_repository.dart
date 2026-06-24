import '../entities/kudo.dart';
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
}

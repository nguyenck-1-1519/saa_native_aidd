import '../entities/kudo_draft.dart';
import '../entities/kudo_recipient.dart';

/// Contract for submitting a new kudo and searching recipient candidates.
///
/// The stub implementation resolves successfully with no network call.
/// Throws a [Failure] subtype on any error.
abstract interface class WriteKudoRepository {
  /// Submits [draft] as a new kudo. Returns normally on success.
  /// Throws [Failure] on error.
  Future<void> submitKudo(KudoDraft draft);

  /// Returns a list of [KudoRecipient] candidates matching [query].
  ///
  /// Matching is case-insensitive against name and role fields.
  /// The current user is always excluded from results.
  /// An empty [query] returns a suggested / recent list.
  Future<List<KudoRecipient>> searchRecipients(String query);
}

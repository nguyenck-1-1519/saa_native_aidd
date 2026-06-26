import '../entities/kudo_recipient.dart';
import '../repositories/write_kudo_repository.dart';

/// Returns [KudoRecipient] candidates matching [query] for the Write Kudo
/// recipient picker.
///
/// Matching is case-insensitive (name + role). Current user is excluded.
/// An empty [query] returns a suggested / recent list.
/// Throws [Failure] on error.
class SearchRecipients {
  const SearchRecipients(this._repo);

  final WriteKudoRepository _repo;

  Future<List<KudoRecipient>> call(String query) =>
      _repo.searchRecipients(query);
}

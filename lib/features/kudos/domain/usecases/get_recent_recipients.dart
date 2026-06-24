import '../entities/kudo_recipient.dart';
import '../repositories/kudos_feed_repository.dart';

/// Returns the most recent gift recipients list.
class GetRecentRecipients {
  const GetRecentRecipients(this._repo);

  final KudosFeedRepository _repo;

  Future<List<KudoRecipient>> call() => _repo.getRecentRecipients();
}

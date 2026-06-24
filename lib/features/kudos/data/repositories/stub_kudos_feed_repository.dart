import '../../../../core/error/failures.dart';
import '../../domain/entities/kudo.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/repositories/kudos_feed_repository.dart';
import '../sources/kudos_mock_data.dart';

/// Behavior modes for [StubKudosFeedRepository].
enum StubKudosFeedBehavior { data, empty, error }

/// Stub implementation of [KudosFeedRepository] for development and manual QA.
///
/// Adds an artificial delay to exercise loading state in the UI.
///   - [StubKudosFeedBehavior.data]  → returns design-sourced kudos
///   - [StubKudosFeedBehavior.empty] → returns empty lists
///   - [StubKudosFeedBehavior.error] → throws [UnknownFailure]
class StubKudosFeedRepository implements KudosFeedRepository {
  StubKudosFeedRepository({
    this.behavior = StubKudosFeedBehavior.data,
    this.delay = const Duration(milliseconds: 800),
  });

  final StubKudosFeedBehavior behavior;
  final Duration delay;

  @override
  Future<List<Kudo>> getKudos() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosFeedBehavior.data => KudosMockData.feed,
      StubKudosFeedBehavior.empty => const [],
      StubKudosFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated kudos feed fetch error'),
    };
  }

  @override
  Future<List<Kudo>> getHighlightKudos() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosFeedBehavior.data => KudosMockData.highlights,
      StubKudosFeedBehavior.empty => const [],
      StubKudosFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated kudos highlights fetch error'),
    };
  }

  @override
  Future<List<KudoRecipient>> getRecentRecipients() async {
    await Future<void>.delayed(delay);
    return switch (behavior) {
      StubKudosFeedBehavior.data => KudosMockData.recentRecipients,
      StubKudosFeedBehavior.empty => const [],
      StubKudosFeedBehavior.error =>
        throw const UnknownFailure('Stub: simulated recent recipients fetch error'),
    };
  }
}

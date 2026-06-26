import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/secret_box/presentation/providers/secret_box_providers.dart';
import '../../data/repositories/stub_kudos_feed_repository.dart';
import '../../data/repositories/stub_kudos_stats_repository.dart';
import '../../data/repositories/stub_write_kudo_repository.dart';
import '../../domain/entities/kudo.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/entities/kudos_stats.dart';
import '../../domain/repositories/kudos_feed_repository.dart';
import '../../domain/repositories/kudos_stats_repository.dart';
import '../../domain/repositories/write_kudo_repository.dart';
import '../../domain/usecases/get_all_kudos.dart';
import '../../domain/usecases/get_filter_options.dart';
import '../../domain/usecases/get_highlight_kudos.dart';
import '../../domain/usecases/get_kudo_by_id.dart';
import '../../domain/usecases/get_kudos_feed.dart';
import '../../domain/usecases/get_kudos_stats.dart';
import '../../domain/usecases/get_recent_recipients.dart';
import '../../domain/usecases/search_recipients.dart';
import '../../domain/usecases/submit_kudo.dart';

// ---------------------------------------------------------------------------
// Repository DI — override in tests with Fake* implementations
// ---------------------------------------------------------------------------

final kudosFeedRepositoryProvider = Provider<KudosFeedRepository>(
  (_) => StubKudosFeedRepository(),
);

final kudosStatsRepositoryProvider = Provider<KudosStatsRepository>(
  (_) => StubKudosStatsRepository(),
);

final writeKudoRepositoryProvider = Provider<WriteKudoRepository>(
  (_) => StubWriteKudoRepository(),
);

// ---------------------------------------------------------------------------
// Usecase DI
// ---------------------------------------------------------------------------

final getKudosFeedProvider = Provider<GetKudosFeed>(
  (ref) => GetKudosFeed(ref.watch(kudosFeedRepositoryProvider)),
);

final getHighlightKudosProvider = Provider<GetHighlightKudos>(
  (ref) => GetHighlightKudos(ref.watch(kudosFeedRepositoryProvider)),
);

final getRecentRecipientsProvider = Provider<GetRecentRecipients>(
  (ref) => GetRecentRecipients(ref.watch(kudosFeedRepositoryProvider)),
);

final getKudosStatsProvider = Provider<GetKudosStats>(
  (ref) => GetKudosStats(ref.watch(kudosStatsRepositoryProvider)),
);

/// RESERVED for real submit wiring. The Write-Kudo form currently handles
/// submission as a self-contained UI stub (success snackbar + pop, no
/// persistence) per F004 scope. When a real Kudos API lands, wire the
/// WriteKudoScreen's onSubmit to `ref.read(submitKudoProvider).call(draft)`.
final submitKudoProvider = Provider<SubmitKudo>(
  (ref) => SubmitKudo(ref.watch(writeKudoRepositoryProvider)),
);

final getKudoByIdProvider = Provider<GetKudoById>(
  (ref) => GetKudoById(ref.watch(kudosFeedRepositoryProvider)),
);

final getAllKudosProvider = Provider<GetAllKudos>(
  (ref) => GetAllKudos(ref.watch(kudosFeedRepositoryProvider)),
);

final searchRecipientsProvider = Provider<SearchRecipients>(
  (ref) => SearchRecipients(ref.watch(writeKudoRepositoryProvider)),
);

final getFilterOptionsProvider = Provider<GetFilterOptions>(
  (ref) => GetFilterOptions(ref.watch(kudosFeedRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// KudosFeedData — bundles feed + highlights + recipients in one async load
// ---------------------------------------------------------------------------

/// Bundles all feed data fetched in a single controller build cycle.
class KudosFeedData {
  const KudosFeedData({
    required this.feed,
    required this.highlights,
    required this.recipients,
  });

  final List<Kudo> feed;
  final List<Kudo> highlights;
  final List<KudoRecipient> recipients;
}

// ---------------------------------------------------------------------------
// Feed controller — AsyncNotifier with refresh/retry support
// ---------------------------------------------------------------------------

/// Loads and holds all kudos feed data.
///
/// Exposes [refresh] so the UI Retry button can re-trigger the fetch after
/// an error. Mirrors the F003 [AwardsDetailController] pattern.
class KudosFeedController extends AsyncNotifier<KudosFeedData> {
  @override
  FutureOr<KudosFeedData> build() async {
    final feed = ref.watch(getKudosFeedProvider);
    final highlights = ref.watch(getHighlightKudosProvider);
    final recipients = ref.watch(getRecentRecipientsProvider);

    final results = await Future.wait([
      feed.call(),
      highlights.call(),
      recipients.call(),
    ]);

    return KudosFeedData(
      feed: results[0] as List<Kudo>,
      highlights: results[1] as List<Kudo>,
      recipients: results[2] as List<KudoRecipient>,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final feed = ref.read(getKudosFeedProvider);
      final highlights = ref.read(getHighlightKudosProvider);
      final recipients = ref.read(getRecentRecipientsProvider);

      final results = await Future.wait([
        feed.call(),
        highlights.call(),
        recipients.call(),
      ]);

      return KudosFeedData(
        feed: results[0] as List<Kudo>,
        highlights: results[1] as List<Kudo>,
        recipients: results[2] as List<KudoRecipient>,
      );
    });
  }
}

final kudosFeedControllerProvider =
    AsyncNotifierProvider<KudosFeedController, KudosFeedData>(
  KudosFeedController.new,
);

// ---------------------------------------------------------------------------
// Stats provider — derives secret-box counts from the SHARED secret box
// repository (FR7 single source of truth).
//
// Fetches kudos stats (received/sent/hearts) from KudosStatsRepository and
// overrides the secretBoxOpened/secretBoxUnopened fields with live values
// from secretBoxStateProvider so the feed counter always reflects the real
// state after a box is opened.
// ---------------------------------------------------------------------------

final kudosStatsProvider = FutureProvider<KudosStats>((ref) async {
  final baseStats = await ref.watch(getKudosStatsProvider).call();
  final boxState = await ref.watch(secretBoxStateProvider.future);

  return KudosStats(
    received: baseStats.received,
    sent: baseStats.sent,
    heartsReceived: baseStats.heartsReceived,
    secretBoxOpened: boxState.openedRewards.length,
    secretBoxUnopened: boxState.unopenedCount,
  );
});

// ---------------------------------------------------------------------------
// Recent recipients — derived from feed controller (DRY: avoids duplicate fetch)
// ---------------------------------------------------------------------------

/// Derives the recent recipients list from the already-loaded feed controller.
///
/// Returns an empty list while loading or on error — callers must guard.
final recentRecipientsProvider = Provider<List<KudoRecipient>>((ref) {
  final feedAsync = ref.watch(kudosFeedControllerProvider);
  return feedAsync.valueOrNull?.recipients ?? const [];
});

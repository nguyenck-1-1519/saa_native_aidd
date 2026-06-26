import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/stub_awards_repository.dart';
import '../../data/repositories/stub_kudos_config_repository.dart';
import '../../domain/entities/award_card.dart';
import '../../domain/repositories/awards_repository.dart';
import '../../domain/repositories/kudos_config_repository.dart';
import '../../domain/usecases/get_awards.dart';
import '../../domain/usecases/get_kudos_availability.dart';
import '../../../../features/notifications/presentation/providers/notifications_providers.dart';

// ---------------------------------------------------------------------------
// Repository DI — override in tests with Fake* variants
// ---------------------------------------------------------------------------

final awardsRepositoryProvider = Provider<AwardsRepository>(
  (_) => StubAwardsRepository(),
);

final kudosConfigRepositoryProvider = Provider<KudosConfigRepository>(
  (_) => const StubKudosConfigRepository(),
);

// ---------------------------------------------------------------------------
// Usecase DI
// ---------------------------------------------------------------------------

final getAwardsProvider = Provider<GetAwards>(
  (ref) => GetAwards(ref.watch(awardsRepositoryProvider)),
);

final getKudosAvailabilityProvider = Provider<GetKudosAvailability>(
  (ref) => GetKudosAvailability(ref.watch(kudosConfigRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// Awards controller — AsyncNotifier with refresh/retry support
// ---------------------------------------------------------------------------

/// Loads and holds the awards list. Exposes [refresh] so the UI Retry button
/// can re-trigger [GetAwards] after an error (FUN_003 / FR4).
class AwardsController extends AsyncNotifier<List<AwardCard>> {
  @override
  FutureOr<List<AwardCard>> build() =>
      ref.watch(getAwardsProvider).call();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getAwardsProvider).call(),
    );
  }
}

final awardsControllerProvider =
    AsyncNotifierProvider<AwardsController, List<AwardCard>>(
  AwardsController.new,
);

// ---------------------------------------------------------------------------
// Notification badge stream — migrated to F007 notifications feature (P3)
//
// Shape kept as StreamProvider<int> so call sites in home_screen.dart (L176)
// and awards_screen.dart (L29) continue to use `.valueOrNull ?? 0` with zero
// edits. The stream is derived from notificationsUnreadCountProvider (a plain
// Provider<int>) by emitting its value as a one-shot async* stream and
// re-emitting whenever the upstream Provider recomputes.
// ---------------------------------------------------------------------------

/// Streams the unread notification count. Badge shown when value > 0 (FR6).
///
/// Delegates to [notificationsUnreadCountProvider] — the F007 notifications
/// controller is the single source of truth for the unread count.
final unreadCountProvider = StreamProvider<int>((ref) async* {
  yield ref.watch(notificationsUnreadCountProvider);
});

// ---------------------------------------------------------------------------
// Kudos feature flag
// ---------------------------------------------------------------------------

/// True when the Kudos section should be visible on Home (FR5).
final kudosAvailableProvider = Provider<bool>(
  (ref) => ref.watch(getKudosAvailabilityProvider).call(),
);

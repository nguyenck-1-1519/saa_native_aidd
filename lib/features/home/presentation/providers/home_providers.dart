import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/stub_awards_repository.dart';
import '../../data/repositories/stub_kudos_config_repository.dart';
import '../../data/repositories/stub_notification_repository.dart';
import '../../domain/entities/award_card.dart';
import '../../domain/repositories/awards_repository.dart';
import '../../domain/repositories/kudos_config_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_awards.dart';
import '../../domain/usecases/get_kudos_availability.dart';
import '../../domain/usecases/watch_unread_count.dart';

// ---------------------------------------------------------------------------
// Repository DI — override in tests with Fake* variants
// ---------------------------------------------------------------------------

final awardsRepositoryProvider = Provider<AwardsRepository>(
  (_) => StubAwardsRepository(),
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (_) => StubNotificationRepository(),
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

final watchUnreadCountProvider = Provider<WatchUnreadCount>(
  (ref) => WatchUnreadCount(ref.watch(notificationRepositoryProvider)),
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
// Notification badge stream
// ---------------------------------------------------------------------------

/// Streams the unread notification count. Badge shown when value > 0 (FR6).
final unreadCountProvider = StreamProvider<int>(
  (ref) => ref.watch(watchUnreadCountProvider).call(),
);

// ---------------------------------------------------------------------------
// Kudos feature flag
// ---------------------------------------------------------------------------

/// True when the Kudos section should be visible on Home (FR5).
final kudosAvailableProvider = Provider<bool>(
  (ref) => ref.watch(getKudosAvailabilityProvider).call(),
);

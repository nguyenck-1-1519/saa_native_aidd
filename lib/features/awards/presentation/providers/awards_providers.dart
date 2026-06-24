import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/stub_awards_detail_repository.dart';
import '../../domain/entities/award_detail.dart';
import '../../domain/repositories/awards_detail_repository.dart';
import '../../domain/usecases/get_award_details.dart';
import '../../data/sources/awards_detail_mock_data.dart';

// ---------------------------------------------------------------------------
// Repository DI — override in tests with FakeAwardsDetailRepository
// ---------------------------------------------------------------------------

final awardsDetailRepositoryProvider = Provider<AwardsDetailRepository>(
  (_) => StubAwardsDetailRepository(),
);

// ---------------------------------------------------------------------------
// Usecase DI
// ---------------------------------------------------------------------------

final getAwardDetailsProvider = Provider<GetAwardDetails>(
  (ref) => GetAwardDetails(ref.watch(awardsDetailRepositoryProvider)),
);

// ---------------------------------------------------------------------------
// Awards detail controller — AsyncNotifier with refresh/retry support
// ---------------------------------------------------------------------------

/// Loads and holds the award detail list. Exposes [refresh] so the UI Retry
/// button can re-trigger [GetAwardDetails] after an error.
class AwardsDetailController extends AsyncNotifier<List<AwardDetail>> {
  @override
  FutureOr<List<AwardDetail>> build() =>
      ref.watch(getAwardDetailsProvider).call();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getAwardDetailsProvider).call(),
    );
  }
}

final awardsDetailControllerProvider =
    AsyncNotifierProvider<AwardsDetailController, List<AwardDetail>>(
  AwardsDetailController.new,
);

// ---------------------------------------------------------------------------
// Dropdown selection — which award id is currently shown
// ---------------------------------------------------------------------------

/// Holds the id of the award currently shown in the dropdown.
///
/// Defaults to the first award in the design-sourced list ('top-talent').
/// Pure UI selection state — not business logic, so [StateProvider] is
/// appropriate per code-standards §4.
final selectedAwardIdProvider = StateProvider<String>(
  (_) => AwardsDetailMockData.awards.first.id,
);

// ---------------------------------------------------------------------------
// Derived — the AwardDetail matching the current selection
// ---------------------------------------------------------------------------

/// Derives the [AwardDetail] for the currently selected award id.
///
/// Returns `null` while the controller is loading or if the id is not found
/// (e.g. before the list resolves). The Awards screen must guard for null.
final selectedAwardDetailProvider = Provider<AwardDetail?>((ref) {
  final selectedId = ref.watch(selectedAwardIdProvider);
  final awardsAsync = ref.watch(awardsDetailControllerProvider);

  final list = awardsAsync.valueOrNull;
  if (list == null || list.isEmpty) return null;
  return list.firstWhere((a) => a.id == selectedId, orElse: () => list.first);
});

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/kudo.dart';
import '../../domain/entities/kudo_recipient.dart';
import 'kudos_providers.dart';

// ---------------------------------------------------------------------------
// Feed filter state — hashtag + department selection
// ---------------------------------------------------------------------------

/// Sentinel object used by [FeedFilter.copyWith] to distinguish
/// "caller did not supply this field" from "caller explicitly set null".
const _sentinel = Object();

/// Holds the currently selected hashtag and department filter values.
///
/// Both fields are nullable — null means "no filter applied".
class FeedFilter {
  const FeedFilter({this.hashtag, this.department});

  final String? hashtag;
  final String? department;

  /// Selective update with explicit null-clear semantics.
  ///
  /// - Omit a parameter (default [_sentinel]) → keep current value.
  /// - Pass `null` explicitly → clear the field.
  /// - Pass a non-null [String] → set the field.
  FeedFilter copyWith({
    Object? hashtag = _sentinel,
    Object? department = _sentinel,
  }) =>
      FeedFilter(
        hashtag: hashtag == _sentinel ? this.hashtag : hashtag as String?,
        department: department == _sentinel
            ? this.department
            : department as String?,
      );

  /// Returns a cleared filter (both fields null).
  FeedFilter cleared() => const FeedFilter();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedFilter &&
          other.hashtag == hashtag &&
          other.department == department;

  @override
  int get hashCode => Object.hash(hashtag, department);
}

/// Controls the active [FeedFilter] for the All Kudos screen.
///
/// Screens watch [allKudosProvider] which re-fetches whenever this changes.
class FeedFilterController extends Notifier<FeedFilter> {
  @override
  FeedFilter build() => const FeedFilter();

  /// Sets (or clears) the hashtag filter.
  /// Pass [null] to clear — the filter will show all hashtags.
  void setHashtag(String? hashtag) =>
      state = state.copyWith(hashtag: hashtag);

  /// Sets (or clears) the department filter.
  /// Pass [null] to clear — the filter will show all departments.
  void setDepartment(String? department) =>
      state = state.copyWith(department: department);

  void clear() => state = const FeedFilter();
}

final feedFilterControllerProvider =
    NotifierProvider<FeedFilterController, FeedFilter>(
  FeedFilterController.new,
);

// ---------------------------------------------------------------------------
// All Kudos — filtered list driven by feedFilterControllerProvider
// ---------------------------------------------------------------------------

/// Returns all kudos filtered by the current [FeedFilter] selection.
///
/// Re-fetches automatically whenever the filter state changes.
final allKudosProvider = FutureProvider<List<Kudo>>((ref) {
  final filter = ref.watch(feedFilterControllerProvider);
  return ref.watch(getAllKudosProvider).call(
        hashtag: filter.hashtag,
        department: filter.department,
      );
});

// ---------------------------------------------------------------------------
// Filter option lists — hashtags and departments for dropdown menus
// ---------------------------------------------------------------------------

/// Returns the distinct hashtag strings available for filtering.
final hashtagOptionsProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(getFilterOptionsProvider).hashtags(),
);

/// Returns the distinct department / role strings available for filtering.
final departmentOptionsProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(getFilterOptionsProvider).departments(),
);

// ---------------------------------------------------------------------------
// Recipient search — debounced Notifier for the Write Kudo recipient picker
// ---------------------------------------------------------------------------

/// State + search logic for the Write Kudo recipient search field.
///
/// Call [query] with the current text-field value. Results are debounced by
/// 300 ms to avoid firing a search on every keystroke. The state is
/// `AsyncValue<List<KudoRecipient>>` so the UI can show loading / error /
/// data states directly.
class RecipientSearchController
    extends Notifier<AsyncValue<List<KudoRecipient>>> {
  static const _debounceDuration = Duration(milliseconds: 300);

  Timer? _debounce;

  @override
  AsyncValue<List<KudoRecipient>> build() {
    ref.onDispose(() => _debounce?.cancel());
    // Load suggestions immediately on first build.
    _doSearch('');
    return const AsyncLoading();
  }

  /// Triggers a debounced search for [text].
  ///
  /// An empty [text] returns the suggested / recent list.
  void query(String text) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () => _doSearch(text));
  }

  Future<void> _doSearch(String text) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(searchRecipientsProvider).call(text),
    );
  }
}

final recipientSearchControllerProvider = NotifierProvider<
    RecipientSearchController, AsyncValue<List<KudoRecipient>>>(
  RecipientSearchController.new,
);

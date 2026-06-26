import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/kudo_detail.dart';
import 'kudos_providers.dart';

// ---------------------------------------------------------------------------
// Kudo Detail — FutureProvider.family keyed by kudo id
// ---------------------------------------------------------------------------

/// Fetches the full [KudoDetail] for a single kudo by its string [id].
///
/// Backed by [getKudoByIdProvider] usecase → [KudosFeedRepository.getKudoById].
/// Throws [Failure] when no matching record is found (repo raises it).
///
/// `autoDispose` prevents per-id cache accumulation — each detail screen
/// fetches fresh data when opened and releases memory on pop.
///
/// Usage in a widget:
/// ```dart
/// final detail = ref.watch(kudoDetailProvider('kudo-001'));
/// ```
final kudoDetailProvider =
    FutureProvider.autoDispose.family<KudoDetail, String>((ref, id) {
  return ref.watch(getKudoByIdProvider).call(id);
});

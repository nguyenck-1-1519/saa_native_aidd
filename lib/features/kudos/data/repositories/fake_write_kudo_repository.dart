import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/kudo_draft.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/repositories/write_kudo_repository.dart';
import '../sources/kudos_detail_mock_data.dart';

/// Deterministic, delay-free [WriteKudoRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.success()`  → resolves immediately with no error
///   - `.error()`    → throws [UnknownFailure] immediately
///   - `.loading()`  → never resolves — pins the controller in submitting state
class FakeWriteKudoRepository implements WriteKudoRepository {
  FakeWriteKudoRepository._({
    required Future<void> Function(KudoDraft) submitHandler,
    required Future<List<KudoRecipient>> Function(String) searchHandler,
  })  : _submitHandler = submitHandler,
        _searchHandler = searchHandler;

  factory FakeWriteKudoRepository.success() => FakeWriteKudoRepository._(
        submitHandler: (_) async {},
        searchHandler: (query) async {
          final candidates = KudosDetailMockData.sunners
              .where((r) => r.name != KudosDetailMockData.currentUserName)
              .toList();
          if (query.isEmpty) return candidates.take(5).toList();
          final lower = query.toLowerCase();
          return candidates
              .where((r) =>
                  r.name.toLowerCase().contains(lower) ||
                  (r.role?.toLowerCase().contains(lower) ?? false))
              .toList();
        },
      );

  factory FakeWriteKudoRepository.error() => FakeWriteKudoRepository._(
        submitHandler: (_) async =>
            throw const UnknownFailure('Fake: simulated submit kudo error'),
        searchHandler: (_) async =>
            throw const UnknownFailure('Fake: simulated search recipients error'),
      );

  /// Returns futures that never complete — useful for testing submitting /
  /// searching states.
  factory FakeWriteKudoRepository.loading() => FakeWriteKudoRepository._(
        submitHandler: (_) => Completer<void>().future,
        searchHandler: (_) => Completer<List<KudoRecipient>>().future,
      );

  final Future<void> Function(KudoDraft) _submitHandler;
  final Future<List<KudoRecipient>> Function(String) _searchHandler;

  @override
  Future<void> submitKudo(KudoDraft draft) => _submitHandler(draft);

  @override
  Future<List<KudoRecipient>> searchRecipients(String query) =>
      _searchHandler(query);
}

import 'dart:async';

import '../../../../core/error/failures.dart';
import '../../domain/entities/kudo_draft.dart';
import '../../domain/repositories/write_kudo_repository.dart';

/// Deterministic, delay-free [WriteKudoRepository] for unit and widget tests.
///
/// Use named constructors to pin a specific state:
///   - `.success()`  → resolves immediately with no error
///   - `.error()`    → throws [UnknownFailure] immediately
///   - `.loading()`  → never resolves — pins the controller in submitting state
class FakeWriteKudoRepository implements WriteKudoRepository {
  FakeWriteKudoRepository._({
    required Future<void> Function(KudoDraft) handler,
  }) : _handler = handler;

  factory FakeWriteKudoRepository.success() => FakeWriteKudoRepository._(
        handler: (_) async {},
      );

  factory FakeWriteKudoRepository.error() => FakeWriteKudoRepository._(
        handler: (_) async =>
            throw const UnknownFailure('Fake: simulated submit kudo error'),
      );

  /// Returns a future that never completes — useful for testing submitting state.
  factory FakeWriteKudoRepository.loading() => FakeWriteKudoRepository._(
        handler: (_) => Completer<void>().future,
      );

  final Future<void> Function(KudoDraft) _handler;

  @override
  Future<void> submitKudo(KudoDraft draft) => _handler(draft);
}

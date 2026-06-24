import '../../domain/entities/kudo_draft.dart';
import '../../domain/repositories/write_kudo_repository.dart';

/// Stub implementation of [WriteKudoRepository] for development and manual QA.
///
/// Always resolves successfully after a short delay (simulates a network round
/// trip). No actual persistence occurs.
class StubWriteKudoRepository implements WriteKudoRepository {
  StubWriteKudoRepository({
    this.delay = const Duration(milliseconds: 600),
  });

  final Duration delay;

  @override
  Future<void> submitKudo(KudoDraft draft) async {
    await Future<void>.delayed(delay);
    // Stub: success — no error thrown, no storage.
  }
}

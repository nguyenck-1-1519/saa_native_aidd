import '../../domain/entities/kudo_draft.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/repositories/write_kudo_repository.dart';
import '../sources/kudos_detail_mock_data.dart';

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

  @override
  Future<List<KudoRecipient>> searchRecipients(String query) async {
    await Future<void>.delayed(delay);
    final candidates = KudosDetailMockData.sunners
        .where((r) => r.name != KudosDetailMockData.currentUserName)
        .toList();

    if (query.isEmpty) {
      // Empty query → return first 5 as suggested list.
      return candidates.take(5).toList();
    }

    final lower = query.toLowerCase();
    return candidates
        .where((r) =>
            r.name.toLowerCase().contains(lower) ||
            (r.role?.toLowerCase().contains(lower) ?? false))
        .toList();
  }
}

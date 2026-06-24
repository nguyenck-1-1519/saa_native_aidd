import '../entities/kudo_draft.dart';
import '../repositories/write_kudo_repository.dart';

/// Submits a new kudo to the repository.
///
/// Delegates to [WriteKudoRepository]; the stub resolves immediately with
/// success. Throws [Failure] on any error.
class SubmitKudo {
  const SubmitKudo(this._repo);

  final WriteKudoRepository _repo;

  Future<void> call(KudoDraft draft) => _repo.submitKudo(draft);
}

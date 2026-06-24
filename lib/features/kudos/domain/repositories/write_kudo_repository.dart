import '../entities/kudo_draft.dart';

/// Contract for submitting a new kudo.
///
/// The stub implementation resolves successfully with no network call.
/// Throws a [Failure] subtype on any error.
abstract interface class WriteKudoRepository {
  /// Submits [draft] as a new kudo. Returns normally on success.
  /// Throws [Failure] on error.
  Future<void> submitKudo(KudoDraft draft);
}

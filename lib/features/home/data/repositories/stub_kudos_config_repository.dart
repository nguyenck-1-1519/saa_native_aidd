import '../../domain/repositories/kudos_config_repository.dart';

/// Stub implementation of [KudosConfigRepository] for development and QA.
///
/// Default [isKudosAvailable] is true so the Kudos section is visible.
/// Pass false to verify the hidden state (FR5: ẩn hẳn khi feature off).
class StubKudosConfigRepository implements KudosConfigRepository {
  const StubKudosConfigRepository({this.isKudosAvailable = true});

  @override
  final bool isKudosAvailable;
}

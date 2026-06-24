import '../repositories/kudos_config_repository.dart';

/// Reads the Kudos feature-flag from [KudosConfigRepository].
///
/// Returns true when the Kudos section should be shown on Home.
/// Synchronous — no async gap; the repository contract is a getter.
class GetKudosAvailability {
  const GetKudosAvailability(this._repository);

  final KudosConfigRepository _repository;

  bool call() => _repository.isKudosAvailable;
}

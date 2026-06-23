/// Contract for reading the Kudos feature-flag.
///
/// Implementations live in `data/repositories/`. Pure Dart — no Flutter,
/// no Riverpod. The flag is read synchronously so the UI can hide/show the
/// Kudos section without an async gap.
abstract interface class KudosConfigRepository {
  /// Whether the Kudos section should be visible on the Home screen.
  bool get isKudosAvailable;
}

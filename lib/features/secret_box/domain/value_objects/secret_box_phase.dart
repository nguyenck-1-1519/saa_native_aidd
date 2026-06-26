/// Drives the Secret Box reveal state machine in [SecretBoxController].
///
/// Transitions: closed → opening → revealed
/// Reset:        any   → closed
enum SecretBoxPhase {
  /// Box is present but not yet tapped. Default entry state.
  closed,

  /// User tapped — async open in flight; UI plays the opening animation.
  opening,

  /// Open complete — reward is available; UI shows the reward card.
  revealed,
}

/// Notification types used across the F007 Notifications feature.
///
/// UI layer maps each type to a display icon and label — domain stays clean.
enum NotificationType {
  /// A colleague sent or reacted to a kudo involving the current user.
  kudos,

  /// An award-related event (nomination, win, ceremony reminder).
  award,

  /// A secret-box reward is available to open.
  secretBox,

  /// General system or admin broadcast.
  system,
}

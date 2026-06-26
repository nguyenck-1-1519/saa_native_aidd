import '../value_objects/hero_tag.dart';

/// Full detail representation of a single kudo, shown on the Kudo Detail screen.
///
/// Extends the feed-card [Kudo] data with sender/recipient avatars, images,
/// full message, hero tag enum, anonymity flag, and shareable link.
class KudoDetail {
  const KudoDetail({
    required this.id,
    required this.senderName,
    required this.senderRole,
    this.senderAvatarUrl,
    required this.recipientName,
    required this.recipientRole,
    this.recipientAvatarUrl,
    required this.heroTag,
    required this.isAnonymous,
    required this.imageUrls,
    required this.timeRange,
    required this.createdAt,
    required this.title,
    required this.message,
    required this.hashtags,
    required this.heartCount,
    this.linkUrl,
  });

  final String id;

  // Sender fields — masked when [isAnonymous] is true.
  final String senderName;
  final String senderRole;
  final String? senderAvatarUrl;

  // Recipient fields.
  final String recipientName;
  final String recipientRole;
  final String? recipientAvatarUrl;

  /// Structured award category badge.
  final HeroTag heroTag;

  /// When true the sender identity is hidden in the UI.
  final bool isAnonymous;

  /// Attached images (up to 5 per F004 rules).
  final List<String> imageUrls;

  /// Human-readable time period string, e.g. "Tháng 6, 2025".
  final String timeRange;

  /// Exact creation timestamp used for sorting / display.
  final DateTime createdAt;

  /// Short award title shown as the card headline.
  final String title;

  /// Full kudo message (no truncation on detail screen).
  final String message;

  final List<String> hashtags;
  final int heartCount;

  /// Shareable deep-link URL for Copy Link action; null until backend wired.
  final String? linkUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KudoDetail &&
          other.id == id &&
          other.senderName == senderName &&
          other.recipientName == recipientName &&
          other.heroTag == heroTag &&
          other.isAnonymous == isAnonymous &&
          other.title == title &&
          other.message == message &&
          other.heartCount == heartCount;

  @override
  int get hashCode => Object.hash(
        id,
        senderName,
        recipientName,
        heroTag,
        isAnonymous,
        title,
        message,
        heartCount,
      );
}

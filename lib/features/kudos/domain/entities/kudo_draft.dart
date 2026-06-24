/// Value object representing an in-progress or submitted kudo.
///
/// Used by [WriteKudoRepository.submitKudo] and the write-kudo form controller.
/// Framework-free — no Flutter or Riverpod imports.
class KudoDraft {
  const KudoDraft({
    required this.recipientId,
    required this.title,
    required this.message,
    required this.hashtags,
    this.imageCount = 0,
    this.isAnonymous = false,
  });

  /// Recipient user id — must be non-null and differ from the sender's id.
  final String recipientId;

  /// Award title / "danh hiệu" — required, max 100 chars.
  final String title;

  /// Personal message — required, non-whitespace, max 1000 chars.
  final String message;

  /// Community hashtags; 1–5 entries required.
  final List<String> hashtags;

  /// Number of attached images (presentational only, 0–5).
  final int imageCount;

  /// Whether the sender's identity is hidden from the recipient.
  final bool isAnonymous;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KudoDraft &&
          other.recipientId == recipientId &&
          other.title == title &&
          other.message == message &&
          _sameTags(other.hashtags, hashtags) &&
          other.imageCount == imageCount &&
          other.isAnonymous == isAnonymous;

  @override
  int get hashCode => Object.hash(recipientId, title, message,
      Object.hashAll(hashtags), imageCount, isAnonymous);

  static bool _sameTags(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

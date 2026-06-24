/// A single kudos card shown in the Kudos feed/highlight carousel.
class Kudo {
  const Kudo({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.recipientName,
    required this.recipientRole,
    required this.timeRange,
    required this.title,
    required this.message,
    required this.hashtags,
    required this.heartCount,
  });

  final String id;
  final String senderName;
  final String senderRole;
  final String recipientName;
  final String recipientRole;
  final String timeRange;
  final String title;
  final String message;
  final List<String> hashtags;
  final int heartCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Kudo &&
          other.id == id &&
          other.senderName == senderName &&
          other.recipientName == recipientName &&
          other.title == title &&
          other.message == message &&
          other.heartCount == heartCount;

  @override
  int get hashCode =>
      Object.hash(id, senderName, recipientName, title, message, heartCount);
}

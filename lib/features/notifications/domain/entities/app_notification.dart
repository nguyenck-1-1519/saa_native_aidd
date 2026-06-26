import 'notification_type.dart';

/// A single notification in the user's notification feed.
///
/// Immutable; use [copyWith] to produce a modified copy (e.g. flip [isRead]).
/// Equality is based on [id] and [isRead] so that marking a notification read
/// triggers a widget rebuild without replacing the whole list identity.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    this.deepLinkTarget,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  /// Optional entity id resolved per [type] by the notifications route wrapper.
  ///
  /// - kudos      → kudo id (e.g. 'kudo-001') → route '/kudos/detail/kudo-001'
  /// - award      → award id (e.g. 'top-talent') → selectedAwardIdProvider + '/awards'
  /// - secretBox  → null (route is fixed)
  /// - system     → null (informational, no navigation)
  ///
  /// Domain never imports GoRouter — routing is resolved in the presentation layer.
  final String? deepLinkTarget;

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? createdAt,
    bool? isRead,
    String? deepLinkTarget,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      deepLinkTarget: deepLinkTarget ?? this.deepLinkTarget,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppNotification &&
        other.id == id &&
        other.isRead == isRead;
  }

  @override
  int get hashCode => Object.hash(id, isRead);

  @override
  String toString() =>
      'AppNotification(id: $id, type: $type, isRead: $isRead)';
}

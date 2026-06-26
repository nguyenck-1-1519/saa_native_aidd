import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_type.dart';

/// Design-sourced mock notifications for the F007 Notifications feature.
///
/// Provides at least one entry per [NotificationType] with a realistic mix
/// of read/unread states and descending [createdAt] timestamps.
///
/// [AppNotification.deepLinkTarget] holds an ENTITY ID resolved per type by
/// [NotificationsRouteWrapper._resolveDeepLink]:
///   • kudos      → kudo id (e.g. 'kudo-001') → '/kudos/detail/kudo-001'
///   • award      → award id (e.g. 'top-talent') → selectedAwardIdProvider + '/awards'
///   • secretBox  → null (route is fixed: '/secret-box')
///   • system     → null (informational, no navigation)
abstract final class NotificationsMockData {
  static final List<AppNotification> items = [
    AppNotification(
      id: 'notif-001',
      type: NotificationType.kudos,
      title: 'Bạn nhận được 1 Kudo mới!',
      body: 'Nguyễn Minh Tuấn đã gửi Kudo "Rising Hero" cho bạn.',
      createdAt: DateTime(2025, 6, 20, 9, 30),
      isRead: false,
      deepLinkTarget: 'kudo-001',
    ),
    AppNotification(
      id: 'notif-002',
      type: NotificationType.award,
      title: 'Kết quả SAA 2025 đã được công bố',
      body: 'Xem danh sách các giải thưởng Sun* Annual Awards 2025.',
      createdAt: DateTime(2025, 6, 19, 14, 0),
      isRead: false,
      deepLinkTarget: 'top-talent',
    ),
    AppNotification(
      id: 'notif-003',
      type: NotificationType.secretBox,
      title: 'Bạn có 1 Secret Box chưa mở!',
      body: 'Hãy mở Secret Box để nhận phần thưởng bí ẩn của bạn.',
      createdAt: DateTime(2025, 6, 18, 11, 15),
      isRead: false,
    ),
    AppNotification(
      id: 'notif-004',
      type: NotificationType.kudos,
      title: 'Kudo của bạn nhận được 5 tim mới',
      body: 'Mọi người đang thả tim vào Kudo bạn gửi cho Trần Thị Lan.',
      createdAt: DateTime(2025, 6, 17, 16, 45),
      isRead: true,
      deepLinkTarget: 'kudo-001',
    ),
    AppNotification(
      id: 'notif-005',
      type: NotificationType.system,
      title: 'Chào mừng đến với SAA 2025!',
      body: 'Khám phá hệ thống giải thưởng và ghi nhận đồng nghiệp của bạn.',
      createdAt: DateTime(2025, 6, 15, 8, 0),
      isRead: true,
    ),
    AppNotification(
      id: 'notif-006',
      type: NotificationType.kudos,
      title: 'Bạn nhận được 1 Kudo mới!',
      body: 'Lê Văn Hùng đã gửi Kudo "Legend Hero" cho bạn.',
      createdAt: DateTime(2025, 6, 14, 10, 20),
      isRead: true,
      deepLinkTarget: 'kudo-002',
    ),
    AppNotification(
      id: 'notif-007',
      type: NotificationType.award,
      title: 'Bình chọn giải thưởng sắp kết thúc',
      body: 'Còn 3 ngày để hoàn thành bình chọn Sun* Annual Awards 2025.',
      createdAt: DateTime(2025, 6, 10, 9, 0),
      isRead: true,
      deepLinkTarget: 'top-talent',
    ),
  ];
}

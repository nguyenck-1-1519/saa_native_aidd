import 'notifications_screen.dart';

/// Mock notification items extracted verbatim from the Figma design.
/// Replaced by real data when INT wires up the provider.
const List<NotificationItemView> kNotificationsMockItems = [
  NotificationItemView(
    id: 'n1',
    title: '',
    body:
        'Sunner Huỳnh Dương Xuân Nhật vừa gửi đến bạn lời ghi nhận đầy yêu thương!',
    timeLabel: '15 phút trước',
    isRead: false,
    typeKey: 'kudos',
  ),
  NotificationItemView(
    id: 'n2',
    title: '',
    body:
        'Wow! Lời nhắn gửi của bạn cho Sunner <tên Sunner> vừa nhận thêm lượt tim!',
    timeLabel: '1 giờ trước',
    isRead: true,
    typeKey: 'heart',
  ),
  NotificationItemView(
    id: 'n3',
    title: '',
    body:
        'Chúc mừng! Bạn vừa nhận được lượt mở Secret Box mới! Click vào đây để mở ngay nhé!',
    timeLabel: '1 ngày trước',
    isRead: true,
    typeKey: 'secretBox',
  ),
  NotificationItemView(
    id: 'n4',
    title: '',
    body:
        'Bạn nhận được <X> lời nhắn gửi từ đồng nghiệp và thăng hạng <tên level>!\nTiếp tục lan tỏa năng lượng tích cực đến đồng nghiệp nhé!',
    timeLabel: '1 ngày trước',
    isRead: true,
    typeKey: 'levelUp',
  ),
  NotificationItemView(
    id: 'n5',
    title: '',
    body:
        'Tiếc quá! Bạn có một lời nhắn bị tạm ẩn vì "vướng" một số tiêu chuẩn! Hãy xem các tiêu chuẩn và gửi lại cho đồng đội nhé!',
    timeLabel: '1 tháng trước',
    isRead: true,
    typeKey: 'warning',
  ),
  NotificationItemView(
    id: 'n6',
    title: '',
    body:
        'Chúc mừng bạn đã thu thập đủ 6 huy hiệu của SAA. Bạn đã nhận được phần quà từ BTC chính là <X>. BTC sẽ liên hệ để gửi quà đến bạn vào cuối sự kiện.',
    timeLabel: '1 tháng trước',
    isRead: true,
    typeKey: 'badge',
  ),
  NotificationItemView(
    id: 'n7',
    title: '',
    body:
        '"Có <x> lời nhắn cần bạn xem xét!"\nMột lời nhắn vừa bị hệ thống gắn cờ nghi ngờ vi phạm tiêu chuẩn. Vui lòng kiểm tra và xác nhận trạng thái: Hợp lệ / Tạm ẩn / Reject.',
    timeLabel: '1 tháng trước',
    isRead: true,
    typeKey: 'review',
  ),
];

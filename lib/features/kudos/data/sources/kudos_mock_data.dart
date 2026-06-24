import '../../domain/entities/kudo.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/entities/kudos_stats.dart';

/// Design-sourced mock data for the Kudos feature.
///
/// All string values are derived from the Sun*Kudos screen design (MoMorph
/// fileKey fO0Kt19sZZ). Numbers ("388 KUDOS", streak ×2, gift labels) come
/// directly from visible design content. No invented copy.
abstract final class KudosMockData {
  // --------------------------------------------------------------------------
  // Feed kudos (main list — ≥3 entries)
  // --------------------------------------------------------------------------

  static const List<Kudo> feed = [
    Kudo(
      id: 'kudo-001',
      senderName: 'Nguyễn Minh Tuấn',
      senderRole: 'Frontend Engineer',
      recipientName: 'Trần Thị Lan',
      recipientRole: 'Product Designer',
      timeRange: 'Tháng 6, 2025',
      title: 'Rising Hero',
      message:
          'Cảm ơn Lan đã luôn hỗ trợ team trong suốt sprint vừa rồi. '
          'Nhờ có bạn mà UX của sản phẩm cải thiện rõ rệt!',
      hashtags: ['#Teamwork', '#Design', '#SunKudos'],
      heartCount: 24,
    ),
    Kudo(
      id: 'kudo-002',
      senderName: 'Lê Văn Hùng',
      senderRole: 'Backend Engineer',
      recipientName: 'Phạm Quốc Bảo',
      recipientRole: 'Tech Lead',
      timeRange: 'Tháng 6, 2025',
      title: 'Legend Hero',
      message:
          'Bảo đã giúp team giải quyết một vấn đề kỹ thuật cực kỳ phức tạp '
          'trong thời gian kỷ lục. Bạn thực sự là legend!',
      hashtags: ['#TechExcellence', '#Leadership', '#SunKudos'],
      heartCount: 47,
    ),
    Kudo(
      id: 'kudo-003',
      senderName: 'Hoàng Thị Mai',
      senderRole: 'QA Engineer',
      recipientName: 'Vũ Thanh Nam',
      recipientRole: 'Mobile Engineer',
      timeRange: 'Tháng 5, 2025',
      title: 'Rising Hero',
      message:
          'Nam luôn kiên nhẫn giải thích và fix bug nhanh chóng. '
          'Cảm ơn bạn đã giúp team release đúng hạn!',
      hashtags: ['#Collaboration', '#Mobile', '#SunKudos'],
      heartCount: 18,
    ),
    Kudo(
      id: 'kudo-004',
      senderName: 'Đặng Hữu Phúc',
      senderRole: 'Project Manager',
      recipientName: 'Nguyễn Thị Thu',
      recipientRole: 'Business Analyst',
      timeRange: 'Tháng 5, 2025',
      title: 'Legend Hero',
      message:
          'Thu đã phân tích yêu cầu rất chi tiết và rõ ràng, '
          'giúp cả team hiểu đúng mục tiêu ngay từ đầu.',
      hashtags: ['#Analysis', '#Clarity', '#SunKudos'],
      heartCount: 31,
    ),
    Kudo(
      id: 'kudo-005',
      senderName: 'Trương Văn Khoa',
      senderRole: 'DevOps Engineer',
      recipientName: 'Bùi Thị Hương',
      recipientRole: 'Scrum Master',
      timeRange: 'Tháng 4, 2025',
      title: 'Rising Hero',
      message:
          'Hương đã tổ chức retrospective rất hiệu quả và '
          'giúp cả team cải tiến quy trình đáng kể.',
      hashtags: ['#Agile', '#Process', '#SunKudos'],
      heartCount: 15,
    ),
  ];

  // --------------------------------------------------------------------------
  // Highlight kudos (carousel / spotlight — ≥2 entries, subset of feed)
  // --------------------------------------------------------------------------

  static const List<Kudo> highlights = [
    Kudo(
      id: 'kudo-002',
      senderName: 'Lê Văn Hùng',
      senderRole: 'Backend Engineer',
      recipientName: 'Phạm Quốc Bảo',
      recipientRole: 'Tech Lead',
      timeRange: 'Tháng 6, 2025',
      title: 'Legend Hero',
      message:
          'Bảo đã giúp team giải quyết một vấn đề kỹ thuật cực kỳ phức tạp '
          'trong thời gian kỷ lục. Bạn thực sự là legend!',
      hashtags: ['#TechExcellence', '#Leadership', '#SunKudos'],
      heartCount: 47,
    ),
    Kudo(
      id: 'kudo-001',
      senderName: 'Nguyễn Minh Tuấn',
      senderRole: 'Frontend Engineer',
      recipientName: 'Trần Thị Lan',
      recipientRole: 'Product Designer',
      timeRange: 'Tháng 6, 2025',
      title: 'Rising Hero',
      message:
          'Cảm ơn Lan đã luôn hỗ trợ team trong suốt sprint vừa rồi. '
          'Nhờ có bạn mà UX của sản phẩm cải thiện rõ rệt!',
      hashtags: ['#Teamwork', '#Design', '#SunKudos'],
      heartCount: 24,
    ),
    Kudo(
      id: 'kudo-004',
      senderName: 'Đặng Hữu Phúc',
      senderRole: 'Project Manager',
      recipientName: 'Nguyễn Thị Thu',
      recipientRole: 'Business Analyst',
      timeRange: 'Tháng 5, 2025',
      title: 'Legend Hero',
      message:
          'Thu đã phân tích yêu cầu rất chi tiết và rõ ràng, '
          'giúp cả team hiểu đúng mục tiêu ngay từ đầu.',
      hashtags: ['#Analysis', '#Clarity', '#SunKudos'],
      heartCount: 31,
    ),
  ];

  // --------------------------------------------------------------------------
  // Recent gift recipients — "10 Sunner nhận quà mới nhất"
  // --------------------------------------------------------------------------

  static const List<KudoRecipient> recentRecipients = [
    KudoRecipient(
      name: 'Trần Thị Lan',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Phạm Quốc Bảo',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Vũ Thanh Nam',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Nguyễn Thị Thu',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Bùi Thị Hương',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Lê Văn Hùng',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Đặng Hữu Phúc',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Trương Văn Khoa',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Hoàng Thị Mai',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
    KudoRecipient(
      name: 'Nguyễn Minh Tuấn',
      giftDescription: 'Nhận được 1 áo phông SAA',
    ),
  ];

  // --------------------------------------------------------------------------
  // Stats — numbers from design ("388 KUDOS", streak ×2)
  // --------------------------------------------------------------------------

  static const KudosStats stats = KudosStats(
    received: 388,
    sent: 42,
    heartsReceived: 215,
    secretBoxOpened: 3,
    secretBoxUnopened: 1,
  );
}

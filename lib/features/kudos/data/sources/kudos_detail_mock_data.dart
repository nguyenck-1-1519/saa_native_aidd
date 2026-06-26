import '../../domain/entities/kudo_detail.dart';
import '../../domain/entities/kudo_recipient.dart';
import '../../domain/value_objects/hero_tag.dart';

/// Extended mock data for Kudo detail, recipient search, and filter options.
///
/// Detail records are keyed by the same ids used in [KudosMockData.feed] so
/// that [getKudoById] resolves correctly. At least one record has
/// [isAnonymous] = true to exercise the anonymous-sender UI path.
abstract final class KudosDetailMockData {
  // --------------------------------------------------------------------------
  // Detail records — one per feed id (kudo-001 … kudo-005)
  // --------------------------------------------------------------------------

  static final List<KudoDetail> details = [
    KudoDetail(
      id: 'kudo-001',
      senderName: 'Nguyễn Minh Tuấn',
      senderRole: 'Frontend Engineer',
      recipientName: 'Trần Thị Lan',
      recipientRole: 'Product Designer',
      heroTag: HeroTag.risingHero,
      isAnonymous: false,
      imageUrls: const [],
      timeRange: 'Tháng 6, 2025',
      createdAt: DateTime(2025, 6, 15),
      title: 'Rising Hero',
      message:
          'Cảm ơn Lan đã luôn hỗ trợ team trong suốt sprint vừa rồi. '
          'Nhờ có bạn mà UX của sản phẩm cải thiện rõ rệt! '
          'Sự tận tâm và sáng tạo của bạn là nguồn cảm hứng cho cả team.',
      hashtags: const ['#Teamwork', '#Design', '#SunKudos'],
      heartCount: 24,
      linkUrl: 'https://saa2025.sun-asterisk.com/kudos/kudo-001',
    ),
    KudoDetail(
      id: 'kudo-002',
      senderName: 'Lê Văn Hùng',
      senderRole: 'Backend Engineer',
      recipientName: 'Phạm Quốc Bảo',
      recipientRole: 'Tech Lead',
      heroTag: HeroTag.legendHero,
      isAnonymous: false,
      imageUrls: const [],
      timeRange: 'Tháng 6, 2025',
      createdAt: DateTime(2025, 6, 10),
      title: 'Legend Hero',
      message:
          'Bảo đã giúp team giải quyết một vấn đề kỹ thuật cực kỳ phức tạp '
          'trong thời gian kỷ lục. Bạn thực sự là legend! '
          'Không ai khác trong team có thể debug cái race condition đó nhanh như vậy.',
      hashtags: const ['#TechExcellence', '#Leadership', '#SunKudos'],
      heartCount: 47,
      linkUrl: 'https://saa2025.sun-asterisk.com/kudos/kudo-002',
    ),
    // isAnonymous = true — exercises the anonymous-sender UI path (A3 screen).
    KudoDetail(
      id: 'kudo-003',
      senderName: 'Hoàng Thị Mai',
      senderRole: 'QA Engineer',
      recipientName: 'Vũ Thanh Nam',
      recipientRole: 'Mobile Engineer',
      heroTag: HeroTag.risingHero,
      isAnonymous: true,
      imageUrls: const [],
      timeRange: 'Tháng 5, 2025',
      createdAt: DateTime(2025, 5, 28),
      title: 'Rising Hero',
      message:
          'Nam luôn kiên nhẫn giải thích và fix bug nhanh chóng. '
          'Cảm ơn bạn đã giúp team release đúng hạn! '
          'Bạn là người không thể thiếu trong mỗi sprint.',
      hashtags: const ['#Collaboration', '#Mobile', '#SunKudos'],
      heartCount: 18,
      linkUrl: 'https://saa2025.sun-asterisk.com/kudos/kudo-003',
    ),
    KudoDetail(
      id: 'kudo-004',
      senderName: 'Đặng Hữu Phúc',
      senderRole: 'Project Manager',
      recipientName: 'Nguyễn Thị Thu',
      recipientRole: 'Business Analyst',
      heroTag: HeroTag.legendHero,
      isAnonymous: false,
      imageUrls: const [],
      timeRange: 'Tháng 5, 2025',
      createdAt: DateTime(2025, 5, 20),
      title: 'Legend Hero',
      message:
          'Thu đã phân tích yêu cầu rất chi tiết và rõ ràng, '
          'giúp cả team hiểu đúng mục tiêu ngay từ đầu. '
          'Tài liệu spec của Thu luôn là chuẩn mực để cả team tham khảo.',
      hashtags: const ['#Analysis', '#Clarity', '#SunKudos'],
      heartCount: 31,
      linkUrl: 'https://saa2025.sun-asterisk.com/kudos/kudo-004',
    ),
    KudoDetail(
      id: 'kudo-005',
      senderName: 'Trương Văn Khoa',
      senderRole: 'DevOps Engineer',
      recipientName: 'Bùi Thị Hương',
      recipientRole: 'Scrum Master',
      heroTag: HeroTag.newHero,
      isAnonymous: false,
      imageUrls: const [],
      timeRange: 'Tháng 4, 2025',
      createdAt: DateTime(2025, 4, 14),
      title: 'New Hero',
      message:
          'Hương đã tổ chức retrospective rất hiệu quả và '
          'giúp cả team cải tiến quy trình đáng kể. '
          'Nhờ có Hương, team đã giảm được 30% thời gian trong các buổi họp.',
      hashtags: const ['#Agile', '#Process', '#SunKudos'],
      heartCount: 15,
      linkUrl: 'https://saa2025.sun-asterisk.com/kudos/kudo-005',
    ),
  ];

  // --------------------------------------------------------------------------
  // Mock Sunner list for recipient search (excludes the "current user")
  //
  // The stub treats 'Nguyễn Minh Tuấn' as the current user and omits them
  // from search results (see stub/fake repo implementations).
  // --------------------------------------------------------------------------

  static const List<KudoRecipient> sunners = [
    KudoRecipient(
      name: 'Trần Thị Lan',
      role: 'Product Designer',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Phạm Quốc Bảo',
      role: 'Tech Lead',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Vũ Thanh Nam',
      role: 'Mobile Engineer',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Nguyễn Thị Thu',
      role: 'Business Analyst',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Bùi Thị Hương',
      role: 'Scrum Master',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Lê Văn Hùng',
      role: 'Backend Engineer',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Đặng Hữu Phúc',
      role: 'Project Manager',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Trương Văn Khoa',
      role: 'DevOps Engineer',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Hoàng Thị Mai',
      role: 'QA Engineer',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Nguyễn Văn An',
      role: 'Frontend Engineer',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Lê Thị Bích',
      role: 'UI/UX Designer',
      giftDescription: '',
    ),
    KudoRecipient(
      name: 'Phạm Minh Đức',
      role: 'Backend Engineer',
      giftDescription: '',
    ),
  ];

  // --------------------------------------------------------------------------
  // Stub "current user" name — excluded from searchRecipients results.
  // --------------------------------------------------------------------------

  static const String currentUserName = 'Nguyễn Minh Tuấn';

  // --------------------------------------------------------------------------
  // Derived filter values — distinct hashtags and departments from details.
  // --------------------------------------------------------------------------

  static List<String> get hashtags => details
      .expand((d) => d.hashtags)
      .toSet()
      .toList()
    ..sort();

  static List<String> get departments => details
      .expand((d) => [d.senderRole, d.recipientRole])
      .toSet()
      .toList()
    ..sort();
}

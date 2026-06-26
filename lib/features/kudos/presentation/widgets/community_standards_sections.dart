import 'package:flutter/material.dart';

// TODO(l10n): move all VN string literals below to app_localizations.arb

// ---------------------------------------------------------------------------
// Shared design tokens
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFFFEA9E);

// ---------------------------------------------------------------------------
// Section B — Tiêu chuẩn cộng đồng
// ---------------------------------------------------------------------------

class CommunityStandardsSection extends StatelessWidget {
  const CommunityStandardsSection({super.key});

  // TODO(l10n): move all string literals in this section to arb

  static const Color _bodyText = Colors.white;

  // Numbered criteria extracted verbatim from Figma design (spec B, node 6885:10848).
  static const List<String> _criteria = [
    // TODO(l10n): move to arb key `communityStandardsCriterion1`
    'Sử dụng từ ngữ thô tục, chửi bậy, hay có nội dung xúc phạm, bôi nhọ.',
    // TODO(l10n): move to arb key `communityStandardsCriterion2`
    'Đề cập đến các vấn đề chính trị, tôn giáo, phân biệt giới tính.',
    // TODO(l10n): move to arb key `communityStandardsCriterion3`
    'Chứa số liệu cụ thể (doanh thu, hợp đồng, KPI, khách hàng, mã dự án, số tài khoản...).',
    // TODO(l10n): move to arb key `communityStandardsCriterion4`
    'Đề cập tên đối tác, khách hàng, tổ chức bên ngoài.',
    // TODO(l10n): move to arb key `communityStandardsCriterion5`
    'Chứa thông tin cá nhân (email, số điện thoại, địa chỉ, thông tin gia đình).',
    // TODO(l10n): move to arb key `communityStandardsCriterion6`
    'Gửi lặp lại 3+ tin nhắn có nội dung tương tự nhau trong thời gian ngắn.',
    // TODO(l10n): move to arb key `communityStandardsCriterion7`
    'Nội dung Kudos quá ngắn (dưới 30 kí tự), không có ngữ cảnh ("Cảm ơn nhiều", "Thanks nhé", "Good job!").',
    // TODO(l10n): move to arb key `communityStandardsCriterion8`
    'Gửi cho quá nhiều người/nhóm người trong thời gian ngắn (<3s/lời nhắn).',
    // TODO(l10n): move to arb key `communityStandardsCriterion9`
    'Ngôn từ spam (chỉ chứa ký tự như "!", "...", hay ký tự không có nội dung).',
    // TODO(l10n): move to arb key `communityStandardsCriterion10`
    'Mức độ "tim" tăng đột biến bất thường (theo hành vi người dùng trung bình).',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          // TODO(l10n): AppLocalizations.of(context).communityStandardsHeading
          'Tiêu chuẩn cộng đồng',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _kGold,
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          // TODO(l10n): AppLocalizations.of(context).communityStandardsIntro
          'Tiêu chuẩn Cộng đồng (Community Standards) được xây dựng nhằm đảm bảo '
          'một môi trường văn minh, an toàn và tích cực cho tất cả thành viên tham '
          'gia phong trào ghi nhận, cảm ơn Sun* Kudos.',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _kGold,
            height: 20 / 13,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          // TODO(l10n): AppLocalizations.of(context).communityStandardsWarning
          'Các nội dung phát hiện có một trong những tiêu chí vi phạm bên dưới sẽ '
          'được gắn nhãn Spam và được hệ thống chủ động ẩn.',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: _bodyText,
            height: 20 / 13,
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _criteria.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CommunityStandardsNumberedItem(
              number: i + 1,
              text: _criteria[i],
            ),
          ),
      ],
    );
  }
}

/// Single numbered list item — number + text inline.
class CommunityStandardsNumberedItem extends StatelessWidget {
  const CommunityStandardsNumberedItem({
    super.key,
    required this.number,
    required this.text,
  });

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Text(
            '$number.',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 20 / 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 20 / 13,
            ),
          ),
        ),
      ],
    );
  }
}

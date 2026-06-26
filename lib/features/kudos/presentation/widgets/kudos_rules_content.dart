import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Design tokens (shared within this file)
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFFFEA9E);
const Color _kDividerLine = Color(0xFF2E3940);

// ---------------------------------------------------------------------------
// Section label — "Sun* Annual Awards 2025 / THỂ LỆ"
// ---------------------------------------------------------------------------

/// Eyebrow + gold title header matching the design's section label pattern.
class KudosRulesSectionLabel extends StatelessWidget {
  const KudosRulesSectionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Sun* Annual Awards 2025', // TODO(l10n): move to arb
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 1, color: _kDividerLine)),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'THỂ LỆ', // TODO(l10n): move to arb
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: _kGold,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Rules content card — description + participation steps
// ---------------------------------------------------------------------------

/// Card with "Sun* Kudos là gì?" + "Cách tham gia" bullet list.
class KudosRulesCard extends StatelessWidget {
  const KudosRulesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1E29),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kDividerLine, width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sun* Kudos là gì?', // TODO(l10n): move to arb
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _kGold,
              height: 22 / 16,
            ),
          ),
          SizedBox(height: 12),
          Text(
            // TODO(l10n): move to arb
            'Sun* Kudos là chương trình ghi nhận và tôn vinh những đóng góp '
            'xuất sắc của các thành viên trong cộng đồng Sun*. Thông qua việc '
            'gửi Kudos, bạn có thể bày tỏ sự trân trọng và cảm ơn đồng nghiệp '
            'vì những đóng góp ý nghĩa của họ.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 20 / 14,
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(height: 16),
          _HorizontalDivider(),
          SizedBox(height: 16),
          Text(
            'Cách tham gia', // TODO(l10n): move to arb
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _kGold,
              height: 22 / 16,
            ),
          ),
          SizedBox(height: 12),
          _BulletItem('Đăng nhập vào ứng dụng Sun* Annual Awards 2025.'), // TODO(l10n)
          SizedBox(height: 8),
          _BulletItem('Chọn "Viết KUDOS" để gửi lời khen đến đồng nghiệp.'), // TODO(l10n)
          SizedBox(height: 8),
          _BulletItem('Chọn người nhận, nhập tiêu đề, nội dung và hashtag phù hợp.'), // TODO(l10n)
          SizedBox(height: 8),
          _BulletItem('Mỗi thành viên có thể gửi tối đa 5 Kudos mỗi tuần.'), // TODO(l10n)
          SizedBox(height: 8),
          _BulletItem('Kudos được gửi sẽ hiển thị trên bảng tin và được tính vào kết quả bình chọn.'), // TODO(l10n)
        ],
      ),
    );
  }
}

class _HorizontalDivider extends StatelessWidget {
  const _HorizontalDivider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: _kDividerLine);
}

class _BulletItem extends StatelessWidget {
  const _BulletItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: CircleAvatar(radius: 3, backgroundColor: _kGold),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 20 / 14,
            ),
          ),
        ),
      ],
    );
  }
}

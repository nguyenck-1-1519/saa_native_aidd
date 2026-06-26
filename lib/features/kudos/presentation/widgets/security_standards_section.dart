import 'package:flutter/material.dart';

// TODO(l10n): move all VN string literals below to app_localizations.arb

// ---------------------------------------------------------------------------
// Shared design token
// ---------------------------------------------------------------------------
const Color _kGold = Color(0xFFFFEA9E);

// ---------------------------------------------------------------------------
// Section C — Tiêu chuẩn bảo mật
// ---------------------------------------------------------------------------

class SecurityStandardsSection extends StatelessWidget {
  const SecurityStandardsSection({super.key});

  // TODO(l10n): move all string literals in this section to arb

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          // TODO(l10n): AppLocalizations.of(context).securityStandardsHeading
          'Tiêu chuẩn bảo mật',
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
          // TODO(l10n): AppLocalizations.of(context).securityStandardsIntro
          'Sunner cam kết bảo vệ thông tin. Mọi thành viên có trách nhiệm bảo mật '
          'nội dung chia sẻ trên hệ thống.',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _kGold,
            height: 20 / 13,
          ),
        ),
        const SizedBox(height: 12),
        const SecurityStandardsBulletItem(
          // TODO(l10n): AppLocalizations.of(context).securityStandardsInfoSecurity
          text: 'Bảo mật Thông tin: Toàn bộ thông tin Sunner chia sẻ sẽ được bảo '
              'mật trên hệ thống.',
        ),
        const SizedBox(height: 8),
        const SecurityStandardsBulletItem(
          // TODO(l10n): AppLocalizations.of(context).securityStandardsSharingScope
          text: 'Phạm vi Chia sẻ: Toàn bộ thông tin nhân sự và dự án trong hệ thống '
              'được bảo mật. Sunner vui lòng chỉ chia sẻ trong nội bộ Sun*.',
        ),
        const SizedBox(height: 12),
        const Text(
          // TODO(l10n): AppLocalizations.of(context).securityStandardsContact
          'Liên hệ Hỗ trợ: Mọi thắc mắc, Sunner vui lòng liên hệ đại diện BTC SAA: '
          'Slack duong.thi.thuy.an để được hỗ trợ.',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _kGold,
            height: 20 / 13,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFFFFEA9E),
          ),
        ),
      ],
    );
  }
}

/// Single bullet-point item with a leading "•" dot.
class SecurityStandardsBulletItem extends StatelessWidget {
  const SecurityStandardsBulletItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3, right: 8),
          child: Text(
            '•',
            style: TextStyle(
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

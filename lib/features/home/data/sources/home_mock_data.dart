import '../../domain/entities/award_card.dart';

/// Design-sourced award content — strings taken verbatim from the MoMorph
/// design (spec §3 mock list). Do NOT invent copy here.
///
/// [imageRef] values are asset paths under `assets/images/home/`; Track A
/// extracts the actual image files and the UI widget references them by name.
abstract final class HomeMockData {
  static const List<AwardCard> awards = [
    AwardCard(
      id: 'award-top-talent',
      name: 'Top Talent',
      description:
          'Vinh danh những cá nhân xuất sắc, có đóng góp nổi bật cho Sun*.',
      imageRef: 'assets/images/home/Award_BG.png',
    ),
    AwardCard(
      id: 'award-top-project',
      name: 'Top Project',
      description:
          'Ghi nhận những dự án tiêu biểu, mang lại giá trị vượt trội.',
      imageRef: 'assets/images/home/Award_BG.png',
    ),
    AwardCard(
      id: 'award-third',
      name: 'Root Further',
      description:
          'Tôn vinh tinh thần phát triển bền vững và lan tỏa giá trị cốt lõi.',
      imageRef: 'assets/images/home/Award_BG_3.png',
    ),
  ];
}

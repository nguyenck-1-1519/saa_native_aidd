import '../../domain/entities/award_detail.dart';

/// Design-sourced mock data for the 5 SAA 2025 award categories.
///
/// All string values come directly from MoMorph design specs — no invented
/// copy. Badge image refs point at asset paths agreed with Track A.
///
/// Top Talent and MVP: spec screenIds c-QM3_zjkG and b2BuS8HYIt.
/// Top Project Leader: spec screenId QQvsfK3yaK — quantity 03, prize 7.000.000 VNĐ.
/// Best Manager: spec screenId 7y195PPTxQ — quantity 01, prize 10.000.000 VNĐ.
/// Signature 2025 - Creator: spec screenId O98TwiHaJe — dual prize (individual + team).
///   prizeValue uses the individual prize (5.000.000 VNĐ); prizeNote captures both tiers.
abstract final class AwardsDetailMockData {
  static const List<AwardDetail> awards = [
    AwardDetail(
      id: 'top-talent',
      name: 'Top Talent',
      description:
          'Giải thưởng Top Talent vinh danh những cá nhân xuất sắc toàn diện'
          ' – người hội tụ năng lực chuyên môn vượt trội, tinh thần học hỏi'
          ' bền bỉ và tầm ảnh hưởng tích cực đến tập thể. Họ không chỉ đạt'
          ' kết quả xuất sắc trong công việc mà còn là người truyền cảm hứng,'
          ' nâng tầm đội nhóm và góp phần lan toả văn hoá Sun* mỗi ngày.',
      badgeImageRef: 'assets/images/awards/top_talent_badge.png',
      quantityValue: '10',
      quantityUnit: 'Cá nhân',
      prizeValue: '7.000.000 VNĐ',
      prizeNote: 'cho mỗi giải thưởng',
    ),
    AwardDetail(
      id: 'top-project-leader',
      name: 'Top Project Leader',
      description:
          'Giải thưởng Top Project Leader vinh danh những nhà quản lý dự án'
          ' xuất sắc – những người hội tụ năng lực quản lý vững vàng, khả'
          ' năng truyền cảm hứng mạnh mẽ, và tư duy "Aim High – Be Agile"'
          ' trong mọi bài toán và bối cảnh.',
      badgeImageRef: 'assets/images/awards/top_project_leader_badge.png',
      quantityValue: '03',
      quantityUnit: 'Cá nhân',
      prizeValue: '7.000.000 VNĐ',
      prizeNote: 'cho mỗi giải thưởng',
    ),
    AwardDetail(
      id: 'best-manager',
      name: 'Best Manager',
      description:
          'Giải thưởng Best Manager vinh danh những nhà lãnh đạo tiêu biểu'
          ' – người đã dẫn dắt đội ngũ của mình tạo ra kết quả vượt kỳ'
          ' vọng, tác động nổi bật đến hiệu quả kinh doanh và sự phát triển'
          ' bền vững của tổ chức.',
      badgeImageRef: 'assets/images/awards/best_manager_badge.png',
      quantityValue: '01',
      quantityUnit: 'Cá nhân',
      prizeValue: '10.000.000 VNĐ',
      prizeNote: 'cho mỗi giải thưởng',
    ),
    AwardDetail(
      id: 'signature-creator',
      name: 'Signature 2025 - Creator',
      description:
          'Giải thưởng Signature vinh danh cá nhân hoặc tập thể thể hiện'
          ' tinh thần đặc trưng mà Sun* hướng tới trong từng thời kỳ. Trong'
          ' năm 2025, giải thưởng Signature vinh danh Creator – cá nhân/tập'
          ' thể mang tư duy chủ động và nhạy bén, luôn nhìn thấy cơ hội'
          ' trong thách thức và tiên phong trong hành động.',
      badgeImageRef: 'assets/images/awards/badge_name_signature_creator.svg',
      quantityValue: '01',
      quantityUnit: 'Cá nhân hoặc tập thể',
      // Individual prize shown as primary value; team prize captured in note.
      prizeValue: '5.000.000 VNĐ',
      prizeNote: 'cho giải cá nhân · 8.000.000 VNĐ cho giải tập thể',
    ),
    AwardDetail(
      id: 'mvp',
      name: 'MVP (Most Valuable Person)',
      description:
          'Giải thưởng MVP vinh danh cá nhân xuất sắc nhất năm – gương mặt'
          ' tiêu biểu đại diện cho toàn bộ tập thể Sun*. Họ là người đã thể'
          ' hiện năng lực vượt trội, tinh thần cống hiến bền bỉ, và tầm ảnh'
          ' hưởng sâu rộng, để lại dấu ấn mạnh mẽ trong hành trình của Sun*'
          ' suốt năm qua. Không chỉ nổi bật bởi hiệu suất và kết quả công'
          ' việc, họ còn là nguồn cảm hứng lan toả – thông qua suy nghĩ,'
          ' hành động và ảnh hưởng tích cực của mình đối với tập thể. MVP là'
          ' người hội tụ đầy đủ phẩm chất của người Sun* ưu tú, đồng thời'
          ' mang trên mình trọng trách lớn lao: trở thành hình mẫu đại diện'
          ' cho con người và tinh thần Sun*, góp phần dẫn dắt tập thể vươn'
          ' tới những đỉnh cao mới.',
      badgeImageRef: 'assets/images/awards/mvp_badge.png',
      quantityValue: '01',
      quantityUnit: 'Cá nhân',
      prizeValue: '15.000.000 VNĐ',
      prizeNote: 'cho giải cá nhân',
    ),
  ];
}

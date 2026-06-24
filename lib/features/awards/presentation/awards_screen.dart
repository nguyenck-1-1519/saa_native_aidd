import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/presentation/widgets/home_header.dart';
import '../../home/presentation/widgets/kudos_section.dart';
import '../domain/entities/award_detail.dart';
import 'widgets/award_detail_block.dart';
import 'widgets/award_highlight_header.dart';
import 'widgets/kudos_kv_banner.dart';

// ---------------------------------------------------------------------------
// Mock data — extracted verbatim from MoMorph design nodes.
// Integration (Track B) replaces this with a provider/repository.
// ---------------------------------------------------------------------------

const _kTopTalent = AwardDetail(
  id: 'top-talent',
  name: 'Top Talent',
  description:
      'Giải thưởng Top Talent vinh danh những cá nhân xuất sắc toàn diện – những người không ngừng khẳng định năng lực chuyên môn vững vàng, hiệu suất công việc vượt trội, luôn mang lại giá trị vượt kỳ vọng, được đánh giá cao bởi khách hàng và đồng đội. Với tinh thần sẵn sàng nhận mọi nhiệm vụ tổ chức giao phó, họ luôn là nguồn cảm hứng, thúc đẩy động lực và tạo ảnh hưởng tích cực đến cả tập thể.',
  badgeImageRef: 'assets/images/home/Top_Talent.png',
  quantityValue: '10',
  quantityUnit: 'Cá nhân',
  prizeValue: '7.000.000 VNĐ',
  prizeNote: 'cho mỗi giải thưởng',
);

const _kTopProjectLeader = AwardDetail(
  id: 'top-project-leader',
  name: 'Top Project Leader',
  description:
      'Giải thưởng Top Project Leader vinh danh những nhà quản lý dự án xuất sắc – những người hội tụ năng lực quản lý vững vàng, khả năng truyền cảm hứng mạnh mẽ, và tư duy "Aim High – Be Agile" trong mọi bài toán và bối cảnh. Dưới sự dẫn dắt của họ, các thành viên không chỉ cùng nhau vượt qua thử thách và đạt được mục tiêu đề ra, mà còn giữ vững ngọn lửa nhiệt huyết, tinh thần Wasshoi, và trưởng thành để trở thành phiên bản tinh hoa – hạnh phúc hơn của chính mình.',
  badgeImageRef: 'assets/images/home/Top_Project.png',
  quantityValue: '03',
  quantityUnit: 'Cá nhân',
  prizeValue: '7.000.000 VNĐ',
  prizeNote: 'cho mỗi giải thưởng',
);

const _kBestManager = AwardDetail(
  id: 'best-manager',
  name: 'Best Manager',
  description:
      'Giải thưởng Best Manager vinh danh những nhà lãnh đạo tiêu biểu – người đã dẫn dắt đội ngũ của mình tạo ra kết quả vượt kỳ vọng, tác động nổi bật đến hiệu quả kinh doanh và sự phát triển bền vững của tổ chức. Dưới sự lãnh đạo của họ, đội ngũ luôn chinh phục và làm chủ mọi mục tiêu bằng năng lực đa nhiệm, khả năng phối hợp hiệu quả, và tư duy ứng dụng công nghệ linh hoạt trong kỷ nguyên số. Họ truyền cảm hứng để tập thể trở nên tự tin tràn đầy năng lượng, sẵn sàng đón nhận, thậm chí dẫn dắt tạo ra những thay đổi có tính cách mạng.',
  // Badge name image not available in Figma cloud (null S3 URL) — falls back to text in AwardDetailBlock.
  badgeImageRef: '',
  quantityValue: '01',
  quantityUnit: 'Cá nhân',
  prizeValue: '10.000.000 VNĐ',
  prizeNote: 'cho mỗi giải thưởng',
);

const _kSignatureCreator = AwardDetail(
  id: 'signature-creator',
  name: 'Signature 2025 - Creator',
  description:
      'Giải thưởng Signature vinh danh cá nhân hoặc tập thể thể hiện tinh thần đặc trưng mà Sun* hướng tới trong từng thời kỳ.  Trong năm 2025, giải thưởng Signature vinh danh Creator - cá nhân/tập thể mang tư duy chủ động và nhạy bén, luôn nhìn thấy cơ hội trong thách thức và tiên phong trong hành động. Họ là những người nhạy bén với vấn đề, nhanh chóng nhận diện và đưa ra những giải pháp thực tiễn, mang lại giá trị rõ rệt cho dự án, khách hàng hoặc tổ chức. Với tư duy kiến tạo và tinh thần "Creator" đặc trưng của Sun*, họ không chỉ phản ứng tích cực trước sự thay đổi mà còn chủ động tạo ra cải tiến, góp phần định hình chuẩn mực mới cho cách mà người Sun* tạo giá trị.',
  badgeImageRef: 'assets/images/awards/badge_name_signature_creator.svg',
  quantityValue: '01',
  quantityUnit: 'Cá nhân hoặc tập thể',
  prizeValue: '5.000.000 VNĐ',
  prizeNote: 'cho giải cá nhân',
);

const _kMvp = AwardDetail(
  id: 'mvp',
  name: 'MVP (Most Valuable Person)',
  description:
      'Giải thưởng MVP vinh danh cá nhân xuất sắc nhất năm – gương mặt tiêu biểu đại diện cho toàn bộ tập thể Sun*. Họ là người đã thể hiện năng lực vượt trội, tinh thần cống hiến bền bỉ, và tầm ảnh hưởng sâu rộng, để lại dấu ấn mạnh mẽ trong hành trình của Sun* suốt năm qua.  Không chỉ nổi bật bởi hiệu suất và kết quả công việc, họ còn là nguồn cảm hứng lan tỏa – thông qua suy nghĩ, hành động và ảnh hưởng tích cực của mình đối với tập thể. MVP là người hội tụ đầy đủ phẩm chất của người Sun* ưu tú, đồng thời mang trên mình trọng trách lớn lao: trở thành hình mẫu đại diện cho con người và tinh thần Sun*, góp phần dẫn dắt tập thể vươn tới những đỉnh cao mới.',
  // Badge name image not available in Figma cloud (null S3 URL) — falls back to text in AwardDetailBlock.
  badgeImageRef: '',
  quantityValue: '01',
  quantityUnit: 'Cá nhân',
  prizeValue: '15.000.000 VNĐ',
  prizeNote: 'cho giải cá nhân',
);

const _kMockAwards = <AwardDetail>[
  _kTopTalent,
  _kTopProjectLeader,
  _kBestManager,
  _kSignatureCreator,
  _kMvp,
];

// ---------------------------------------------------------------------------
// Selected-award provider — Track B replaces with selectedAwardProvider.
// ---------------------------------------------------------------------------

final _selectedAwardIdProvider = StateProvider<String>(
  (ref) => _kMockAwards.first.id,
);

// ---------------------------------------------------------------------------
// AwardsScreen
// ---------------------------------------------------------------------------

/// Awards tab screen (F003) — "Hệ thống giải thưởng SAA 2025".
///
/// Prop contract for integration (Track B wires these):
///   - Replace [_kMockAwards] with provider-driven List of AwardDetail.
///   - Replace [_selectedAwardIdProvider] with selectedAwardProvider.
///   - HomeHeader: wire onSearch / onBell / unreadCount from providers.
///   - KudosSection: wire onDetail → /kudos-detail route.
///
/// Bottom nav is provided by the shell StatefulShellRoute — do NOT add one here.
class AwardsScreen extends ConsumerWidget {
  const AwardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(_selectedAwardIdProvider);
    final selected = _kMockAwards.firstWhere(
      (a) => a.id == selectedId,
      orElse: () => _kMockAwards.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF00101A),
      body: Stack(
        children: [
          // Background: Keyvisual_BG (reuse home asset) — positioned to the right
          // per design: bg group starts at x=601 (design 1114px wide, screen 375px)
          Positioned(
            right: -506,
            top: 0,
            child: Image.asset(
              'assets/images/home/Keyvisual_BG.png',
              width: 881,
              height: 723,
              fit: BoxFit.cover,
            ),
          ),
          // Left shadow gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.186, 0.772],
                  colors: [
                    Color(0xFF00101A),
                    Color(0xFF10181F),
                    Color(0x0000101A),
                  ],
                ),
              ),
            ),
          ),
          // Scrollable content
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HomeHeader(
                  onSearch: null,
                  onBell: null,
                  unreadCount: 0,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // mms_A — Kudos KV banner (static)
                      const KudosKvBanner(),
                      const SizedBox(height: 38),
                      // mms_B — Highlight header + dropdown
                      AwardHighlightHeader(
                        awards: _kMockAwards,
                        selected: selected,
                        onSelect: (id) =>
                            ref.read(_selectedAwardIdProvider.notifier).state =
                                id,
                      ),
                      const SizedBox(height: 40),
                      // mms_2.3 — Award detail block
                      AwardDetailBlock(award: selected),
                      const SizedBox(height: 40),
                      // mms_2.4 — Sun* Kudos section (reused from Home)
                      KudosSection(
                        onDetail: null, // integration wires to /kudos-detail
                      ),
                      // Bottom padding: 72px shell nav + 24px breathing room
                      const SizedBox(height: 96),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

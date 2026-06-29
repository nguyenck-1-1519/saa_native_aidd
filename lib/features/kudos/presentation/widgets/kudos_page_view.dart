import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/kudo.dart';
import 'kudos_card.dart';

/// Paginated PageView of [KudosCard]s with overlaid ◀ ▶ arrows and a
/// "current/total" indicator below.
///
/// Used exclusively by [HighlightKudosCarousel].
/// Arrow dimming uses [gold.withValues(alpha: 0.3)] at boundary pages.
class KudosPageView extends StatelessWidget {
  const KudosPageView({
    super.key,
    required this.kudos,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onPrev,
    required this.onNext,
    required this.gold,
  });

  final List<Kudo> kudos;
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    final dimmedGold = gold.withValues(alpha: 0.3);
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: Stack(
            children: [
              PageView.builder(
                controller: pageController,
                itemCount: kudos.length,
                onPageChanged: onPageChanged,
                // Tighter inter-card gap to match the design (was 20).
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: KudosCard(kudo: kudos[i]),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onPrev,
                    child: Icon(
                      Icons.chevron_left,
                      size: 32,
                      color: currentPage > 0 ? gold : dimmedGold,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onNext,
                    child: Icon(
                      Icons.chevron_right,
                      size: 32,
                      color: currentPage < kudos.length - 1 ? gold : dimmedGold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${currentPage + 1}/${kudos.length}',
          style: AppTypography.montserrat(
            fontSize: 12,
            weight: FontWeight.w400,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

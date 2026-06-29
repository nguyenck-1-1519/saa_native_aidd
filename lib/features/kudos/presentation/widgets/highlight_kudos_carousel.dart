import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/kudo.dart';
import '../providers/kudos_filter_providers.dart';
import 'kudos_page_view.dart';
import 'kudos_filter_row.dart';

/// Highlight Kudos section: header label, filter dropdowns, and a paginated
/// card carousel.
///
/// Design source: mms_B_Highlight (6885:9084).
///
/// Filtering happens IN PLACE: when a hashtag/department filter is active the
/// carousel shows the filtered list from [allKudosProvider] (reusing the repo
/// filter logic); with no filter it shows the curated [kudos] highlights passed
/// in by the feed. Selecting a filter never navigates away.
class HighlightKudosCarousel extends ConsumerStatefulWidget {
  const HighlightKudosCarousel({super.key, required this.kudos});

  final List<Kudo> kudos;

  @override
  ConsumerState<HighlightKudosCarousel> createState() =>
      _HighlightKudosCarouselState();
}

class _HighlightKudosCarouselState
    extends ConsumerState<HighlightKudosCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  /// Number of cards currently displayed — bounds the prev/next arrows when the
  /// filtered list is shorter than the full highlight list.
  int _displayedCount = 0;

  static const Color _gold = Color(0xFFFFEA9E);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrev() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (_currentPage < _displayedCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(feedFilterControllerProvider);
    final controller = ref.read(feedFilterControllerProvider.notifier);
    final hashtagsAsync = ref.watch(hashtagOptionsProvider);
    final depsAsync = ref.watch(departmentOptionsProvider);

    // A filter being active swaps the curated highlights for the filtered list
    // (allKudosProvider reuses the repo's hashtag/department filter) — in place,
    // no navigation.
    final hasFilter = filter.hashtag != null || filter.department != null;
    final cardsAsync = hasFilter
        ? ref.watch(allKudosProvider)
        : AsyncData<List<Kudo>>(widget.kudos);

    // Reset the carousel to the first card whenever the filter changes.
    ref.listen(feedFilterControllerProvider, (_, __) {
      if (_pageController.hasClients) _pageController.jumpToPage(0);
      setState(() => _currentPage = 0);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderSection(),
        const SizedBox(height: 12),
        KudosFilterRow(
          selectedHashtag: filter.hashtag,
          selectedDepartment: filter.department,
          hashtagOptions: hashtagsAsync.valueOrNull ?? const [],
          departmentOptions: depsAsync.valueOrNull ?? const [],
          onHashtagChanged: controller.setHashtag,
          onDepartmentChanged: controller.setDepartment,
        ),
        const SizedBox(height: 16),
        _buildCards(cardsAsync),
      ],
    );
  }

  Widget _buildCards(AsyncValue<List<Kudo>> cardsAsync) {
    return cardsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'Không tải được Kudos.',
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.white70),
        ),
      ),
      data: (kudos) {
        _displayedCount = kudos.length;
        if (kudos.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Không có Kudo phù hợp bộ lọc.',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.white70),
            ),
          );
        }
        return KudosPageView(
          kudos: kudos,
          pageController: _pageController,
          currentPage: _currentPage.clamp(0, kudos.length - 1),
          onPageChanged: (i) => setState(() => _currentPage = i),
          onPrev: _goToPrev,
          onNext: _goToNext,
          gold: _gold,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  static const Color _separator = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Sun* Annual Awards 2025',
              style: AppTypography.montserrat(
                fontSize: 12,
                weight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 1, color: _separator)),
          ],
        ),
        const SizedBox(height: 4),
        // Section title is white per design (was gold) and rendered at its true
        // weight via the variable-font helper.
        Text(
          'HIGHLIGHT KUDOS',
          style: AppTypography.montserrat(
            fontSize: 22,
            weight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

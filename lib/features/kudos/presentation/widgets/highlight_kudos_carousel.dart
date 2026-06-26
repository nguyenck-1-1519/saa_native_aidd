import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/entities/kudo.dart';
import '../providers/kudos_filter_providers.dart';
import 'kudos_page_view.dart';
import 'kudos_filter_row.dart';

/// Highlight Kudos section: header label, filter dropdowns, and a paginated
/// card carousel.
///
/// Design source: mms_B_Highlight (6885:9084).
///
/// Converted to [ConsumerStatefulWidget] at INT to wire the filter dropdowns
/// to [feedFilterControllerProvider] / option providers.
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

  static const Color _gold = Color(0xFFFFEA9E);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
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
    if (_currentPage < widget.kudos.length - 1) {
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
          onHashtagChanged: (v) {
            controller.setHashtag(v);
            // Navigate to All Kudos to show filtered results
            context.push(Routes.allKudos);
          },
          onDepartmentChanged: (v) {
            controller.setDepartment(v);
            context.push(Routes.allKudos);
          },
        ),
        const SizedBox(height: 16),
        if (widget.kudos.isNotEmpty)
          KudosPageView(
            kudos: widget.kudos,
            pageController: _pageController,
            currentPage: _currentPage,
            onPageChanged: (i) => setState(() => _currentPage = i),
            onPrev: _goToPrev,
            onNext: _goToNext,
            gold: _gold,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _separator = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Sun* Annual Awards 2025',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 1, color: _separator)),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'HIGHLIGHT KUDOS',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: _gold,
          ),
        ),
      ],
    );
  }
}


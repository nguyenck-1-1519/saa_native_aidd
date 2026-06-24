import 'package:flutter/material.dart';
import '../../domain/entities/kudo.dart';
import 'kudos_page_view.dart';

/// Highlight Kudos section: header label, filter dropdowns, and a paginated
/// card carousel.
///
/// Design source: mms_B_Highlight (6885:9084).
class HighlightKudosCarousel extends StatefulWidget {
  const HighlightKudosCarousel({super.key, required this.kudos});

  final List<Kudo> kudos;

  @override
  State<HighlightKudosCarousel> createState() => _HighlightKudosCarouselState();
}

class _HighlightKudosCarouselState extends State<HighlightKudosCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _border = Color(0xFF998C5F);
  static const Color _dropdownBg = Color(0x1AFFEA9E);

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HeaderSection(),
        const SizedBox(height: 12),
        _FilterRow(border: _border, dropdownBg: _dropdownBg),
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

// ---------------------------------------------------------------------------
// Filter row
// ---------------------------------------------------------------------------

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.border, required this.dropdownBg});

  final Color border;
  final Color dropdownBg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(label: 'Hashtag', border: border, bg: dropdownBg),
        const SizedBox(width: 8),
        _FilterChip(label: 'Phòng ban', border: border, bg: dropdownBg),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.border,
    required this.bg,
  });

  final String label;
  final Color border;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.white),
        ],
      ),
    );
  }
}

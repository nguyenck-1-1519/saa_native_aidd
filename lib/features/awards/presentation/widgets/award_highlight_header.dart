import 'package:flutter/material.dart';
import '../../domain/entities/award_detail.dart';
import 'award_dropdown.dart';

/// Section mms_B_Highlight (335×137px from MoMorph).
///
/// Layout (column, gap 24):
///   mms_B.1_header (column, gap 16):
///     header instance (column, gap 4):
///       "Sun* Annual Awards 2025" — Montserrat 12 w400 white
///       1px divider #2E3940
///       "Hệ thống giải thưởng\nSAA 2025" — Montserrat 22 w500 gold (247×56)
///     filter row (gap 4):
///       AwardDropdown
class AwardHighlightHeader extends StatelessWidget {
  const AwardHighlightHeader({
    super.key,
    required this.awards,
    required this.selected,
    this.onSelect,
  });

  final List<AwardDetail> awards;
  final AwardDetail selected;
  final ValueChanged<String>? onSelect;

  static const _gold = Color(0xFFFFEA9E);
  static const _white = Colors.white;
  static const _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Sun* Annual Awards 2025" label
          Text(
            'Sun* Annual Awards 2025',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _white,
              height: 16 / 12,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: _divider, thickness: 1, height: 1),
          const SizedBox(height: 4),
          // Main title — 247×56, Montserrat 22 w500 gold, 2 lines
          const SizedBox(
            width: 247,
            child: Text(
              'Hệ thống giải thưởng \nSAA 2025',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: _gold,
                height: 28 / 22,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Dropdown row
          AwardDropdown(
            awards: awards,
            selected: selected,
            onSelect: onSelect,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/award_detail.dart';

/// Dropdown button showing the currently selected award name.
///
/// From MoMorph mms_B.1_header → filter → dropdown node:
///   border: 1px solid #998C5F
///   background: rgba(255, 234, 158, 0.10)
///   borderRadius: 4px
///   padding: 8px
///   width: flexible (160–248px depending on award screen)
///
/// Taps open an overlay/modal bottom sheet listing all [awards].
class AwardDropdown extends StatelessWidget {
  const AwardDropdown({
    super.key,
    required this.awards,
    required this.selected,
    this.onSelect,
  });

  final List<AwardDetail> awards;
  final AwardDetail selected;
  final ValueChanged<String>? onSelect;

  static const _borderColor = Color(0xFF998C5F);
  static const _bgColor = Color(0x1AFFEA9E); // 10% of #FFEA9E
  static const _textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _bgColor,
          border: Border.all(color: _borderColor, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.name,
              style: AppTypography.montserrat(
                fontSize: 14,
                weight: FontWeight.w400,
                color: _textColor,
                height: 20 / 14,
                letterSpacing: 0.25,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: _textColor, size: 24),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0A1820),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _DropdownSheet(
        awards: awards,
        selectedId: selected.id,
        onSelect: (id) {
          Navigator.of(ctx).pop();
          onSelect?.call(id);
        },
      ),
    );
  }
}

class _DropdownSheet extends StatelessWidget {
  const _DropdownSheet({
    required this.awards,
    required this.selectedId,
    required this.onSelect,
  });

  final List<AwardDetail> awards;
  final String selectedId;
  final ValueChanged<String> onSelect;

  static const _gold = Color(0xFFFFEA9E);
  static const _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ...awards.map((a) => Column(
                children: [
                  InkWell(
                    onTap: () => onSelect(a.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              a.name,
                              style: AppTypography.montserrat(
                                fontSize: 14,
                                weight: a.id == selectedId
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: a.id == selectedId ? _gold : Colors.white,
                                height: 20 / 14,
                              ),
                            ),
                          ),
                          if (a.id == selectedId)
                            const Icon(Icons.check, color: _gold, size: 18),
                        ],
                      ),
                    ),
                  ),
                  if (awards.last != a)
                    const Divider(
                        color: _divider, thickness: 1, height: 1,
                        indent: 20, endIndent: 20),
                ],
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

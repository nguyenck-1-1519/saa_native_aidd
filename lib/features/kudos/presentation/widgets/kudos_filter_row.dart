import 'package:flutter/material.dart';

/// Reusable filter row for Kudos screens — two dropdown chips:
/// Hashtag and Phòng ban (department).
///
/// Design source: node filter row (mms_B_Highlight + All Kudos screen).
/// Colors: border #998C5F, bg rgba(#FFEA9E, 10%) ≈ 0x1AFFEA9E, text white.
///
/// Pass non-empty [hashtagOptions] / [departmentOptions] to enable a modal
/// bottom-sheet picker on tap. Empty lists render the chip as tappable but
/// with no options shown. Callbacks fire with the selected value (or null to
/// clear the filter).
class KudosFilterRow extends StatelessWidget {
  const KudosFilterRow({
    super.key,
    this.selectedHashtag,
    this.selectedDepartment,
    this.hashtagOptions = const [],
    this.departmentOptions = const [],
    this.onHashtagChanged,
    this.onDepartmentChanged,
  });

  final String? selectedHashtag;
  final String? selectedDepartment;
  final List<String> hashtagOptions;
  final List<String> departmentOptions;
  final ValueChanged<String?>? onHashtagChanged;
  final ValueChanged<String?>? onDepartmentChanged;

  static const Color _border = Color(0xFF998C5F);
  static const Color _dropdownBg = Color(0x1AFFEA9E);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          label: selectedHashtag ?? 'Hashtag',
          border: _border,
          bg: _dropdownBg,
          isActive: selectedHashtag != null,
          onTap: onHashtagChanged != null
              ? () => _showPicker(
                    context,
                    title: 'Hashtag',
                    options: hashtagOptions,
                    selected: selectedHashtag,
                    onSelected: onHashtagChanged!,
                  )
              : null,
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: selectedDepartment ?? 'Phòng ban',
          border: _border,
          bg: _dropdownBg,
          isActive: selectedDepartment != null,
          onTap: onDepartmentChanged != null
              ? () => _showPicker(
                    context,
                    title: 'Phòng ban',
                    options: departmentOptions,
                    selected: selectedDepartment,
                    onSelected: onDepartmentChanged!,
                  )
              : null,
        ),
      ],
    );
  }

  /// Shows a modal bottom sheet with the available filter options.
  /// Tapping an item fires [onSelected] with the value; a "Tất cả" row clears
  /// the filter (fires with null).
  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF001525),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _FilterPickerSheet(
        title: title,
        options: options,
        selected: selected,
        onSelected: (v) {
          Navigator.pop(context);
          onSelected(v);
        },
      ),
    );
  }
}

/// Bottom-sheet content for selecting a filter option.
class _FilterPickerSheet extends StatelessWidget {
  const _FilterPickerSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  static const Color _gold = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const Divider(color: Color(0xFF2E3940), height: 1),
          // Scrollable so a long option list never overflows the sheet.
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                // "All" option to clear filter
                ListTile(
                  title: const Text(
                    'Tất cả',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  trailing: selected == null
                      ? const Icon(Icons.check, color: _gold, size: 18)
                      : null,
                  onTap: () => onSelected(null),
                ),
                ...options.map(
                  (opt) => ListTile(
                    title: Text(
                      opt,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    trailing: selected == opt
                        ? const Icon(Icons.check, color: _gold, size: 18)
                        : null,
                    onTap: () => onSelected(opt),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.border,
    required this.bg,
    this.isActive = false,
    this.onTap,
  });

  final String label;
  final Color border;
  final Color bg;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0x33FFEA9E) : bg,
          border: Border.all(
            color: isActive ? const Color(0xFFFFEA9E) : border,
            width: 1,
          ),
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
            const Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

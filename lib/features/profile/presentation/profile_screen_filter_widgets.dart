part of 'profile_screen.dart';

// ---------------------------------------------------------------------------
// _KudosFilterDropdown  (design node 6885:10388 / 6885:10419)
// ---------------------------------------------------------------------------

class _KudosFilterDropdown extends StatelessWidget {
  const _KudosFilterDropdown({
    required this.selected,
    required this.kudosReceived,
    required this.kudosSent,
    this.onChanged,
  });

  final KudosFilter selected;
  final int kudosReceived;
  final int kudosSent;
  final ValueChanged<KudosFilter>? onChanged;

  static const Color _border = Color(0xFF998C5F);
  static const Color _bg = Color(0x1AFFEA9E);

  // TODO(l10n): move to arb
  String get _label => selected == KudosFilter.received
      ? 'Đã nhận $kudosReceived kudos'
      : 'Đã gửi ($kudosSent)';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _label,
              style: AppTypography.montserrat(
                fontSize: 14,
                weight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: 0.25,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    if (onChanged == null) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF00101A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => _FilterSheet(
        kudosReceived: kudosReceived,
        kudosSent: kudosSent,
        selected: selected,
        onSelect: (f) {
          Navigator.pop(context);
          onChanged!(f);
        },
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({
    required this.kudosReceived,
    required this.kudosSent,
    required this.selected,
    required this.onSelect,
  });

  final int kudosReceived;
  final int kudosSent;
  final KudosFilter selected;
  final ValueChanged<KudosFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FilterPill(
            // TODO(l10n): move to arb
            label: 'Đã nhận ($kudosReceived)',
            isSelected: selected == KudosFilter.received,
            onTap: () => onSelect(KudosFilter.received),
          ),
          const SizedBox(height: 8),
          _FilterPill(
            // TODO(l10n): move to arb
            label: 'Đã gửi ($kudosSent)',
            isSelected: selected == KudosFilter.sent,
            onTap: () => onSelect(KudosFilter.sent),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _gold = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? _gold.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? _gold : Colors.white38),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w500,
            color: isSelected ? _gold : Colors.white,
          ),
        ),
      ),
    );
  }
}

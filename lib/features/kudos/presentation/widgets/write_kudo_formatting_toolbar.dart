import 'package:flutter/material.dart';

/// Formatting toolbar for the Write Kudo message field.
///
/// Visual-only — buttons render but perform no rich-text editing (YAGNI per
/// F004 spec §3). The "Tiêu chuẩn cộng đồng" link calls [onCommunityStandards].
///
/// Design source: mms_C_Chức năng (6885:9306).
/// Border: 0.447px solid #998C5F. Each icon cell: 24×24 px, padding 4px.
class WriteKudoFormattingToolbar extends StatelessWidget {
  const WriteKudoFormattingToolbar({
    super.key,
    this.onCommunityStandards,
  });

  final VoidCallback? onCommunityStandards;

  static const Color _border = Color(0xFF998C5F);
  static const Color _linkColor = Color(0xFFE46060);
  static const BorderSide _borderSide = BorderSide(color: _border, width: 0.5);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      decoration: const BoxDecoration(
        border: Border(bottom: _borderSide),
      ),
      child: Row(
        children: [
          _ToolbarButton(icon: Icons.format_bold, isFirst: true),
          _ToolbarButton(icon: Icons.format_italic),
          _ToolbarButton(icon: Icons.format_strikethrough),
          _ToolbarButton(icon: Icons.format_list_numbered),
          _ToolbarButton(icon: Icons.link),
          _ToolbarButton(icon: Icons.format_quote),
          Expanded(
            child: GestureDetector(
              onTap: onCommunityStandards,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    left: _borderSide,
                    top: _borderSide,
                    right: _borderSide,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(3.574),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                child: const Text(
                  'Tiêu chuẩn cộng đồng',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: _linkColor,
                    height: 16 / 10,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.icon, this.isFirst = false});

  final IconData icon;
  final bool isFirst;

  static const Color _border = Color(0xFF998C5F);
  static const BorderSide _borderSide = BorderSide(color: _border, width: 0.5);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: _borderSide,
          left: _borderSide,
          right: _borderSide,
          bottom: BorderSide.none,
        ),
        borderRadius: isFirst
            ? const BorderRadius.only(topLeft: Radius.circular(3.574))
            : BorderRadius.zero,
      ),
      padding: const EdgeInsets.all(4),
      child: Icon(icon, size: 16, color: const Color(0xFF00101A)),
    );
  }
}

import 'package:flutter/material.dart';

import 'write_kudo_formatting_toolbar.dart';

const Color _kBorder = Color(0xFF998C5F);
const Color _kTextDark = Color(0xFF00101A);
const Color _kTextGray = Color(0xFF999999);
const Color _kRequired = Color(0xFFCF1322);

/// Message text area with formatting toolbar above and hint text below.
///
/// Design source: mms_C_Chức năng (toolbar) + mms_D_text filed (textarea).
/// Top half: toolbar row with border-top/left/right only.
/// Bottom half: white textarea with full border, min-height 89px.
class WriteKudoMessageSection extends StatelessWidget {
  const WriteKudoMessageSection({
    super.key,
    required this.controller,
    this.error,
    this.onChanged,
    this.onCommunityStandards,
  });

  final TextEditingController controller;
  final String? error;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCommunityStandards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toolbar — top border only, round top corners
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: _kBorder, width: 0.5),
              left: BorderSide(color: _kBorder, width: 0.5),
              right: BorderSide(color: _kBorder, width: 0.5),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3.574),
              topRight: Radius.circular(3.574),
            ),
          ),
          child: WriteKudoFormattingToolbar(
            onCommunityStandards: onCommunityStandards,
          ),
        ),
        // Textarea — full border, round bottom corners
        Container(
          constraints: const BoxConstraints(minHeight: 89),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: error != null ? _kRequired : _kBorder,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(3.574),
              bottomRight: Radius.circular(3.574),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: 1000,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: _kTextDark,
              height: 20 / 12,
            ),
            decoration: const InputDecoration(
              isCollapsed: true,
              hintText: 'Hãy gửi gắm lời cám ơn...',
              hintStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: _kTextGray,
              ),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Bạn có thể "@ + tên" để nhắc tới đồng nghiệp khác',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: _kTextGray,
            height: 16 / 10,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                color: _kRequired,
                height: 16 / 11,
              ),
            ),
          ),
      ],
    );
  }
}

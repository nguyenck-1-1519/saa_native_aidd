import 'package:flutter/material.dart';

const Color _kBorder = Color(0xFF998C5F);
const Color _kTextDark = Color(0xFF00101A);
const Color _kTextGray = Color(0xFF999999);
const Color _kRequired = Color(0xFFCF1322);
const BorderRadius _kFieldRadius = BorderRadius.all(Radius.circular(3.574));

/// Reusable label + required asterisk row used throughout the Write Kudo form.
class WriteKudoFieldLabel extends StatelessWidget {
  const WriteKudoFieldLabel({
    super.key,
    required this.label,
    this.required = false,
    this.topPadding = 0,
  });

  final String label;
  final bool required;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _kTextDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (required)
            const Text(
              '*',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _kRequired,
              ),
            ),
        ],
      ),
    );
  }
}

/// Search dropdown field (recipient) — text input + chevron icon.
class WriteKudoSearchField extends StatelessWidget {
  const WriteKudoSearchField({
    super.key,
    required this.controller,
    this.hint = 'Tìm kiếm',
    this.error,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String? error;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: error != null ? _kRequired : _kBorder,
              width: 0.5,
            ),
            borderRadius: _kFieldRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.723, vertical: 7.149),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: _kTextDark,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      color: _kTextGray,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, size: 20, color: _kTextGray),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _errorText(error!),
          ),
      ],
    );
  }
}

/// Single-line text field (title/award).
class WriteKudoTextField extends StatelessWidget {
  const WriteKudoTextField({
    super.key,
    required this.controller,
    this.hint = '',
    this.maxLength,
    this.error,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final int? maxLength;
  final String? error;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: error != null ? _kRequired : _kBorder,
              width: 0.5,
            ),
            borderRadius: _kFieldRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.723, vertical: 7.149),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLength: maxLength,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: _kTextDark,
            ),
            decoration: InputDecoration(
              isCollapsed: true,
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: _kTextGray,
              ),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _errorText(error!),
          ),
      ],
    );
  }
}

Text _errorText(String msg) => Text(
      msg,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 11,
        color: _kRequired,
        height: 16 / 11,
      ),
    );

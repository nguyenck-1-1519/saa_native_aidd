import 'package:flutter/material.dart';

const Color _kGold = Color(0xFFFFEA9E);
const Color _kTextDark = Color(0xFF00101A);
const Color _kCancelBorder = Color(0xFF998C5F);
const Color _kCancelBg = Color(0x1AFFEA9E); // rgba(255,234,158,0.10)

/// Bottom action bar with Huỷ (cancel) and Gửi đi (submit) buttons.
///
/// Design source: actions frame (6891:16832).
/// Huỷ: flex-1, outline border #998C5F, bg rgba(255,234,158,0.10), white text + close icon.
/// Gửi đi: fixed 160px, gold fill #FFEA9E, dark text + send icon.
class WriteKudoActionBar extends StatelessWidget {
  const WriteKudoActionBar({
    super.key,
    required this.onCancel,
    required this.onSubmit,
  });

  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.close, size: 18, color: Colors.white),
            label: const Text(
              'Huỷ',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: _kCancelBg,
              side: const BorderSide(color: _kCancelBorder, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 160,
          child: ElevatedButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.send, size: 18, color: _kTextDark),
            label: const Text(
              'Gửi đi',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _kTextDark,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGold,
              foregroundColor: _kTextDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
        ),
      ],
    );
  }
}

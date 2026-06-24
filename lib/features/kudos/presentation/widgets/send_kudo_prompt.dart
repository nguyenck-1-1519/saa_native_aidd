import 'package:flutter/material.dart';

/// Full-width prompt bar that invites the user to send a kudo.
///
/// Design source: mms_A.1_Button ghi nhận (6885:9083).
/// Height: 40px, bg: rgba(255,234,158,0.10), border: 1px solid #998C5F,
/// border-radius: 4px, padding: 10px all sides.
class SendKudoPrompt extends StatelessWidget {
  const SendKudoPrompt({super.key, this.onTap});

  final VoidCallback? onTap;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _border = Color(0xFF998C5F);
  static const Color _bg = Color(0x1AFFEA9E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _bg,
          border: Border.all(color: _border, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.edit, size: 24, color: _gold),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Hôm nay, bạn muốn gửi kudos đến ai?',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../profile_view_model.dart';

part 'profile_kudos_card_subwidgets.dart';
part 'profile_kudos_card_content.dart';

/// A single highlighted kudo card on the profile screen.
///
/// Design node: mms_5.1_KUDO - Highlight (6885:10390)
/// Container: bg #FFF8E1, border 1px solid #FFEA9E, radius 8px, padding 8 12.
///
/// Sections (top → bottom):
///   B.3  — sender → arrow → recipient row
///   ──── divider #FFEA9E
///   B.4  — posted-at / title / message box / image thumbnails / hashtags
///   ──── divider #FFEA9E
///   B.4.4 — action bar: heart count | comment button | share button
class ProfileKudosCard extends StatelessWidget {
  const ProfileKudosCard({
    super.key,
    required this.kudo,
    this.onTap,
  });

  final ProfileKudoView kudo;
  final VoidCallback? onTap;

  static const Color _cardBg = Color(0xFFFFF8E1);
  static const Color _gold = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _gold),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SenderRecipientRow(kudo: kudo),
            const SizedBox(height: 8),
            Container(height: 1, color: _gold),
            const SizedBox(height: 8),
            _ContentBlock(kudo: kudo),
            const SizedBox(height: 8),
            Container(height: 1, color: _gold),
            const SizedBox(height: 8),
            _ActionBar(heartCount: kudo.heartCount),
          ],
        ),
      ),
    );
  }
}

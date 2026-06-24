import 'package:flutter/material.dart';
import '../../domain/entities/kudo.dart';

part 'kudos_card_parts.dart';

/// Kudos highlight card rendered in the feed / carousel.
///
/// Design source: MoMorph node mms_B.3_KUDO - Highlight.
/// Card bg #FFF8E1, border 1px solid #FFEA9E, border-radius 8, padding 8×12.
class KudosCard extends StatelessWidget {
  const KudosCard({super.key, required this.kudo, this.onViewDetail});

  final Kudo kudo;
  final VoidCallback? onViewDetail;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _cardBg = Color(0xFFFFF8E1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _gold),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TraoNhanRow(
            senderName: kudo.senderName,
            senderRole: kudo.senderRole,
            recipientName: kudo.recipientName,
            recipientRole: kudo.recipientRole,
          ),
          const SizedBox(height: 8),
          _Divider(),
          const SizedBox(height: 8),
          _ContentBlock(
            timeRange: kudo.timeRange,
            title: kudo.title,
            message: kudo.message,
            hashtags: kudo.hashtags,
          ),
          const SizedBox(height: 8),
          _Divider(),
          const SizedBox(height: 8),
          _ActionRow(
            heartCount: kudo.heartCount,
            onViewDetail: onViewDetail,
          ),
        ],
      ),
    );
  }
}

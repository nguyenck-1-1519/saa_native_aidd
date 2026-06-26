import 'package:flutter/material.dart';

/// Reward image widget for the [SecretBoxView.revealed] state.
///
/// Design source: MoMorph _cWAEarZPi — node 6885:9663 "mm_media_Quà".
/// Dimensions from Figma: 330×330 pt (displayed at 320×320 in layout).
/// Box shadow: `0 5.746px 42.121px 0 #FFF3C5` (glow effect).
///
/// Asset swap path: supply a valid Flutter asset path via [assetRef] and
/// declare assets/images/secret_box/ in pubspec.yaml.
/// S3 URL was null at extraction time → [_RewardPlaceholder] shown until
/// real PNG is dropped at the path.
class SecretBoxRewardImage extends StatelessWidget {
  const SecretBoxRewardImage({super.key, required this.assetRef});

  final String? assetRef;

  @override
  Widget build(BuildContext context) {
    final path = assetRef;
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // Figma glow: #FFF3C5, blur 42.121px
            color: const Color(0xFFFFF3C5).withValues(alpha: 0.6),
            blurRadius: 42,
          ),
        ],
      ),
      child: path != null
          ? Image.asset(
              path,
              width: 320,
              height: 320,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const _RewardPlaceholder(),
            )
          : const _RewardPlaceholder(),
    );
  }
}

// ── Fallback placeholder ──────────────────────────────────────────────────────

class _RewardPlaceholder extends StatelessWidget {
  const _RewardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF001828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEA9E), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFEA9E).withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.card_giftcard,
        color: Color(0xFFFFEA9E),
        size: 80,
      ),
    );
  }
}

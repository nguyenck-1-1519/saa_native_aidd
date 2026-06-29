import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/home/domain/entities/award_card.dart';

/// Presentational awards carousel for the Home screen (node 6885:9030).
///
/// States:
///   - [isLoading] true  → centered loading indicator
///   - [hasError]  true  → error message + retry button
///   - empty list        → SizedBox.shrink()
///   - data              → horizontal ListView of [_AwardCardItem]
class AwardsCarousel extends StatelessWidget {
  const AwardsCarousel({
    super.key,
    required this.awards,
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
    this.onDetail,
  });

  final List<AwardCard> awards;
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  final ValueChanged<String>? onDetail; // passes award.id

  // Design constants (from MoMorph node 6885:9030)
  static const double _horizontalPadding = 20;
  static const double _cardWidth = 160;
  static const double _cardItemExtent = 176; // 160 card + 16 gap
  // Design card is 160×298, but the rendered column (image + name line metrics
  // + description box + detail button) needs ~305px; give it headroom so the
  // card Column never overflows and the "Chi tiết" button is never clipped.
  static const double _listHeight = 318;
  static const Color _accentColor = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _SectionHeader(),
        const SizedBox(height: 16),
        _buildBody(context),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: _accentColor),
        ),
      );
    }

    if (hasError) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.homeAwardsError,
                style: AppTypography.montserrat(
                  fontSize: 14,
                  weight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(l10n.homeAwardsRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (awards.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: _listHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        itemCount: awards.length,
        itemExtent: _cardItemExtent,
        itemBuilder: (context, index) => SizedBox(
          width: _cardWidth,
          child: _AwardCardItem(
            award: awards[index],
            onDetail: onDetail,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header (node 6885:9031)
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.homeAwardsSectionTitle,
            style: AppTypography.montserrat(
              fontSize: 12,
              weight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFF2E3940),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.homeAwardsSectionSubtitle,
            style: AppTypography.montserrat(
              fontSize: 22,
              weight: FontWeight.w500,
              color: const Color(0xFFFFEA9E),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Award card item (node 6885:9033/9034/9035 — 160×298px)
// ---------------------------------------------------------------------------

class _AwardCardItem extends StatelessWidget {
  const _AwardCardItem({
    required this.award,
    this.onDetail,
  });

  final AwardCard award;
  final ValueChanged<String>? onDetail;

  static const double _imageSize = 160;
  static const double _imageBorderRadius = 11.43;
  static const double _cardGap = 12;
  static const Color _accentColor = Color(0xFFFFEA9E);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image container
        Container(
          width: _imageSize,
          height: _imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_imageBorderRadius),
            border: Border.all(
              color: _accentColor,
              width: 0.455,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000), // rgba(0,0,0,0.25)
                offset: Offset(0, 1.9),
                blurRadius: 1.9,
              ),
              BoxShadow(
                color: Color(0xFFFAE287),
                offset: Offset(0, 0),
                blurRadius: 2.9,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_imageBorderRadius),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              award.imageRef,
              width: _imageSize,
              height: _imageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: _imageSize,
                height: _imageSize,
                color: const Color(0xFF0F1B25),
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: _cardGap),

        // Award name
        Text(
          award.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w500,
            color: _accentColor,
          ),
        ),

        const SizedBox(height: _cardGap),

        // Award description (~60px tall, maxLines 3)
        SizedBox(
          height: 60,
          child: Text(
            award.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.montserrat(
              fontSize: 14,
              weight: FontWeight.w300,
              height: 20 / 14,
              letterSpacing: 0.25,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: _cardGap),

        // "Chi tiết" button — the 24px arrow + label is centred in a 32px-high
        // row. (The previous SizedBox(32) + vertical:10 padding forced 44px of
        // content into 32px, clipping the button.)
        GestureDetector(
          onTap: () => onDetail?.call(award.id),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.homeAwardsDetail,
                  style: AppTypography.montserrat(
                    fontSize: 14,
                    weight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow tinted white to match the white "Chi tiết" label (the
                // SVG ships with a dark #00101A fill).
                SvgPicture.asset(
                  'assets/images/home/icon_arrow.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

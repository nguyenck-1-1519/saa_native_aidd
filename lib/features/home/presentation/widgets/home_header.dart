import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../auth/presentation/widgets/language_selector.dart';

/// Presentational header for the Home screen (node 6885:9057, 375×104px).
///
/// Layout:
///   0–44 px  : iOS status-bar spacer
///  44–104 px : content row — logo left, actions right
///
/// Background: linear gradient from #00101A (opaque) → #00101A (0% opacity).
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.onSearch,
    this.onBell,
    this.unreadCount = 0,
  });

  final VoidCallback? onSearch;
  final VoidCallback? onBell;
  final int unreadCount;

  // Design constants (from MoMorph node 6885:9057)
  /// Fixed portion below the status-bar inset: content row (44) + bottom pad (16).
  static const double belowInset = 60;
  static const double _contentHeight = 44;
  static const double _horizontalPadding = 20;
  static const double _logoWidth = 48;
  static const double _logoHeight = 44;
  static const double _iconSize = 24;
  static const double _actionGap = 10;
  static const double _badgeSize = 8;
  static const Color _badgeColor = Color(0xFFD4271D);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      height: topPadding + belowInset, // dynamic status-bar inset + content + bottom pad
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.7644, 1.0],
          colors: [
            Color(0xFF00101A), // 100% opacity
            Color(0x4D00101A), // 30% opacity (0x4D ≈ 76.4% → 30% = 0x4D)
            Color(0x0000101A), // 0% opacity
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamic status-bar spacer — respects notch / Dynamic Island
          SizedBox(height: topPadding),

          // Content row: logo left, actions right
          SizedBox(
            height: _contentHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo (48×44 px)
                  Image.asset(
                    'assets/images/home/logo_homepage.png',
                    width: _logoWidth,
                    height: _logoHeight,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(),

                  // Actions: LanguageSelector | Search | Bell
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const LanguageSelector(),
                      const SizedBox(width: _actionGap),
                      _SearchButton(onTap: onSearch, iconSize: _iconSize),
                      const SizedBox(width: _actionGap),
                      _BellButton(
                        onTap: onBell,
                        iconSize: _iconSize,
                        unreadCount: unreadCount,
                        badgeSize: _badgeSize,
                        badgeColor: _badgeColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _SearchButton extends StatelessWidget {
  const _SearchButton({this.onTap, required this.iconSize});

  final VoidCallback? onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        'assets/images/home/search.svg',
        width: iconSize,
        height: iconSize,
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton({
    this.onTap,
    required this.iconSize,
    required this.unreadCount,
    required this.badgeSize,
    required this.badgeColor,
  });

  final VoidCallback? onTap;
  final double iconSize;
  final int unreadCount;
  final double badgeSize;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            'assets/images/home/notification.svg',
            width: iconSize,
            height: iconSize,
          ),
          if (unreadCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(badgeSize / 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

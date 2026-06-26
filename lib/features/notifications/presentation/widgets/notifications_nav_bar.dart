import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

/// Pinned navigation bar for the Notifications screen.
///
/// Design: _TopNavigation-content height = 42px. Back chevron on the left,
/// centred title "Thông báo", matching spacer on the right.
class NotificationsNavBarDelegate extends SliverPersistentHeaderDelegate {
  const NotificationsNavBarDelegate({required this.topPadding});

  final double topPadding;

  static const double _navContentHeight = 42;

  @override
  double get minExtent => _navContentHeight;

  @override
  double get maxExtent => _navContentHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return const _NotificationsNavBar();
  }

  @override
  bool shouldRebuild(NotificationsNavBarDelegate old) =>
      old.topPadding != topPadding;
}

class _NotificationsNavBar extends StatelessWidget {
  const _NotificationsNavBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      height: 42,
      decoration: const BoxDecoration(
        // Matches TopNavigation gradient — fades to transparent at bottom.
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00101A), Color(0x0000101A)],
        ),
      ),
      child: Row(
        children: [
          // Left Accessory — back chevron; 7px left pad, 9px all-side inner.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(7, 9, 9, 9),
              child: SizedBox(
                width: 18,
                height: 24,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          // Title centred in remaining space.
          Expanded(
            child: Center(
              child: Text(
                l10n.notificationsTitle,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 24 / 17,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          // Trailing spacer balances back-button width (7 + 9 + 18 + 9 = 43).
          const SizedBox(width: 43),
        ],
      ),
    );
  }
}

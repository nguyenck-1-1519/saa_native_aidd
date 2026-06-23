import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

/// Bottom navigation bar for the 4-tab shell.
///
/// Active tab icon and label are tinted gold (`Color(0xFFD4A843)`) per the
/// design spec. Reads [currentIndex] and delegates taps to [onTap].
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _gold = Color(0xFFD4A843);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      indicatorColor: Colors.transparent,
      destinations: [
        _tab(
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: l10n.homeNavSaa2025,
          isActive: currentIndex == 0,
        ),
        _tab(
          icon: Icons.emoji_events_outlined,
          activeIcon: Icons.emoji_events,
          label: l10n.homeNavAwards,
          isActive: currentIndex == 1,
        ),
        _tab(
          icon: Icons.favorite_outline,
          activeIcon: Icons.favorite,
          label: l10n.homeNavKudos,
          isActive: currentIndex == 2,
        ),
        _tab(
          icon: Icons.person_outline,
          activeIcon: Icons.person,
          label: l10n.homeNavProfile,
          isActive: currentIndex == 3,
        ),
      ],
    );
  }

  NavigationDestination _tab({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    final color = isActive ? _gold : null;
    return NavigationDestination(
      icon: Icon(icon, color: color),
      selectedIcon: Icon(activeIcon, color: _gold),
      label: label,
    );
  }
}

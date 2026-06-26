import 'package:flutter/material.dart';

import 'profile_view_model.dart';
import 'widgets/profile_awards_header.dart';
import 'widgets/profile_awards_list.dart';
import 'widgets/profile_header_section.dart';
import 'widgets/profile_icon_collection.dart';
import 'widgets/profile_kudos_section.dart';
import 'widgets/profile_stats_section.dart';

export 'profile_view_model.dart';

part 'profile_screen_widgets.dart';
part 'profile_screen_filter_widgets.dart';

/// Profile screen — single widget, [isSelf] gates affordances.
///
/// Design sources:
///   Self:  https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/hSH7L8doXB
///   Other: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/bEpdheM0yU
///
/// Pure presentational — no Riverpod, no router, no domain imports.
/// INT agent wires real providers and replaces mock data.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.isSelf,
    this.onEditProfile,
    this.onOpenSettings,
    this.onOpenSecretBox,
    this.onTapRecentKudo,
    this.onTapUser,
    this.onBack,
    this.onSendKudo,
    this.onFilterChanged,
  });

  final ProfileViewModel profile;

  /// true = "Profile bản thân" (self); false = "Profile người khác" (other).
  final bool isSelf;

  // Self-only affordances
  final VoidCallback? onEditProfile;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onOpenSecretBox;

  // Other-profile affordance
  final VoidCallback? onSendKudo;

  // Shared callbacks
  /// Called with the kudo ID when user taps a kudo card.
  final ValueChanged<String>? onTapRecentKudo;

  /// Called with a user ID when tapping a sender/recipient avatar.
  final ValueChanged<String>? onTapUser;

  /// Back navigation — shown when [isSelf] == false.
  final VoidCallback? onBack;

  /// Called when the kudos filter dropdown changes.
  final ValueChanged<KudosFilter>? onFilterChanged;

  static const Color _bgColor = Color(0xFF00101A);
  static const double _hPad = 20;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bgColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Keyvisual background — same asset as home/kudos screens.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/home/Keyvisual_BG.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ProfileTopBar(
                  topPadding: topPadding,
                  isSelf: isSelf,
                  onBack: onBack,
                  onSettings: isSelf ? onOpenSettings : null,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 8, _hPad, 0),
                  child: ProfileHeaderSection(
                    name: profile.name,
                    department: profile.department,
                    heroTag: profile.heroTag,
                    avatarUrl: profile.avatarUrl,
                    isSelf: isSelf,
                    onEditProfile: isSelf ? onEditProfile : null,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
                  child: ProfileIconCollection(badgeCount: profile.iconBadgeCount),
                ),
              ),
              if (isSelf)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
                    child: ProfileStatsSection(
                      kudosReceived: profile.kudosReceived,
                      kudosSent: profile.kudosSent,
                      heartsReceived: profile.heartsReceived,
                      secretBoxOpened: profile.secretBoxOpened,
                      secretBoxUnopened: profile.secretBoxUnopened,
                      onOpenSecretBox: onOpenSecretBox,
                    ),
                  ),
                ),
              if (!isSelf)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
                    child: _SendKudoButton(
                      recipientName: profile.name,
                      onTap: onSendKudo,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
                  child: const ProfileAwardsHeader(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 8, _hPad, 0),
                  child: ProfileAwardsList(awards: profile.awards),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 8, _hPad, 0),
                  child: _KudosFilterDropdown(
                    selected: profile.selectedFilter,
                    kudosReceived: profile.kudosReceived,
                    kudosSent: profile.kudosSent,
                    onChanged: onFilterChanged,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(_hPad, 12, _hPad, bottomPadding + 24),
                sliver: ProfileKudosSection(
                  kudos: profile.recentKudos,
                  onTapKudo: onTapRecentKudo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

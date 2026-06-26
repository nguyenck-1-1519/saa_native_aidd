import 'package:flutter/material.dart';

import 'profile_screen.dart';

/// Thin StatefulWidget that owns [KudosFilter] state and performs a
/// client-side slice of [allKudos] before passing the visible subset to
/// [ProfileScreen].
///
/// This keeps [ProfileScreen] stateless and pure while enabling live filter
/// switching without a backend re-fetch (KISS — client-side slice only).
class ProfileFilterHost extends StatefulWidget {
  const ProfileFilterHost({
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
  });

  final ProfileViewModel profile;
  final bool isSelf;

  final VoidCallback? onEditProfile;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onOpenSecretBox;
  final VoidCallback? onSendKudo;
  final ValueChanged<String>? onTapRecentKudo;
  final ValueChanged<String>? onTapUser;
  final VoidCallback? onBack;

  @override
  State<ProfileFilterHost> createState() => _ProfileFilterHostState();
}

class _ProfileFilterHostState extends State<ProfileFilterHost> {
  KudosFilter _filter = KudosFilter.received;

  /// Returns a [ProfileViewModel] with [recentKudos] sliced to the active
  /// filter and [selectedFilter] updated accordingly.
  ///
  /// The underlying [profile.recentKudos] list carries ALL kudos (received +
  /// sent). Until the backend provides separate endpoints the full list is
  /// passed from the route wrappers and sliced here.
  ///
  /// Client-side slice rule:
  ///   received → keep kudos where recipientName matches profile.name
  ///   sent     → keep kudos where senderName matches profile.name
  ///
  /// If the list is already pre-filtered (one direction only), all items pass
  /// through so the screen is never accidentally empty.
  ProfileViewModel get _slicedProfile {
    final all = widget.profile.recentKudos;
    final name = widget.profile.name;

    List<ProfileKudoView> visible;
    if (_filter == KudosFilter.received) {
      final received = all.where((k) => k.recipientName == name).toList();
      visible = received.isNotEmpty ? received : all;
    } else {
      final sent = all.where((k) => k.senderName == name).toList();
      visible = sent.isNotEmpty ? sent : all;
    }

    return ProfileViewModel(
      name: widget.profile.name,
      department: widget.profile.department,
      heroTag: widget.profile.heroTag,
      avatarUrl: widget.profile.avatarUrl,
      kudosReceived: widget.profile.kudosReceived,
      kudosSent: widget.profile.kudosSent,
      heartsReceived: widget.profile.heartsReceived,
      secretBoxOpened: widget.profile.secretBoxOpened,
      secretBoxUnopened: widget.profile.secretBoxUnopened,
      iconBadgeCount: widget.profile.iconBadgeCount,
      awards: widget.profile.awards,
      recentKudos: visible,
      selectedFilter: _filter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      profile: _slicedProfile,
      isSelf: widget.isSelf,
      onEditProfile: widget.onEditProfile,
      onOpenSettings: widget.onOpenSettings,
      onOpenSecretBox: widget.onOpenSecretBox,
      onTapRecentKudo: widget.onTapRecentKudo,
      onTapUser: widget.onTapUser,
      onBack: widget.onBack,
      onSendKudo: widget.onSendKudo,
      onFilterChanged: (f) => setState(() => _filter = f),
    );
  }
}

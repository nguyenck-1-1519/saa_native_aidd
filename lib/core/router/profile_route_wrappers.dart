import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/domain/entities/profile_data.dart';
import '../../features/profile/presentation/profile_filter_host.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/providers/profile_providers.dart';
import '../l10n/app_localizations.dart';
import 'app_router.dart';

/// ConsumerWidget wrappers that bind the presentational [ProfileScreen] to
/// [profileProvider] and [currentUserIdProvider].
///
/// Both wrappers are the adapter layer — they map [ProfileData] → [ProfileViewModel]
/// and own all provider / router interactions.  [ProfileScreen] stays pure.

// ---------------------------------------------------------------------------
// ProfileData → ProfileViewModel mapping
// ---------------------------------------------------------------------------

ProfileViewModel _toViewModel(ProfileData data) => ProfileViewModel(
      name: data.user.name,
      department: data.user.department,
      heroTag: data.user.heroLevel,
      avatarUrl: data.user.avatarUrl,
      kudosReceived: data.stats.received,
      kudosSent: data.stats.sent,
      heartsReceived: data.stats.heartsReceived,
      secretBoxOpened: data.stats.secretBoxOpened,
      secretBoxUnopened: data.stats.secretBoxUnopened,
      // badges → iconBadgeCount: use the badge list length as the icon count.
      iconBadgeCount: data.user.badges.length,
      awards: data.awards
          .map((a) => ProfileAwardView(
                name: a.name,
                imageUrl: a.badgeImageRef.isNotEmpty ? a.badgeImageRef : null,
              ))
          .toList(),
      recentKudos: data.recentKudos
          .map((k) => ProfileKudoView(
                id: k.id,
                senderName: k.senderName,
                senderAvatarUrl: null, // Kudo feed entity has no avatarUrl — null → placeholder
                senderHeroTag: k.senderRole.isNotEmpty ? k.senderRole : null,
                recipientName: k.recipientName,
                recipientAvatarUrl: null,
                recipientHeroTag: k.recipientRole.isNotEmpty ? k.recipientRole : null,
                postedAt: k.timeRange,
                title: k.title,
                message: k.message,
                hashtags: k.hashtags,
                imageUrls: const [],
                heartCount: k.heartCount,
              ))
          .toList(),
    );

// ---------------------------------------------------------------------------
// Loading / Error helpers (shared)
// ---------------------------------------------------------------------------

Widget _buildLoading(BuildContext context) {
  final l = AppLocalizations.of(context);
  return Scaffold(
    backgroundColor: const Color(0xFF00101A),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(
            l.profileLoading,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
  );
}

Widget _buildError(BuildContext context, VoidCallback onRetry) {
  final l = AppLocalizations.of(context);
  return Scaffold(
    backgroundColor: const Color(0xFF00101A),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l.profileError,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(
              l.profileRetry,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Self profile — branch 3 (inside shell, bottom nav visible)
// ---------------------------------------------------------------------------

/// Loads and displays the current user's own profile.
///
/// Guards null currentUserId by showing a loading spinner — the auth redirect
/// in [routerProvider] prevents unauthenticated users from reaching this branch
/// so a null id is a brief transitional state during sign-out only.
class SelfProfileRouteWrapper extends ConsumerWidget {
  const SelfProfileRouteWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);

    if (userId == null) {
      // Auth guard should redirect before this; show spinner as a safety net.
      return _buildLoading(context);
    }

    final profileAsync = ref.watch(profileProvider(userId));

    return profileAsync.when(
      loading: () => _buildLoading(context),
      error: (_, __) => _buildError(
        context,
        () => ref.invalidate(profileProvider(userId)),
      ),
      data: (data) => ProfileFilterHost(
        profile: _toViewModel(data),
        isSelf: true,
        onEditProfile: () {
          // TODO(backend): wire to real edit-profile flow when F007 ships.
        },
        onOpenSettings: () {
          // TODO(backend): wire to real settings flow when F007 ships.
        },
        onOpenSecretBox: () => context.push(Routes.secretBox),
        onTapRecentKudo: (id) => context.push(Routes.kudoDetailPath(id)),
        onTapUser: (uid) => context.push(Routes.profileUserPath(uid)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Other profile — standalone route outside shell (full-screen push)
// ---------------------------------------------------------------------------

/// Loads and displays another user's profile by [userId].
///
/// [isSelf] is derived at runtime: if [userId] happens to equal the logged-in
/// user, the self affordances appear (covers deep-link edge case).
class OtherProfileRouteWrapper extends ConsumerWidget {
  const OtherProfileRouteWrapper({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final profileAsync = ref.watch(profileProvider(userId));

    return profileAsync.when(
      loading: () => _buildLoading(context),
      error: (_, __) => _buildError(
        context,
        () => ref.invalidate(profileProvider(userId)),
      ),
      data: (data) {
        final isSelf = currentUserId != null && userId == currentUserId;
        return ProfileFilterHost(
          profile: _toViewModel(data),
          isSelf: isSelf,
          onBack: () => context.pop(),
          onTapRecentKudo: (id) => context.push(Routes.kudoDetailPath(id)),
          onTapUser: (uid) => context.push(Routes.profileUserPath(uid)),
          onSendKudo: isSelf
              ? null
              : () => context.push(Routes.writeKudo),
        );
      },
    );
  }
}

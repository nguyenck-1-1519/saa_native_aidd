/// View-model types for [ProfileScreen].
///
/// Design sources:
///   Self:  https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/hSH7L8doXB
///   Other: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/bEpdheM0yU
///
/// Mock data lives in [profile_mock_data.dart].
library;

/// Individual kudo card entry shown on the profile screen.
class ProfileKudoView {
  const ProfileKudoView({
    required this.id,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.senderHeroTag,
    required this.recipientName,
    required this.recipientAvatarUrl,
    required this.recipientHeroTag,
    required this.postedAt,
    required this.title,
    required this.message,
    required this.hashtags,
    required this.imageUrls,
    required this.heartCount,
  });

  final String id;
  final String senderName;
  final String? senderAvatarUrl;
  final String? senderHeroTag;
  final String recipientName;
  final String? recipientAvatarUrl;
  final String? recipientHeroTag;
  final String postedAt;   // e.g. "10:00 - 10/30/2025"
  final String title;      // e.g. "IDOL GIỚI TRẺ"
  final String message;
  final List<String> hashtags;
  final List<String> imageUrls;
  final int heartCount;
}

/// A named award badge shown in the awards section.
class ProfileAwardView {
  const ProfileAwardView({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String? imageUrl;
}

/// Kudos filter mode for the dropdown on the profile screen.
enum KudosFilter { received, sent }

/// Top-level view-model bundle for [ProfileScreen].
///
/// INT agent maps a real domain entity (e.g. `ProfileData`) onto this class.
/// Presentation is pure — no Riverpod or domain imports here.
class ProfileViewModel {
  const ProfileViewModel({
    required this.name,
    required this.department,
    required this.heroTag,
    required this.avatarUrl,
    required this.kudosReceived,
    required this.kudosSent,
    required this.heartsReceived,
    required this.secretBoxOpened,
    required this.secretBoxUnopened,
    required this.iconBadgeCount,
    required this.awards,
    required this.recentKudos,
    this.selectedFilter = KudosFilter.sent,
  });

  final String name;
  final String department;   // e.g. "CEVC3"
  final String? heroTag;     // e.g. "Legend Hero" — null if no tier yet
  final String? avatarUrl;

  // Stats (self screen only)
  final int kudosReceived;
  final int kudosSent;
  final int heartsReceived;
  final int secretBoxOpened;
  final int secretBoxUnopened;

  // Icon collection — render N dark circle placeholders
  final int iconBadgeCount;

  // Awards / danh hiệu badges
  final List<ProfileAwardView> awards;

  // Kudos list (caller pre-filters by [selectedFilter])
  final List<ProfileKudoView> recentKudos;
  final KudosFilter selectedFilter;
}

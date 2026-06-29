import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_typography.dart';
import '../profile_view_model.dart';

/// Renders the list of award/badge tiles below the [ProfileAwardsHeader].
///
/// Each tile shows the award badge image (or a fallback icon) and the award
/// name. Empty list → shows [profileAwardsEmpty] l10n string.
///
/// Design source:
///   mms_4_header / mms_6_header nodes (awards block, same for self + other).
class ProfileAwardsList extends StatelessWidget {
  const ProfileAwardsList({super.key, required this.awards});

  final List<ProfileAwardView> awards;

  @override
  Widget build(BuildContext context) {
    if (awards.isEmpty) {
      return _EmptyState();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: awards.map((a) => _AwardTile(award: a)).toList(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        l.profileAwardsEmpty,
        style: AppTypography.montserrat(
          fontSize: 13,
          weight: FontWeight.w400,
          color: Colors.white54,
        ),
      ),
    );
  }
}

class _AwardTile extends StatelessWidget {
  const _AwardTile({required this.award});

  final ProfileAwardView award;

  static const double _badgeSize = 36;
  static const Color _tileBg = Color(0x1AFFEA9E);
  static const Color _tileBorder = Color(0xFF998C5F);
  static const Color _fallbackIconColor = Color(0xFFFFEA9E);
  static const Color _nameFg = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: _tileBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _tileBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBadge(),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: Text(
              award.name,
              style: AppTypography.montserrat(
                fontSize: 12,
                weight: FontWeight.w500,
                color: _nameFg,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    final url = award.imageUrl;
    if (url == null || url.isEmpty) return _fallbackIcon();

    // Local asset paths start with "assets/" (F003/F004 null-S3 convention).
    // Remote URLs start with "http" and use Image.network.
    final isAsset = url.startsWith('assets/');
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: isAsset
          ? Image.asset(
              url,
              width: _badgeSize,
              height: _badgeSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallbackIcon(),
            )
          : Image.network(
              url,
              width: _badgeSize,
              height: _badgeSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallbackIcon(),
            ),
    );
  }

  Widget _fallbackIcon() {
    return SizedBox(
      width: _badgeSize,
      height: _badgeSize,
      child: const Icon(
        Icons.emoji_events_outlined,
        color: _fallbackIconColor,
        size: 24,
      ),
    );
  }
}

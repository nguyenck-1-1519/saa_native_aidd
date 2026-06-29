import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

/// Profile header — avatar, name, department, hero tag badge.
/// Design nodes: mms_1.1_member (6885:10339) self · mms_2_member (6885:10401) other.
/// [isSelf] gates the edit-avatar affordance overlay.
class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    required this.name,
    required this.department,
    required this.heroTag,
    required this.avatarUrl,
    required this.isSelf,
    this.onEditProfile,
  });

  final String name;
  final String department;
  final String? heroTag;
  final String? avatarUrl;
  final bool isSelf;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            _ProfileAvatar(url: avatarUrl),
            if (isSelf && onEditProfile != null)
              GestureDetector(
                onTap: onEditProfile,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEA9E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Color(0xFF00101A),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        // Name row
        _NameRow(
          name: name,
          department: department,
          heroTag: heroTag,
        ),
      ],
    );
  }
}

// --- Avatar ---
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.url});
  final String? url;
  static const double _size = 72;
  static const Color _placeholder = Color(0xFF323231);
  static const Color _border = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _placeholder,
        border: Border.all(color: _border, width: 1.911),
        image: (url != null && url!.isNotEmpty)
            ? DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover)
            : null,
      ),
      child: (url == null || url!.isEmpty)
          ? const Icon(Icons.person, color: Colors.white54, size: 36)
          : null,
    );
  }
}

// --- Name row: name + dept chip + hero-tag badge ---
class _NameRow extends StatelessWidget {
  const _NameRow({
    required this.name,
    required this.department,
    required this.heroTag,
  });

  final String name;
  final String department;
  final String? heroTag;

  static const Color _nameColor = Color(0xFFFFEA9E);
  static const Color _deptColor = Colors.white;
  static const Color _dotColor = Color(0x66999999);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Full name — Montserrat 18 Bold #FFEA9E
        Text(
          name,
          style: AppTypography.montserrat(
            fontSize: 18,
            weight: FontWeight.w700,
            color: _nameColor,
            height: 24 / 18,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        // Department + dot + hero tag badge
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              department,
              style: AppTypography.montserrat(
                fontSize: 14,
                weight: FontWeight.w400,
                color: _deptColor,
                letterSpacing: 0.25,
              ),
            ),
            if (heroTag != null && heroTag!.isNotEmpty) ...[
              const SizedBox(width: 5),
              Container(
                width: 2,
                height: 2,
                decoration: const BoxDecoration(
                  color: _dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              _HeroTagBadge(label: heroTag!),
            ],
          ],
        ),
      ],
    );
  }
}

// --- Hero tag badge (design: 60×12 pill, border #FFEA9E, text white 7.9px Bold) ---

class _HeroTagBadge extends StatelessWidget {
  const _HeroTagBadge({required this.label});

  final String label;

  static const Color _border = Color(0xFFFFEA9E);
  static const Color _text = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border, width: 0.309),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 7.9,
          fontWeight: FontWeight.w700,
          fontVariations: [FontVariation('wght', 700)],
          color: _text,
          height: 10.5 / 7.9,
          letterSpacing: 0.057,
          shadows: [
            Shadow(color: Colors.white, blurRadius: 0.8),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_typography.dart';
import '../profile_view_model.dart';
import 'profile_kudos_card.dart';

/// Sliver list of kudo cards for the profile screen.
///
/// Design node: mms_5_kudos list (6885:10389) / mms_8_kudos list (6885:10420)
/// Renders [ProfileKudosCard] for each item separated by 12px gaps.
/// Returns a sliver so it embeds directly in [CustomScrollView].
class ProfileKudosSection extends StatelessWidget {
  const ProfileKudosSection({
    super.key,
    required this.kudos,
    this.onTapKudo,
  });

  final List<ProfileKudoView> kudos;
  final ValueChanged<String>? onTapKudo;

  @override
  Widget build(BuildContext context) {
    if (kudos.isEmpty) {
      return const SliverToBoxAdapter(child: _EmptyState());
    }
    return SliverList.separated(
      itemCount: kudos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final kudo = kudos[index];
        return ProfileKudosCard(
          kudo: kudo,
          onTap: onTapKudo != null ? () => onTapKudo!(kudo.id) : null,
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          l.profileKudosEmpty,
          style: AppTypography.montserrat(
            fontSize: 14,
            weight: FontWeight.w400,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}

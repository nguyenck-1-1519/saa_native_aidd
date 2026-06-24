import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../home/presentation/providers/home_providers.dart';
import '../../home/presentation/widgets/home_header.dart';
import '../../home/presentation/widgets/kudos_section.dart';
import '../domain/entities/award_detail.dart';
import 'providers/awards_providers.dart';
import 'widgets/award_detail_block.dart';
import 'widgets/award_highlight_header.dart';
import 'widgets/kudos_kv_banner.dart';

/// Awards tab screen (F003) — "Hệ thống giải thưởng SAA 2025".
///
/// One screen; the award dropdown switches among the 5 awards. Data comes from
/// [awardsDetailControllerProvider]; the selection from [selectedAwardIdProvider].
/// Bottom nav is provided by the shell StatefulShellRoute — not here.
class AwardsScreen extends ConsumerWidget {
  const AwardsScreen({super.key});

  static const Color _bg = Color(0xFF00101A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unread = ref.watch(unreadCountProvider).valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Key-visual background (reused home asset), offset right per design.
          Positioned(
            right: -506,
            top: 0,
            child: Image.asset(
              'assets/images/home/Keyvisual_BG.png',
              width: 881,
              height: 723,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.0, 0.186, 0.772],
                  colors: [
                    Color(0xFF00101A),
                    Color(0xFF10181F),
                    Color(0x0000101A),
                  ],
                ),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: HomeHeader(
                  unreadCount: unread,
                  onSearch: () => context.push(Routes.search),
                  onBell: () => context.push(Routes.notifications),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const KudosKvBanner(),
                      const SizedBox(height: 38),
                      _AwardsBody(l10n: l10n),
                      const SizedBox(height: 40),
                      KudosSection(
                        onDetail: () => context.push(Routes.kudosDetail),
                      ),
                      const SizedBox(height: 96),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Renders the highlight header + detail block, or loading/error states.
class _AwardsBody extends ConsumerWidget {
  const _AwardsBody({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final awardsAsync = ref.watch(awardsDetailControllerProvider);
    if (awardsAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (awardsAsync.hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Text(
                l10n.homeAwardsError,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () =>
                    ref.read(awardsDetailControllerProvider.notifier).refresh(),
                child: Text(l10n.homeAwardsRetry),
              ),
            ],
          ),
        ),
      );
    }

    final List<AwardDetail> awards = awardsAsync.valueOrNull ?? const [];
    if (awards.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Text(
            l10n.homeAwardsEmpty,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final selected = ref.watch(selectedAwardDetailProvider) ?? awards.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AwardHighlightHeader(
          awards: awards,
          selected: selected,
          onSelect: (id) =>
              ref.read(selectedAwardIdProvider.notifier).state = id,
        ),
        const SizedBox(height: 40),
        AwardDetailBlock(award: selected),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../home/presentation/widgets/home_header.dart';
import '../../awards/presentation/widgets/kudos_kv_banner.dart';
import '../domain/entities/kudos_stats.dart';
import 'providers/kudos_providers.dart';
import 'widgets/all_kudos_stats.dart';
import 'widgets/highlight_kudos_carousel.dart';
import 'widgets/kudos_card.dart';
import 'widgets/recent_recipients.dart';
import 'widgets/send_kudo_prompt.dart';
import 'widgets/spotlight_board.dart';

/// Kudos feed screen — "Kudos" bottom-nav tab.
///
/// Data from [kudosFeedControllerProvider] (+ [kudosStatsProvider]); the
/// send-kudo prompt routes to the Write-Kudo screen. Bottom nav comes from
/// the shell — not here.
class KudosScreen extends ConsumerWidget {
  const KudosScreen({super.key});

  static const Color _bgColor = Color(0xFF00101A);
  static const double _hPad = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = MediaQuery.of(context).padding.top;
    final l10n = AppLocalizations.of(context);
    final feedAsync = ref.watch(kudosFeedControllerProvider);
    final stats = ref.watch(kudosStatsProvider).valueOrNull;

    return Scaffold(
      backgroundColor: _bgColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const _KeyvisualBackground(),
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _KudosHeaderDelegate(topPadding: topPadding),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(_hPad, 40, _hPad, 0),
                  child: KudosKvBanner(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
                  child: SendKudoPrompt(
                    onTap: () => context.push(Routes.writeKudo),
                  ),
                ),
              ),
              // Static branding board — independent of feed data.
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
                  child: SpotlightBoard(),
                ),
              ),
              // Data-driven sections: loading / error+retry / data.
              ..._dataSlivers(context, ref, l10n, feedAsync, stats),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _dataSlivers(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AsyncValue<KudosFeedData> feedAsync,
    KudosStats? stats,
  ) {
    if (feedAsync.isLoading) {
      return const [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ];
    }
    if (feedAsync.hasError) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: _hPad),
            child: Center(
              child: Column(
                children: [
                  Text(l10n.homeAwardsError,
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref
                        .read(kudosFeedControllerProvider.notifier)
                        .refresh(),
                    child: Text(l10n.homeAwardsRetry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    final data = feedAsync.valueOrNull;
    if (data == null) return const [];

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
          child: HighlightKudosCarousel(kudos: data.highlights),
        ),
      ),
      if (stats != null)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
            child: AllKudosStats(
              stats: stats,
              onOpenSecretBox: () => context.push(Routes.secretBox),
            ),
          ),
        ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
          child: RecentRecipients(recipients: data.recipients),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
        sliver: SliverList.separated(
          itemCount: data.feed.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => KudosCard(
            kudo: data.feed[index],
            onViewDetail: () =>
                context.push(Routes.kudoDetailPath(data.feed[index].id)),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 80),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ViewAllButton(
                onTap: () => context.push(Routes.allKudos),
              ),
              const SizedBox(height: 12),
              _KudosRulesLink(
                onTap: () => context.push(Routes.kudosRules),
              ),
            ],
          ),
        ),
      ),
    ];
  }

}

class _KeyvisualBackground extends StatelessWidget {
  const _KeyvisualBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Image.asset(
        'assets/images/home/Keyvisual_BG.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

/// Pins [HomeHeader] at the top of the scroll view.
class _KudosHeaderDelegate extends SliverPersistentHeaderDelegate {
  _KudosHeaderDelegate({required this.topPadding});

  final double topPadding;

  double get _height => topPadding + HomeHeader.belowInset;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      const HomeHeader();

  @override
  bool shouldRebuild(_KudosHeaderDelegate old) => old.topPadding != topPadding;
}

class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View all Kudos',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 20, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Minimal "Thể lệ" text link shown below the "View all" button.
/// Taps open [KudosRulesScreen] via the router.
class _KudosRulesLink extends StatelessWidget {
  const _KudosRulesLink({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: const Text(
          'Thể lệ',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFEA9E),
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFFFFEA9E),
          ),
        ),
      ),
    );
  }
}

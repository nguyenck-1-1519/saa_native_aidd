import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import 'providers/countdown_controller.dart';
import 'providers/home_providers.dart';
import 'widgets/awards_carousel.dart';
import 'widgets/hero_countdown.dart';
import 'widgets/home_fab.dart';
import 'widgets/home_header.dart';
import 'widgets/kudos_section.dart';
import 'widgets/theme_description.dart';

/// Home screen — SAA 2025 entry point after login.
///
/// Wires the presentational widgets to their Riverpod providers and routes
/// every interaction to its destination (real screens or placeholders).
/// Bottom nav is provided by the shell route — not here.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const Color _bgColor = Color(0xFF00101A);

  /// In-flight flag — prevents a rapid double-tap on the FAB from pushing the
  /// same route twice (FUN_013).
  bool _fabBusy = false;

  Future<void> _guardedPush(String route) async {
    if (_fabBusy) return;
    setState(() => _fabBusy = true);
    await context.push(route);
    if (mounted) setState(() => _fabBusy = false);
  }

  @override
  Widget build(BuildContext context) {
    final countdown = ref.watch(countdownControllerProvider);
    final awardsAsync = ref.watch(awardsControllerProvider);
    final kudosVisible = ref.watch(kudosAvailableProvider);

    return Scaffold(
      backgroundColor: _bgColor,
      extendBodyBehindAppBar: true,
      floatingActionButton: HomeFab(
        onPencil: () => _guardedPush(Routes.writeKudo),
        onKudos: () => _guardedPush(Routes.kudosFeed),
      ),
      body: Stack(
        children: [
          const _KeyvisualBackground(),
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _HomeHeaderDelegate(
                  topPadding: MediaQuery.of(context).padding.top,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      HeroCountdown(
                        countdown: countdown,
                        onAboutAward: () => context.push(Routes.aboutAward),
                        onAboutKudos: () => context.push(Routes.aboutKudos),
                      ),
                      const SizedBox(height: 40),
                      const ThemeDescription(),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: AwardsCarousel(
                    awards: awardsAsync.valueOrNull ?? const [],
                    isLoading: awardsAsync.isLoading,
                    hasError: awardsAsync.hasError,
                    onRetry: () =>
                        ref.read(awardsControllerProvider.notifier).refresh(),
                    onDetail: (_) => context.push(Routes.awardDetail),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                  child: KudosSection(
                    visible: kudosVisible,
                    onDetail: () => context.push(Routes.kudosDetail),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Full-bleed key-visual image behind the scroll view.
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

/// Pins [HomeHeader] at the top; reads the unread badge count and wires the
/// search/bell actions via a [Consumer] (the delegate has no `ref`).
///
/// The header height is dynamic: status-bar inset (from MediaQuery) + 60px
/// for the content row and bottom breathing room. This matches the height
/// computed inside [HomeHeader] itself so the sliver constraint is satisfied.
class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  _HomeHeaderDelegate({required this.topPadding});

  final double topPadding;

  // Mirrors HomeHeader.belowInset — keep in sync.
  static const double _belowInset = HomeHeader.belowInset;

  double get _height => topPadding + _belowInset;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer(
      builder: (context, ref, _) {
        final unread = ref.watch(unreadCountProvider).valueOrNull ?? 0;
        return HomeHeader(
          unreadCount: unread,
          onSearch: () => context.push(Routes.search),
          onBell: () => context.push(Routes.notifications),
        );
      },
    );
  }

  @override
  bool shouldRebuild(_HomeHeaderDelegate old) => old.topPadding != topPadding;
}

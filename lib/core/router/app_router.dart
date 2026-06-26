import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/awards/presentation/awards_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../features/kudos/presentation/community_standards_screen.dart';
import '../../features/kudos/presentation/kudos_rules_screen.dart';
import '../../features/kudos/presentation/kudos_screen.dart';
import '../../features/kudos/presentation/write_kudo_screen.dart';
import '../../features/placeholder/presentation/placeholder_screen.dart';
import 'kudos_route_wrappers.dart';
import 'secret_box_route_wrapper.dart';
import 'system_route_wrappers.dart';

/// All named route paths in the app.
///
/// Destinations not yet built point at [PlaceholderScreen] via their own
/// explicit path so call sites never need updating when the real screen ships.
abstract final class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const awards = '/awards';
  static const kudos = '/kudos';
  static const profile = '/profile';

  // Placeholder destinations — explicit paths, swap without touching call sites.
  static const search = '/search';
  static const notifications = '/notifications';
  // awardDetail + aboutAward retired: Home links now go directly to the Awards
  // tab via goBranch(1) — no standalone routes needed (F003 Phase 04).
  // aboutKudos + kudosFeed retired: links now go directly to the
  // Kudos tab via goBranch(kKudosBranchIndex) — no standalone routes needed (F004 Phase 04).
  // Real detail/list/content routes added in F004 INT (below):
  static const writeKudo = '/write-kudo';
  static const allKudos = '/kudos/all';
  // /kudos/detail/:id — use kudoDetailPath(id) helper to build the full path.
  static const kudoDetail = '/kudos/detail';
  static const communityStandards = '/kudos/community-standards';
  static const kudosRules = '/kudos/rules';
  static const accessDenied = '/access-denied';

  // F005 — Secret Box
  static const secretBox = '/secret-box';

  /// Returns the full path for a single-kudo detail screen.
  static String kudoDetailPath(String id) => '$kudoDetail/$id';
}

/// Branch index for the Kudos tab in the [StatefulNavigationShell].
/// Order: 0=Home, 1=Awards, 2=Kudos, 3=Profile (see branches below).
const int kKudosBranchIndex = 2;

/// App router with an auth-aware redirect and a 4-tab StatefulShellRoute.
///
/// Redirect logic is preserved byte-for-byte from F001:
///   loading  → splash (no loop)
///   hasError → /login
///   loggedIn + on splash/login → /home
///   not loggedIn + on home/splash → /login
/// Added: 403 case routes to /access-denied (FR11).
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authStateProvider, (_, __) => refresh.value++);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    // FR4: unknown paths render the 404 screen with an auth-aware CTA.
    errorBuilder: (context, state) => const NotFoundRouteWrapper(),
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final loc = state.matchedLocation;

      // Still resolving the initial session → wait on the splash (no loop).
      if (auth.isLoading) {
        return loc == Routes.splash ? null : Routes.splash;
      }

      // A broken auth stream → force re-authentication, never trust a stale user.
      if (auth.hasError) {
        return loc == Routes.login ? null : Routes.login;
      }

      final loggedIn = auth.valueOrNull != null;
      if (loggedIn) {
        return (loc == Routes.login || loc == Routes.splash)
            ? Routes.home
            : null;
      }
      return loc == Routes.login ? null : Routes.login;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const _SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),

      // -----------------------------------------------------------------------
      // 4-tab shell — per-tab state kept via indexedStack (FR8, FUN_015–018)
      // -----------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => _ShellScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          // Branch 0 — Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1 — Awards
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.awards,
                builder: (_, __) => const AwardsScreen(),
              ),
            ],
          ),
          // Branch 2 — Kudos (kKudosBranchIndex = 2)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.kudos,
                builder: (_, __) => const KudosScreen(),
              ),
            ],
          ),
          // Branch 3 — Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, __) =>
                    const PlaceholderScreen(title: 'Profile'),
              ),
            ],
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // Standalone destinations (outside shell — no bottom nav)
      // -----------------------------------------------------------------------
      GoRoute(
        path: Routes.search,
        builder: (_, __) => const PlaceholderScreen(title: 'Search'),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (_, __) =>
            const PlaceholderScreen(title: 'Notifications'),
      ),
      // /write-kudo — full-screen push, outside shell so back returns to caller.
      GoRoute(
        path: Routes.writeKudo,
        builder: (_, __) => const WriteKudoScreen(),
      ),

      // -----------------------------------------------------------------------
      // Kudos content routes — full-screen push, outside shell (F004 INT)
      // -----------------------------------------------------------------------

      // /kudos/all — AllKudos list (bound to allKudosProvider + filter)
      GoRoute(
        path: Routes.allKudos,
        builder: (_, __) => const AllKudosRouteWrapper(),
      ),

      // /kudos/detail/:id — single kudo detail (bound to kudoDetailProvider)
      // NOTE: literal sub-paths (/kudos/all, /kudos/community-standards,
      // /kudos/rules) are declared in the top-level routes list. GoRouter
      // matches literals before parameters so there is no shadowing risk.
      GoRoute(
        path: '${Routes.kudoDetail}/:id',
        builder: (_, state) {
          final id = state.pathParameters['id'] ?? '';
          return ViewKudoRouteWrapper(id: id);
        },
      ),

      // /kudos/community-standards — static content
      GoRoute(
        path: Routes.communityStandards,
        builder: (_, __) => const CommunityStandardsScreen(),
      ),

      // /kudos/rules — Thể lệ static content
      GoRoute(
        path: Routes.kudosRules,
        builder: (context, _) => KudosRulesScreen(
          onWriteKudo: () => context.push(Routes.writeKudo),
        ),
      ),

      // /secret-box — full-screen push, outside shell (F005)
      GoRoute(
        path: Routes.secretBox,
        builder: (_, __) => const SecretBoxRouteWrapper(),
      ),

      // FR5: 403 screen. Auth guard (redirect @89) bounces unauthenticated users
      // to /login before they reach this route — no allow-list exception added
      // today because no real 403 source exists yet (YAGNI deferral, F008 spec).
      GoRoute(
        path: Routes.accessDenied,
        builder: (_, __) => const AccessDeniedRouteWrapper(),
      ),
    ],
  );
});

// ---------------------------------------------------------------------------
// Shell scaffold — wraps branches with the bottom nav bar
// ---------------------------------------------------------------------------

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Splash — unchanged from F001
// ---------------------------------------------------------------------------

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

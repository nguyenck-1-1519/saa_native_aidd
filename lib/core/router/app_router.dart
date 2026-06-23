import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../features/placeholder/presentation/placeholder_screen.dart';

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
  static const awardDetail = '/award-detail';
  static const aboutAward = '/about-award';
  static const aboutKudos = '/about-kudos';
  static const kudosDetail = '/kudos-detail';
  static const kudosFeed = '/kudos-feed';
  static const writeKudo = '/write-kudo';
  static const accessDenied = '/access-denied';
}

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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.awards,
                builder: (_, __) => const PlaceholderScreen(title: 'Awards'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.kudos,
                builder: (_, __) => const PlaceholderScreen(title: 'Kudos'),
              ),
            ],
          ),
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
      // Standalone placeholder destinations (outside shell — no bottom nav)
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
      GoRoute(
        path: Routes.awardDetail,
        builder: (_, __) => const PlaceholderScreen(title: 'Award Detail'),
      ),
      GoRoute(
        path: Routes.aboutAward,
        builder: (_, __) =>
            const PlaceholderScreen(title: 'About Award'),
      ),
      GoRoute(
        path: Routes.aboutKudos,
        builder: (_, __) =>
            const PlaceholderScreen(title: 'About Kudos'),
      ),
      GoRoute(
        path: Routes.kudosDetail,
        builder: (_, __) =>
            const PlaceholderScreen(title: 'Kudos Detail'),
      ),
      GoRoute(
        path: Routes.kudosFeed,
        builder: (_, __) => const PlaceholderScreen(title: 'Kudos Feed'),
      ),
      GoRoute(
        path: Routes.writeKudo,
        builder: (_, __) => const PlaceholderScreen(title: 'Write Kudo'),
      ),
      GoRoute(
        path: Routes.accessDenied,
        builder: (_, __) =>
            const PlaceholderScreen(title: 'Access Denied'),
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

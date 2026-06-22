import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';

/// Route paths.
abstract final class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
}

/// App router with an auth-aware redirect.
///
/// While auth state is loading, the user stays on the splash (no redirect →
/// no loop, R5). Once resolved: a valid session → /home (auto-login, FR8);
/// none/expired → /login (FR9); logout flips back to /login (FR10).
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
      return (loc == Routes.home || loc == Routes.splash)
          ? Routes.login
          : null;
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, __) => const _SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
    ],
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

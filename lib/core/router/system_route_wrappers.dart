import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/system/presentation/access_denied_screen.dart';
import '../../features/system/presentation/not_found_screen.dart';
import '../l10n/app_localizations.dart';
import 'app_router.dart';

/// ConsumerWidget wrappers for system error screens (403 + 404).
///
/// Kept in a separate file to keep [app_router.dart] under 200 lines.
/// These classes are intentionally package-private — only [app_router.dart]
/// instantiates them inside GoRoute builders / errorBuilder.
///
/// Auth-aware CTA (FR3):
///   logged in  → label "Về trang chủ" / context.go(Routes.home)
///   logged out → label "Về đăng nhập" / context.go(Routes.login)

// ---------------------------------------------------------------------------
// Access Denied (403) route wrapper
// ---------------------------------------------------------------------------

/// Wraps [AccessDeniedScreen] with auth-aware CTA resolved from [authStateProvider].
class AccessDeniedRouteWrapper extends ConsumerWidget {
  const AccessDeniedRouteWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loggedIn = ref.watch(authStateProvider).valueOrNull != null;

    return AccessDeniedScreen(
      primaryLabel: loggedIn ? l10n.errorGoHome : l10n.errorGoLogin,
      onPrimaryAction: loggedIn
          ? () => context.go(Routes.home)
          : () => context.go(Routes.login),
    );
  }
}

// ---------------------------------------------------------------------------
// Not Found (404) route wrapper — used in GoRouter.errorBuilder
// ---------------------------------------------------------------------------

/// Wraps [NotFoundScreen] with auth-aware CTA resolved from [authStateProvider].
class NotFoundRouteWrapper extends ConsumerWidget {
  const NotFoundRouteWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final loggedIn = ref.watch(authStateProvider).valueOrNull != null;

    return NotFoundScreen(
      primaryLabel: loggedIn ? l10n.errorGoHome : l10n.errorGoLogin,
      onPrimaryAction: loggedIn
          ? () => context.go(Routes.home)
          : () => context.go(Routes.login),
    );
  }
}

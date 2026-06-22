import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../auth/presentation/providers/auth_providers.dart';

/// Minimal post-login placeholder: shows the signed-in user and a logout action.
/// Exists so the full auth flow (login → home → logout) is demonstrable.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).valueOrNull;
    final name = user?.displayName ?? user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.logout,
            onPressed: () => ref.read(signOutProvider).call(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user?.photoUrl != null)
              CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(user!.photoUrl!),
              ),
            const SizedBox(height: 16),
            Text(
              l10n.homeWelcome(name),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (user?.email != null) ...[
              const SizedBox(height: 8),
              Text(user!.email),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.read(signOutProvider).call(),
              icon: const Icon(Icons.logout),
              label: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }
}

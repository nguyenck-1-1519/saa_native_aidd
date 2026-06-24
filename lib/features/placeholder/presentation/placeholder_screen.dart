import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';

/// Shared placeholder shown for every destination not yet implemented.
///
/// Accepts a [title] (the screen name) and an optional [note] for extra
/// context. Renders "Chưa triển khai" using the app theme so it visually
/// integrates with the shell. Swap with the real screen without touching
/// call sites — the route path stays the same.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
    this.note,
  });

  final String title;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction_rounded,
                size: 64,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.placeholderNotImplemented,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (note != null) ...[
                const SizedBox(height: 8),
                Text(
                  note!,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';

part 'widgets/access_denied_parts.dart';

/// Static 403 Access Denied screen.
///
/// Pure [StatelessWidget] — no providers, no router imports. The caller
/// (integration/router) supplies [primaryLabel] and [onPrimaryAction] so this
/// widget stays auth-unaware and trivially testable.
///
/// Illustration asset `mms_2.1_mm_media_Not Found` (node 6885:9529) has no
/// exported S3 URL in MoMorph, so it falls back to [Icons.lock_outline_rounded].
class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({
    super.key,
    required this.primaryLabel,
    this.onPrimaryAction,
  });

  /// Label text for the primary CTA button (e.g. "Về trang chủ").
  final String primaryLabel;

  /// Called when the CTA is tapped. Integration layer supplies the auth-aware
  /// target; widget does not navigate on its own.
  final VoidCallback? onPrimaryAction;

  static const Color _bg = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TopNavBar(),
            Expanded(
              child: _ContentCard(
                title: l10n.accessDeniedTitle,
                message: l10n.accessDeniedMessage,
                primaryLabel: primaryLabel,
                onPrimaryAction: onPrimaryAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

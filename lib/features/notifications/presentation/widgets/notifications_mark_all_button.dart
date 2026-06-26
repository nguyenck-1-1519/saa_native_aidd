import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

/// "Đánh dấu đọc tất cả" button (spec A.1).
///
/// Design: icon-text row, 16px vertical padding, 4px gap, 14px Montserrat
/// Bold white. Icon is MM_MEDIA_IC (null S3 → Material icon fallback).
/// Always visible; tapping fires [onTap].
class NotificationsMarkAllButton extends StatelessWidget {
  const NotificationsMarkAllButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // MM_MEDIA_IC — null S3 → Material fallback icon
            const Icon(Icons.format_list_bulleted, color: Colors.white, size: 24),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                l10n.notificationsMarkAllRead,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 20 / 14,
                  letterSpacing: 0.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

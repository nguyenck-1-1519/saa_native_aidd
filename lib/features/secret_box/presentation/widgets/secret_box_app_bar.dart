import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';

/// Top navigation bar for the Secret Box screen.
///
/// Design source: MoMorph kQk65hSYF2 — node 6885:9408.
/// Title: "Secret Box" (Helvetica Neue 17 Medium, white, letter-spacing 0.5).
/// Left: back chevron (28 pt icon, left-padded 7 pt).
class SecretBoxAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SecretBoxAppBar({super.key, required this.onBack});

  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(42);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF00101A),
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 42,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
        padding: const EdgeInsets.only(left: 7),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        AppLocalizations.of(context).secretBoxTitle,
        style: const TextStyle(
          fontFamily: 'Helvetica Neue',
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0.5,
          height: 24 / 17,
        ),
      ),
    );
  }
}

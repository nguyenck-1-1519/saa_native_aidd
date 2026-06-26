import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import 'secret_box_opening_animation.dart';

/// Layout wrapper for the [SecretBoxView.opening] state.
///
/// Renders the same header text as the closed state but replaces
/// the box image with [SecretBoxOpeningAnimation].
///
/// Design source: MoMorph KUmv414uC9 — node 6885:9564.
class SecretBoxOpeningWrapper extends StatelessWidget {
  const SecretBoxOpeningWrapper({
    super.key,
    required this.onAnimationComplete,
  });

  final VoidCallback? onAnimationComplete;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _white = Colors.white;
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            l10n.secretBoxTitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _gold,
              height: 24 / 18,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(height: 1, color: _divider),
        const SizedBox(height: 4),
        Text(
          l10n.secretBoxOpening,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _white,
            height: 20 / 14,
          ),
        ),
        const SizedBox(height: 24),
        SecretBoxOpeningAnimation(
          onAnimationComplete: onAnimationComplete ?? () {},
        ),
      ],
    );
  }
}

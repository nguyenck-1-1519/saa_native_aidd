import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens — Montserrat, sizes/weights from the MoMorph design.
///
/// NOTE: the bundled `assets/fonts/Montserrat.ttf` is a VARIABLE font whose
/// default master is Thin (weight 100). Specifying only `fontWeight` makes the
/// engine render the thin master and *synthesise* heavier weights, which looks
/// faint/blurry and off-design. Every Montserrat style must therefore drive the
/// weight (`wght`) axis explicitly via [FontVariation]. Use [montserrat] so the
/// axis is always set.
abstract final class AppTypography {
  static const String fontFamily = 'Montserrat';

  /// Builds a Montserrat [TextStyle] that explicitly pins the variable font's
  /// `wght` axis to [weight], so text renders at the true designed weight
  /// instead of a synthesised one.
  static TextStyle montserrat({
    required double fontSize,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.textOnDark,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: weight,
      fontVariations: [FontVariation('wght', wghtOf(weight))],
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Maps a [FontWeight] (w100…w900) to its numeric `wght` axis value (100…900).
  static double wghtOf(FontWeight weight) => (weight.index + 1) * 100.0;

  /// Description text (mms_4): 14px, weight 300, lineHeight 20, +0.25 letter.
  static final TextStyle description = montserrat(
    fontSize: 14,
    weight: FontWeight.w300,
    height: 20 / 14,
    letterSpacing: 0.25,
  );

  /// Copyright text (mms_6): 12px, weight 400, lineHeight 16, centered.
  static final TextStyle copyright = montserrat(
    fontSize: 12,
    weight: FontWeight.w400,
    height: 16 / 12,
  );

  /// Google button label: 14px, semi-bold, dark on gold.
  static final TextStyle button = montserrat(
    fontSize: 14,
    weight: FontWeight.w600,
    letterSpacing: 0.25,
    color: AppColors.onButton,
  );

  /// Language code label in the selector.
  static final TextStyle languageCode = montserrat(
    fontSize: 14,
    weight: FontWeight.w500,
  );
}

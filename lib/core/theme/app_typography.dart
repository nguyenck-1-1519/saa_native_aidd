import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens — Montserrat, sizes/weights from the MoMorph design.
abstract final class AppTypography {
  static const String fontFamily = 'Montserrat';

  /// Description text (mms_4): 14px, weight 300, lineHeight 20, +0.25 letter.
  static const TextStyle description = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w300,
    letterSpacing: 0.25,
    color: AppColors.textOnDark,
  );

  /// Copyright text (mms_6): 12px, weight 400, lineHeight 16, centered.
  static const TextStyle copyright = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
  );

  /// Google button label: 14px, semi-bold, dark on gold.
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
    color: AppColors.onButton,
  );

  /// Language code label in the selector.
  static const TextStyle languageCode = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
  );
}

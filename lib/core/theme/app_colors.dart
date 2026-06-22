import 'package:flutter/material.dart';

/// Brand color tokens — values taken from the MoMorph design (screen 8HGlvYGJWq).
abstract final class AppColors {
  /// Frame background base (rgba(0,16,26,1)). The key-visual image sits on top.
  static const Color background = Color(0xFF00101A);

  /// Primary CTA / Google button fill (rgba(255,234,158,1)).
  static const Color buttonPrimary = Color(0xFFFFEA9E);

  /// Text on the pale-gold button.
  static const Color onButton = Color(0xFF00101A);

  /// Light text over the dark key-visual.
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Slightly muted variant for secondary copy.
  static const Color textMuted = Color(0xCCFFFFFF);

  /// Error/snackbar surface.
  static const Color error = Color(0xFFD64545);
}

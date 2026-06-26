import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';

/// Static 404 Not Found screen.
///
/// Design source: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/sn2mdavs1a
///
/// Pure StatelessWidget — no providers, no router imports. The caller supplies
/// [primaryLabel] and [onPrimaryAction] so this widget stays auth-agnostic.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({
    super.key,
    required this.primaryLabel,
    this.onPrimaryAction,
  });

  /// CTA button label — caller provides the auth-aware string.
  final String primaryLabel;

  /// Called when the CTA button is tapped. Null = rendered but inert.
  final VoidCallback? onPrimaryAction;

  // Design tokens (Figma node 6885:9480)
  static const Color _bg = Color(0xFF00101A);
  static const Color _titleColor = Color(0xFFFFEA9E);
  static const Color _dividerColor = Color(0xFF2E3940);
  static const Color _bodyColor = Color(0xFFFFFFFF);
  static const Color _buttonBg = Color(0xFFFFEA9E);
  static const Color _buttonFg = Color(0xFF00101A);
  static const String _font = 'Montserrat';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _bodyColor, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(l10n),
              const SizedBox(height: 24),
              _buildIllustration(),
              const SizedBox(height: 24),
              const Divider(color: _dividerColor, thickness: 1, height: 1),
              const SizedBox(height: 24),
              _buildCtaButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title: Montserrat 700 18px #FFEA9E
        Text(
          l10n.notFoundTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: _font,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 24 / 18,
            color: _titleColor,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: _dividerColor, thickness: 1, height: 1),
        const SizedBox(height: 8),
        // Description: Montserrat 500 14px white — Figma node 6885:9486
        Text(
          l10n.notFoundMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: _font,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            color: _bodyColor,
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    // Design node 6885:9487 — 320×248 px robot mascot illustration.
    // S3 URL is null (asset not yet exported). Fallback: Material icon in a
    // "4[icon]4" row that echoes the 404 mascot composition.
    // Replace with Image.asset('assets/not-found/mm_media_not_found.png')
    // once the asset is added to pubspec.yaml + assets/.
    return Center(
      child: SizedBox(
        width: 320,
        height: 248,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '4',
              style: TextStyle(
                fontFamily: _font,
                fontSize: 72,
                fontWeight: FontWeight.w700,
                color: _titleColor,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.search_off_rounded,
                size: 80,
                color: AppColors.buttonPrimary,
              ),
            ),
            const Text(
              '4',
              style: TextStyle(
                fontFamily: _font,
                fontSize: 72,
                fontWeight: FontWeight.w700,
                color: _titleColor,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCtaButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPrimaryAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonBg,
          foregroundColor: _buttonFg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          textStyle: const TextStyle(
            fontFamily: _font,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
          ),
        ),
        child: Text(primaryLabel),
      ),
    );
  }
}

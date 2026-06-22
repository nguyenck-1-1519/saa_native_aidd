import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/auth_providers.dart';
import '../widgets/google_login_button.dart';
import '../widgets/language_selector.dart';

/// SAA 2025 login screen (mms screen 8HGlvYGJWq). Brand key-visual background,
/// logo + language selector header, "ROOT FURTHER" brand mark, localized
/// description, Google login CTA, localized copyright.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // Surface auth failures as a localized snackbar (FUN_010/015).
    ref.listen<AsyncValue<void>>(loginControllerProvider, (prev, next) {
      if (next is AsyncError) {
        final message = _failureMessage(l10n, next.error);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_keyvisual_bg.png', fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/saa_logo.png', height: 44),
                      const LanguageSelector(),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Image.asset(
                    'assets/images/root_further.png',
                    width: 247,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.loginDescription, style: AppTypography.description),
                  const Spacer(),
                  const Center(child: GoogleLoginButton()),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      l10n.loginCopyright,
                      textAlign: TextAlign.center,
                      style: AppTypography.copyright.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _failureMessage(AppLocalizations l10n, Object? error) {
    return switch (error) {
      NetworkFailure() => l10n.authErrorNetwork,
      AccountDisabled() => l10n.authErrorAccountDisabled,
      _ => l10n.authErrorGeneric,
    };
  }
}

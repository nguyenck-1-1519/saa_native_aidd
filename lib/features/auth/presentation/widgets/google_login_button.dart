import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

/// Primary CTA: "LOGIN With Google" + Google icon (mms_5_Button).
///
/// Shows a spinner and disables itself while authenticating (FUN_006); the
/// double-click guard lives in [LoginController] (FUN_008).
class GoogleLoginButton extends ConsumerWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isLoading = ref.watch(loginControllerProvider).isLoading;

    return SizedBox(
      width: 246,
      height: 40,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () => ref.read(loginControllerProvider.notifier).signInWithGoogle(),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onButton,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      l10n.loginButton,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/images/google_g.svg',
                    width: 18,
                    height: 18,
                  ),
                ],
              ),
      ),
    );
  }
}

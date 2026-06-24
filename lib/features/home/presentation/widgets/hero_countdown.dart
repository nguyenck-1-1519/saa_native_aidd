import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/countdown_state.dart';

/// Presentational hero section for the SAA 2025 Home screen.
///
/// Displays the Root Further logo, an optional countdown clock, event info,
/// and two CTA buttons. No state management — all values are injected via
/// constructor parameters. Timers and data fetching belong to the provider
/// layer (Track B).
class HeroCountdown extends StatelessWidget {
  const HeroCountdown({
    super.key,
    required this.countdown,
    this.onAboutAward,
    this.onAboutKudos,
  });

  final CountdownState countdown;
  final VoidCallback? onAboutAward;
  final VoidCallback? onAboutKudos;

  static const _gold = Color(0xFFFFEA9E);
  static const _darkBg = Color(0xFF00101A);
  static const _goldBorder = Color(0xFF998C5F);
  static const _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _logo(),
          const SizedBox(height: 32),
          _countdownSection(context),
          const SizedBox(height: 32),
          _eventInfo(),
          const SizedBox(height: 32),
          _actionsRow(context),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Logo
  // -------------------------------------------------------------------------

  Widget _logo() {
    return Image.asset(
      'assets/images/home/Logo_RootFuther.png',
      width: 247,
      height: 109,
      fit: BoxFit.contain,
    );
  }

  // -------------------------------------------------------------------------
  // Countdown section
  // -------------------------------------------------------------------------

  Widget _countdownSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            countdown.isElapsed ? l10n.homeEventEnded : l10n.homeComingSoon,
            style: _montserrat(
              fontSize: 14,
              weight: FontWeight.w300,
              color: _white,
              height: 20 / 14,
              letterSpacing: 0.25,
            ),
          ),
        ),
        SizedBox(
          height: 84,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _countdownUnit(_pad(countdown.days), 'DAYS'),
                const SizedBox(width: 16),
                _countdownUnit(_pad(countdown.hours), 'HOURS'),
                const SizedBox(width: 16),
                _countdownUnit(_pad(countdown.minutes), 'MINUTES'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _countdownUnit(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: _montserrat(
            fontSize: 40,
            weight: FontWeight.w600,
            color: _white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: _montserrat(
            fontSize: 18,
            weight: FontWeight.w400,
            color: _white,
            height: 24 / 18,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Event info — date/venue/livestream lines have no ARB keys, kept literal
  // -------------------------------------------------------------------------

  Widget _eventInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow('Thời gian: ', '26/12/2025'),
        const SizedBox(height: 8),
        _infoRow('Địa điểm:', 'Âu Cơ Art Center'),
        const SizedBox(height: 8),
        Text(
          'Tường thuật trực tiếp tại Group Facebook Sun* Family',
          style: _montserrat(
            fontSize: 14,
            weight: FontWeight.w400,
            color: _white,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: _montserrat(
              fontSize: 14,
              weight: FontWeight.w300,
              color: _white,
            ),
          ),
          TextSpan(
            text: value,
            style: _montserrat(
              fontSize: 18,
              weight: FontWeight.w400,
              color: _gold,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Actions row
  // -------------------------------------------------------------------------

  Widget _actionsRow(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          _aboutAwardButton(l10n),
          const SizedBox(width: 16),
          _aboutKudosButton(l10n),
        ],
      ),
    );
  }

  Widget _aboutAwardButton(AppLocalizations l10n) {
    return GestureDetector(
      onTap: onAboutAward,
      child: Container(
        width: 160,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _gold,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                l10n.homeAboutAward,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _montserrat(
                  fontSize: 14,
                  weight: FontWeight.w500,
                  color: _darkBg,
                ),
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/images/home/icon_arrow.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutKudosButton(AppLocalizations l10n) {
    return GestureDetector(
      onTap: onAboutKudos,
      child: Container(
        width: 159,
        height: 40,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0x1AFFEA9E), // rgba(255,234,158,0.10)
          border: Border.all(color: _goldBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                l10n.homeAboutKudos,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _montserrat(
                  fontSize: 14,
                  weight: FontWeight.w500,
                  color: _white,
                ),
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/images/home/icon_arrow.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  static String _pad(int n) => n.clamp(0, 99).toString().padLeft(2, '0');

  static TextStyle _montserrat({
    required double fontSize,
    required FontWeight weight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: fontSize,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/entities/award_detail.dart';
import 'award_stat_row.dart';

/// Award detail section (mms_2.3_award, 335×variable from MoMorph).
///
/// Layout (column, gap 16, center-aligned):
///   1. Badge image (160×160, glow shadow) — Award_BG + name overlay
///   2. Award info: icon + name (14 w700 gold) + description (14 w300 white)
///   3. Divider → "Số lượng giải thưởng" stat row
///   4. Divider → "Giá trị giải thưởng" stat row
class AwardDetailBlock extends StatelessWidget {
  const AwardDetailBlock({
    super.key,
    required this.award,
  });

  final AwardDetail award;

  static const _gold = Color(0xFFFFEA9E);
  static const _white = Colors.white;
  static const _divider = Color(0xFF2E3940);
  static const _glowColor = Color(0xFFFAE287);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Full-width (flexes on narrower viewports — no fixed 335 that overflows).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _badgeImage(),
        const SizedBox(height: 16),
        _awardInfoSection(),
        const SizedBox(height: 16),
        const Divider(color: _divider, thickness: 1, height: 1),
        const SizedBox(height: 16),
        AwardStatRow(
          icon: Icons.diamond_outlined,
          label: l10n.awardsQuantityLabel,
          value: award.quantityValue,
          unit: award.quantityUnit,
        ),
        const SizedBox(height: 16),
        const Divider(color: _divider, thickness: 1, height: 1),
        const SizedBox(height: 16),
        AwardStatRow(
          icon: Icons.flag_outlined,
          label: l10n.awardsValueLabel,
          value: award.prizeValue,
          unit: award.prizeNote,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Badge (160×160)
  // ---------------------------------------------------------------------------

  Widget _badgeImage() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11.43),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), // 25% black
            blurRadius: 1.905,
            offset: Offset(0, 1.905),
          ),
          BoxShadow(
            color: _glowColor,
            blurRadius: 2.857,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.43),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/home/Award_BG.png',
              width: 160,
              height: 160,
              fit: BoxFit.cover,
            ),
            Center(child: _badgeNameOverlay()),
          ],
        ),
      ),
    );
  }

  Widget _badgeNameOverlay() {
    final ref = award.badgeImageRef;

    if (ref.isEmpty) {
      return Text(
        award.name.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: _gold,
          letterSpacing: 1.0,
        ),
      );
    }

    if (ref.endsWith('.svg')) {
      return SvgPicture.asset(ref, fit: BoxFit.contain);
    }

    return Image.asset(
      ref,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Text(
        award.name.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: _gold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Award name + description
  // ---------------------------------------------------------------------------

  Widget _awardInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // IC Award node had null S3 URL; using emoji_events as visual equivalent.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events, color: _gold, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                award.name,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _gold,
                  height: 20 / 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          award.description,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: _white,
            height: 20 / 14,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }
}

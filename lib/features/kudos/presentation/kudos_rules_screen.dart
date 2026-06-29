import 'package:flutter/material.dart';

import '../../../core/theme/app_typography.dart';
import 'widgets/kudos_rules_content.dart';
import 'widgets/kudos_rules_rewards_badges.dart';

/// Kudos "Thể lệ" (rules) static content screen.
///
/// Design source: MoMorph zIuFaHAid4 "[iOS] Thể lệ"
/// https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/zIuFaHAid4
///
/// Sections (top→bottom): header (Hero-badge intro) → 4 Hero tiers →
/// 6-icon collection → Kudos Quốc Dân → action bar (Đóng / Viết Kudos).
/// Stateless — back pops. Route: /kudos/rules.
class KudosRulesScreen extends StatelessWidget {
  const KudosRulesScreen({super.key, this.onWriteKudo});

  /// Called when "Viết Kudos" is tapped (router wires a real push).
  final VoidCallback? onWriteKudo;

  static const Color _kBg = Color(0xFF00101A);
  static const Color _kDivider = Color(0xFF2E3940);
  static const double _hPad = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Thể lệ',
          style: AppTypography.montserrat(
            fontSize: 17,
            weight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const _KeyvisualBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(_hPad, 8, _hPad, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KudosRulesHeader(),
                  const SizedBox(height: 24),
                  Container(height: 1, color: _kDivider),
                  const SizedBox(height: 24),
                  const KudosHeroTiers(),
                  const SizedBox(height: 24),
                  const KudosCollectionSection(),
                  const SizedBox(height: 24),
                  const KudosQuocDanSection(),
                  const SizedBox(height: 32),
                  _KudosRulesActionBar(onWriteKudo: onWriteKudo),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Key-visual background — top band fading into the dark base
// ---------------------------------------------------------------------------

class _KeyvisualBackground extends StatelessWidget {
  const _KeyvisualBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 360,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/home/Keyvisual_BG.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.35, 1.0],
                  colors: [Color(0x0000101A), Color(0xFF00101A)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action bar: Đóng + Viết Kudos
// ---------------------------------------------------------------------------

class _KudosRulesActionBar extends StatelessWidget {
  const _KudosRulesActionBar({this.onWriteKudo});

  final VoidCallback? onWriteKudo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.maybePop(context),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0x1AFFEA9E),
              side: const BorderSide(color: Color(0xFF998C5F), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Đóng',
              style: AppTypography.montserrat(
                fontSize: 14,
                weight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: onWriteKudo ?? () => Navigator.maybePop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFEA9E),
              foregroundColor: const Color(0xFF00101A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Viết Kudos',
              style: AppTypography.montserrat(
                fontSize: 14,
                weight: FontWeight.w600,
                color: const Color(0xFF00101A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

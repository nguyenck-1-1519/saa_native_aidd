import 'package:flutter/material.dart';

import 'widgets/kudos_rules_badges.dart';
import 'widgets/kudos_rules_content.dart';
import 'widgets/kudos_rules_rewards_badges.dart';

/// Kudos "Thể lệ" (rules) static content screen.
///
/// Presents the program rules as a scrollable content panel:
/// header, description, rewards list, 6 Kudos badge tiles, and
/// two action buttons (Đóng → pop, Viết KUDOS → push /write-kudo).
///
/// Design source: MoMorph b1Filzi9i6 "Thể lệ UPDATE"
/// https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/b1Filzi9i6
///
/// Stateless — no providers. Back pops. Route: /kudos/rules (wired at INT).
class KudosRulesScreen extends StatelessWidget {
  const KudosRulesScreen({
    super.key,
    this.onWriteKudo,
  });

  /// Called when "Viết KUDOS" is tapped.
  /// Defaults to Navigator.maybePop (INT will wire a real push).
  final VoidCallback? onWriteKudo;

  static const Color _kBg = Color(0xFF00101A);
  static const double _hPad = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Thể lệ', // TODO(l10n): move to arb
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(_hPad, 24, _hPad, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KudosRulesSectionLabel(),
              const SizedBox(height: 16),
              const KudosRulesCard(),
              const SizedBox(height: 24),
              const KudosRewardsSection(),
              const SizedBox(height: 24),
              const KudosBadgesSection(),
              const SizedBox(height: 32),
              _KudosRulesActionBar(onWriteKudo: onWriteKudo),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action bar: Đóng + Viết KUDOS
// ---------------------------------------------------------------------------

class _KudosRulesActionBar extends StatelessWidget {
  const _KudosRulesActionBar({this.onWriteKudo});

  final VoidCallback? onWriteKudo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.close, size: 18, color: Colors.white),
            label: const Text(
              'Đóng', // TODO(l10n): move to arb
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0x1AFFEA9E),
              side: const BorderSide(color: Color(0xFF998C5F), width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onWriteKudo ?? () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: Color(0xFF00101A),
            ),
            label: const Text(
              'Viết KUDOS', // TODO(l10n): move to arb
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00101A),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFEA9E),
              foregroundColor: const Color(0xFF00101A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ),
          ),
        ),
      ],
    );
  }
}

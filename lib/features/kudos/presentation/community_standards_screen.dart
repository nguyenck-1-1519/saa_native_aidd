import 'package:flutter/material.dart';

import 'widgets/community_standards_sections.dart';
import 'widgets/security_standards_section.dart';

// TODO(l10n): move all VN string literals below to app_localizations.arb

/// Community-standards static content screen.
///
/// Design: [iOS] Sun*Kudos_Tiêu chuẩn cộng đồng
/// MoMorph: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/xms7csmDhD
///
/// Stateless scrollable screen — "back" pops to caller (WriteKudoScreen).
/// No router registration here; route `/kudos/community-standards` is wired
/// by a separate integration step.
class CommunityStandardsScreen extends StatelessWidget {
  const CommunityStandardsScreen({super.key});

  // Design tokens — match #00101A bg / Montserrat / gold palette from kudos_screen.dart.
  static const Color _bg = Color(0xFF00101A);
  static const double _hPad = 20;

  // TODO(l10n): move to arb key `communityStandardsTitle`
  static const String _appBarTitle = 'Tiêu chuẩn chung';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          _appBarTitle, // TODO(l10n): AppLocalizations.of(context).communityStandardsTitle
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section A — Logo Banner (ROOT FURTHER branding image)
              // Spec: mms_A_Frame 482 (6885:10829) — file_or_image, always visible.
              _BannerSection(),

              // Section B — Community Standards
              const Padding(
                padding: EdgeInsets.fromLTRB(_hPad, 20, _hPad, 0),
                child: CommunityStandardsSection(),
              ),

              // Section C — Security Standards
              const Padding(
                padding: EdgeInsets.fromLTRB(_hPad, 24, _hPad, 32),
                child: SecurityStandardsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section A — Banner
// ---------------------------------------------------------------------------

class _BannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/home/Sunkudos_banner.png',
      width: double.infinity,
      fit: BoxFit.fitWidth,
      errorBuilder: (_, __, ___) => Container(
        height: 145,
        color: const Color(0xFF0A1A26),
        child: const Center(
          child: Icon(Icons.image_not_supported, color: Colors.white38, size: 40),
        ),
      ),
    );
  }
}

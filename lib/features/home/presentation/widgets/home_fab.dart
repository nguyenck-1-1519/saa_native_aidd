import 'package:flutter/material.dart';

/// Presentational floating action button for the SAA 2025 Home screen
/// (node 6885:9058 mms_6_float button).
///
/// This is a custom styled widget — NOT a FloatingActionButton. Place it in
/// `Scaffold.floatingActionButton`. No state management — callbacks injected
/// via constructor.
///
/// Design: 89×48px container, borderRadius 100, bg #FFEA9E.
/// Inside row: [edit icon | "/" divider | star icon], gap 8px, padding 8px.
class HomeFab extends StatelessWidget {
  const HomeFab({
    super.key,
    this.onPencil,
    this.onKudos,
  });

  final VoidCallback? onPencil;
  final VoidCallback? onKudos;

  static const _gold = Color(0xFFFFEA9E);
  static const _darkBg = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 89,
      height: 48,
      decoration: BoxDecoration(
        color: _gold,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000), // rgba(0,0,0,0.25)
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Color(0xFFFAE287),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _penGroup(),
          const SizedBox(width: 6),
          _kudosIcon(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Left group: pen icon + "/" divider
  // ---------------------------------------------------------------------------

  Widget _penGroup() {
    return GestureDetector(
      onTap: onPencil,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.edit,
            size: 20,
            color: _darkBg,
          ),
          const SizedBox(width: 6),
          // Thin "/" separator — lighter weight + symmetric breathing room so
          // it reads as a centred divider, not a bold mark glued to the pencil.
          Text(
            '/',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w300,
              fontVariations: const [FontVariation('wght', 300)],
              color: _darkBg,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Kudos icon
  // ---------------------------------------------------------------------------

  Widget _kudosIcon() {
    return GestureDetector(
      onTap: onKudos,
      behavior: HitTestBehavior.opaque,
      // Sun* Kudos flame mark (design node MM_MEDIA_IC_Kudos Logo) — replaces
      // the placeholder Material star. The asset is the flame centred on a
      // square transparent canvas, so a square box + BoxFit.contain keeps it
      // optically centred (it previously hugged the top-left corner).
      child: Image.asset(
        'assets/images/home/ic_kudos_flame.png',
        width: 20,
        height: 20,
        fit: BoxFit.contain,
      ),
    );
  }
}

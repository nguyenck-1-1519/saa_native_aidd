part of '../access_denied_screen.dart';

// ── Top navigation bar ────────────────────────────────────────────────────

class _TopNavBar extends StatelessWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42,
      color: const Color(0xFF00101A),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 7),
      // Back arrow — 18×24 px per design. No vector export from MoMorph.
      child: SizedBox(
        width: 18,
        height: 24,
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }
}

// ── Main content card ─────────────────────────────────────────────────────

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimaryAction,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildIllustration(),
          const SizedBox(height: 24),
          _buildSeparator(),
          const SizedBox(height: 25),
          _buildPrimaryButton(),
        ],
      ),
    );
  }

  // Title + divider + subtitle
  Widget _buildHeader() {
    const divider = Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 1,
        child: ColoredBox(color: Color(0xFF2E3940)),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              height: 24 / 18,
              color: Color(0xFFFFEA9E),
              letterSpacing: 0,
            ),
          ),
        ),
        divider,
        SizedBox(
          width: double.infinity,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 20 / 14,
              color: Colors.white,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }

  /// Illustration placeholder — 320×248 matches design rect for mms_2.1.
  Widget _buildIllustration() {
    return const SizedBox(
      width: 320,
      height: 248,
      child: Center(
        child: Icon(
          Icons.lock_outline_rounded,
          size: 120,
          color: Color(0xFFFFEA9E),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return const SizedBox(
      width: double.infinity,
      height: 1,
      child: ColoredBox(color: Color(0xFF2E3940)),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: TextButton(
        onPressed: onPrimaryAction,
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFFFEA9E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
        ),
        child: Text(
          primaryLabel,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 20 / 14,
            color: Color(0xFF00101A),
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

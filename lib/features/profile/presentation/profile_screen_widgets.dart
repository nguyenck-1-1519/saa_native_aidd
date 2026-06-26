part of 'profile_screen.dart';

// ---------------------------------------------------------------------------
// _ProfileTopBar
// ---------------------------------------------------------------------------

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({
    required this.topPadding,
    required this.isSelf,
    this.onBack,
    this.onSettings,
  });

  final double topPadding;
  final bool isSelf;
  final VoidCallback? onBack;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: topPadding + 60,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isSelf)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: onBack ?? () => Navigator.maybePop(context),
              )
            else
              const SizedBox(width: 48),
            if (isSelf && onSettings != null)
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
                onPressed: onSettings,
              )
            else
              const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SendKudoButton  (other-profile only, design node 6885:10427)
// ---------------------------------------------------------------------------

class _SendKudoButton extends StatelessWidget {
  const _SendKudoButton({required this.recipientName, this.onTap});

  final String recipientName;
  final VoidCallback? onTap;

  static const Color _border = Color(0xFF998C5F);
  static const Color _bg = Color(0x1AFFEA9E);

  @override
  Widget build(BuildContext context) {
    final shortName = recipientName.split(' ').first;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            const Icon(Icons.favorite_border, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                // TODO(l10n): move to arb
                'Gửi lời cảm ơn và ghi nhận tới $shortName...',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

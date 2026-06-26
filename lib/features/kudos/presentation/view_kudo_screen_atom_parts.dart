// Private atomic widgets for ViewKudoScreen — avatar, chip, divider.
// Do NOT import this file directly — use view_kudo_screen.dart.
part of 'view_kudo_screen.dart';

// ── Avatar ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.size, this.isAnonymous = false});

  final String? url;
  final double size;
  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      child: url != null && url!.isNotEmpty
          ? Image.network(
              url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
          : _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isAnonymous ? const Color(0xFF4A5568) : const Color(0xFFBDBDBD),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isAnonymous ? Icons.person_outline : Icons.person,
        size: size * 0.55,
        color: Colors.white,
      ),
    );
  }
}

// ── Hero tag chip ────────────────────────────────────────────────────────────

class _HeroTagChip extends StatelessWidget {
  const _HeroTagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEA9E).withAlpha(51), // ~20% opacity gold
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _kGold, width: 0.8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _kGold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

// ── Horizontal divider ────────────────────────────────────────────────────────

class _HorizontalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: _kDivider);
}

// ── Image tile ────────────────────────────────────────────────────────────────

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.url,
    required this.size,
    required this.radius,
  });

  final String url;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isNotEmpty
          ? Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Icon(
        Icons.image_outlined,
        size: 24,
        color: Color(0xFF9E9E9E),
      ),
    );
  }
}

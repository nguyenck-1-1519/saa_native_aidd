part of 'profile_kudos_card.dart';

// --- B.4 Content block ---

class _ContentBlock extends StatelessWidget {
  const _ContentBlock({required this.kudo});

  final ProfileKudoView kudo;

  static const Color _timestamp = Color(0xFF999999);
  static const Color _titleColor = Color(0xFF00101A);
  static const Color _messageBg = Color(0x66FFEA9E);
  static const Color _messageBorder = Color(0xFFFFEA9E);
  static const Color _messageText = Color(0xFF00101A);
  static const Color _hashtagColor = Color(0xFFD4271D);
  static const Color _imageBorder = Color(0xFFFFEA9E);
  static const Color _imagePlaceholder = Color(0xFFEEEEEE);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          kudo.postedAt,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: _timestamp,
            height: 11.1 / 10,
            letterSpacing: 0.23,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          kudo.title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: _titleColor,
            height: 11.1 / 10,
            letterSpacing: 0.23,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _messageBg,
            borderRadius: BorderRadius.circular(5.6),
            border: Border.all(color: _messageBorder, width: 0.463),
          ),
          child: Text(
            kudo.message,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: _messageText,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (kudo.imageUrls.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: kudo.imageUrls.take(4).map((url) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _imagePlaceholder,
                    borderRadius: BorderRadius.circular(1.5),
                    border: Border.all(color: _imageBorder, width: 0.364),
                    image: (url.isNotEmpty)
                        ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        if (kudo.hashtags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            kudo.hashtags.join(' '),
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: _hashtagColor,
              height: 11.1 / 10,
              letterSpacing: 0.23,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

// --- B.4.4 Action bar ---

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.heartCount});

  final int heartCount;

  static const Color _textColor = Color(0xFF00101A);

  String _formatHearts(int count) {
    if (count >= 1000) {
      final k = count / 1000.0;
      // Always append 'k'. Show integer when exact (2000 → "2k"),
      // 1 decimal when fractional (1500 → "1.5k").
      final formatted = k == k.truncateToDouble()
          ? k.toInt().toString()
          : k.toStringAsFixed(1);
      return '${formatted}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatHearts(heartCount),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: _textColor,
                height: 14.8 / 10,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.favorite_border, size: 16, color: _textColor),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionButton(icon: Icons.chat_bubble_outline, label: 'Bình luận'), // TODO(l10n) // TODO(backend)
            const SizedBox(width: 4),
            _ActionButton(icon: Icons.share_outlined, label: 'Chia sẻ'), // TODO(l10n) // TODO(backend)
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  static const Color _color = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: _color,
              height: 12 / 10,
            ),
          ),
          const SizedBox(width: 2),
          Icon(icon, size: 16, color: _color),
        ],
      ),
    );
  }
}

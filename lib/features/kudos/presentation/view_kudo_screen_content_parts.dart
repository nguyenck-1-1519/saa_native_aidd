// Private helper widgets for ViewKudoScreen — content/action section.
// Do NOT import this file directly — use view_kudo_screen.dart.
part of 'view_kudo_screen.dart';

// ── B.4 Content section ───────────────────────────────────────────────────────

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.kudo, this.onCopyLink});

  final KudoDetailViewModel kudo;
  final VoidCallback? onCopyLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // B.4.1 — Posted date/time
        Text(
          kudo.postedAt,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: _kTimestamp,
          ),
        ),
        const SizedBox(height: 4),
        // B.4.0 — Title
        Text(
          kudo.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _kCardText,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        // B.4.2 — Full message (no truncation in detail view)
        Text(
          kudo.message,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _kCardText,
            height: 1.5,
          ),
        ),
        // F.2 — Attached images
        if (kudo.imageUrls.isNotEmpty) ...[
          const SizedBox(height: 10),
          _ImageGrid(imageUrls: kudo.imageUrls),
        ],
        // B.4.3 — Hashtags
        if (kudo.hashtags.isNotEmpty) ...[
          const SizedBox(height: 8),
          _HashtagRow(hashtags: kudo.hashtags),
        ],
        const SizedBox(height: 10),
        _HorizontalDivider(),
        const SizedBox(height: 8),
        // B.4.4 — Action bar
        _DetailActionBar(
          heartCount: kudo.heartCount,
          onCopyLink: onCopyLink,
        ),
      ],
    );
  }
}

// ── F.2 Image grid ────────────────────────────────────────────────────────────

/// Renders up to 5 attached images in a scrollable row of fixed-size tiles.
class _ImageGrid extends StatelessWidget {
  const _ImageGrid({required this.imageUrls});

  final List<String> imageUrls;

  static const double _tileSize = 60;
  static const double _gap = 6;
  static const double _radius = 6;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _tileSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (_, __) => const SizedBox(width: _gap),
        itemBuilder: (context, index) =>
            _ImageTile(url: imageUrls[index], size: _tileSize, radius: _radius),
      ),
    );
  }
}

// ── B.4.3 Hashtag row ─────────────────────────────────────────────────────────

class _HashtagRow extends StatelessWidget {
  const _HashtagRow({required this.hashtags});

  final List<String> hashtags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: hashtags
          .map(
            (tag) => Text(
              tag,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: _kHashtagColor,
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── B.4.4 Detail action bar ──────────────────────────────────────────────────

class _DetailActionBar extends StatelessWidget {
  const _DetailActionBar({
    required this.heartCount,
    this.onCopyLink,
  });

  final int heartCount;
  final VoidCallback? onCopyLink;

  static const _labelStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: _kCardText,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.favorite, size: 14, color: _kHeartRed),
        const SizedBox(width: 4),
        Text(
          '$heartCount',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _kCardText,
          ),
        ),
        const Spacer(),
        Flexible(
          child: GestureDetector(
            onTap: onCopyLink,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context).kudosDetailCopyLink,
                    style: _labelStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.link, size: 14, color: _kCardText),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  AppLocalizations.of(context).kudosViewDetail,
                  style: _labelStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.open_in_new, size: 12, color: _kCardText),
            ],
          ),
        ),
      ],
    );
  }
}

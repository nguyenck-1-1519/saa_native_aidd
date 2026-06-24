import 'package:flutter/material.dart';

/// Spotlight Board widget showing the word-cloud style Kudos highlight.
///
/// Design source: MoMorph node B.6. Spotlight board 6885:9099.
/// Tries to load assets/images/kudos/spotlight_board.png first;
/// falls back to a styled word-cloud container if the asset is missing.
class SpotlightBoard extends StatelessWidget {
  const SpotlightBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(title: 'SPOTLIGHT BOARD'),
        const SizedBox(height: 12),
        _SpotlightImage(),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _divider = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Sun* Annual Awards 2025',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 1, color: _divider)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: _gold,
          ),
        ),
      ],
    );
  }
}

// ── Spotlight image with fallback ─────────────────────────────────────────────

class _SpotlightImage extends StatelessWidget {
  const _SpotlightImage();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/kudos/spotlight_board.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _FallbackWordCloud(),
        ),
      ),
    );
  }
}

class _FallbackWordCloud extends StatelessWidget {
  const _FallbackWordCloud();

  static const Color _dark = Color(0xFF00070C);
  static const Color _gold = Color(0xFFFFEA9E);

  static const List<String> _names = [
    'Đỗ hoàng Hiệp',
    'Dương thúy An',
    'Mai phương Thúy',
    'Nguyễn Văn Quy',
    'Nguyễn Bá Chức',
    'Lê Kiều Trang',
    'Nguyễn Hoàng Linh',
  ];

  static const List<double> _sizes = [8, 10, 12, 14];
  static const List<double> _opacities = [0.6, 0.8, 1.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _dark,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '388 KUDOS',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _gold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'SPOTLIGHT BOARD',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: List.generate(_names.length, (i) {
                  final size = _sizes[i % _sizes.length];
                  final opacity = _opacities[i % _opacities.length];
                  return Opacity(
                    opacity: opacity,
                    child: Text(
                      _names[i],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

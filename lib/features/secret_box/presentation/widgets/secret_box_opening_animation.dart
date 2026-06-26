import 'package:flutter/material.dart';

/// Animated box-opening widget for [SecretBoxView.opening].
///
/// Design source: MoMorph KUmv414uC9 — node 6885:9564.
/// The opening state shows the same layout as closed but with:
///   • a different box image (mm_media_mở quà — node 6885:9572, S3 null)
///   • a pulsing scale + glow animation to signal "revealing"
///
/// Asset swap path: drop PNG at assets/images/secret_box/box_opening.png
/// and declare it in pubspec.yaml under assets/images/secret_box/.
///
/// Pure presentational widget — caller drives state machine transition.
class SecretBoxOpeningAnimation extends StatefulWidget {
  const SecretBoxOpeningAnimation({
    super.key,
    /// Called once the opening animation completes so the caller can
    /// advance to [SecretBoxView.revealed].
    required this.onAnimationComplete,
  });

  final VoidCallback onAnimationComplete;

  @override
  State<SecretBoxOpeningAnimation> createState() =>
      _SecretBoxOpeningAnimationState();
}

class _SecretBoxOpeningAnimationState extends State<SecretBoxOpeningAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    // Total duration: 1 200 ms
    // Phase 1 (0→50%): scale up 1.0→1.15, glow fade in
    // Phase 2 (50→100%): scale back 1.15→0.0 (box "bursts open"), opacity out
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    // Glow brightness: 0→1 over first half, stays at 1
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward().whenComplete(() {
      if (mounted) widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _opacity,
          child: Transform.scale(
            scale: _scale.value,
            child: _GlowingBox(glowIntensity: _glow.value),
          ),
        );
      },
    );
  }
}

// ── Box with glow overlay ─────────────────────────────────────────────────

class _GlowingBox extends StatelessWidget {
  const _GlowingBox({required this.glowIntensity});

  final double glowIntensity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Box image (opening variant)
          Positioned.fill(
            child: Image.asset(
              'assets/images/secret_box/box_opening.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _OpeningPlaceholder(),
            ),
          ),
          // Glow overlay
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFFEA9E).withValues(alpha: 0.35 * glowIntensity),
                      Colors.transparent,
                    ],
                    radius: 0.9,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpeningPlaceholder extends StatelessWidget {
  const _OpeningPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF001828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEA9E), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFEA9E).withValues(alpha: 0.4),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Color(0xFFFFEA9E),
        size: 80,
      ),
    );
  }
}

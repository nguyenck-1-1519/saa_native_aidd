import 'package:flutter/material.dart';

/// A labelled stat row used in [AwardDetailBlock] for quantity and prize sections.
///
/// Layout (column, gap 12):
///   - title row: [icon] + [label] (Montserrat 14 w700 gold)
///   - value row: [value] (18 w700 white) + [unit] (14 w300 white)
class AwardStatRow extends StatelessWidget {
  const AwardStatRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  final IconData icon;
  final String label;
  final String value;
  final String unit;

  static const _gold = Color(0xFFFFEA9E);
  static const _white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: _gold, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _gold,
                  height: 20 / 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Value + unit row (baseline-aligned)
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$value ',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _white,
                  height: 24 / 18,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: _white,
                  height: 20 / 14,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

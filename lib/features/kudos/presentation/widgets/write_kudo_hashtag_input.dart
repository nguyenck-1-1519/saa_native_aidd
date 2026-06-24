import 'package:flutter/material.dart';

/// Hashtag chip row for the Write Kudo form.
///
/// Functional local state — chips add/remove, capped at [maxTags] (5).
/// The "+ Hashtag (Tối đa 5)" button is hidden/disabled when the cap is reached.
/// An [errorText] is shown below when validation fails.
///
/// Design source: mms_E_Hashtag (6885:9324).
/// Chip border: 0.447px #998C5F, bg #FFF, border-radius 3.574px.
class WriteKudoHashtagInput extends StatelessWidget {
  const WriteKudoHashtagInput({
    super.key,
    required this.tags,
    required this.onAdd,
    required this.onRemove,
    this.maxTags = 5,
    this.errorText,
  });

  final List<String> tags;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;
  final int maxTags;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            ...List.generate(tags.length, (i) => _HashtagChip(
              label: tags[i],
              onRemove: () => onRemove(i),
            )),
            if (tags.length < maxTags)
              _AddHashtagButton(onTap: onAdd),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: Color(0xFFCF1322),
              height: 16 / 11,
            ),
          ),
        ],
      ],
    );
  }
}

class _HashtagChip extends StatelessWidget {
  const _HashtagChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  static const Color _border = Color(0xFF998C5F);
  static const Color _removeRed = Color(0xFFD4271D);
  static const Color _textDark = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border, width: 0.5),
        borderRadius: BorderRadius.circular(3.574),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$label',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _textDark,
              height: 16 / 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 12, color: _removeRed),
          ),
        ],
      ),
    );
  }
}

class _AddHashtagButton extends StatelessWidget {
  const _AddHashtagButton({required this.onTap});

  final VoidCallback onTap;

  static const Color _border = Color(0xFF998C5F);
  static const Color _textGray = Color(0xFF999999);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 3.574, vertical: 1.787),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _border, width: 0.5),
          borderRadius: BorderRadius.circular(3.574),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: _textGray),
            const SizedBox(width: 1.787),
            Flexible(
              child: Text(
                'Hashtag (Tối đa 5)',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: _textGray,
                  height: 16 / 12,
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

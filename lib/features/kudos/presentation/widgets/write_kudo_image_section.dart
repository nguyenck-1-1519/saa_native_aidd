import 'package:flutter/material.dart';

/// Image thumbnail row for the Write Kudo form — presentational only.
///
/// No image_picker dependency. Each tap on "+ Image" adds a placeholder tile
/// (grey box) up to [maxImages] (5). Each tile has a red ✕ badge to remove it.
///
/// Design source: mms_F_Img (6885:9346).
/// Thumbnail: 32×32 px, border 0.447px #998C5F, border-radius 8.043px.
/// Add button: border 0.447px #998C5F, bg #FFF, border-radius 3.574px.
class WriteKudoImageSection extends StatelessWidget {
  const WriteKudoImageSection({
    super.key,
    required this.imageCount,
    required this.onAdd,
    required this.onRemove,
    this.maxImages = 5,
  });

  final int imageCount;
  final VoidCallback onAdd;
  final void Function(int index) onRemove;
  final int maxImages;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        SizedBox(
          width: 46,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'Image',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF00101A),
                height: 12.51 / 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Thumbnails + add button column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageCount > 0) ...[
                // Thumbnail row
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: List.generate(imageCount, (i) => _ImageThumbnail(
                    onRemove: () => onRemove(i),
                  )),
                ),
                const SizedBox(height: 8),
              ],
              // Add button — hidden when cap reached
              if (imageCount < maxImages)
                _AddImageButton(onTap: onAdd),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  const _ImageThumbnail({required this.onRemove});

  final VoidCallback onRemove;

  static const Color _border = Color(0xFF998C5F);
  static const Color _removeRed = Color(0xFFD4271D);
  static const Color _placeholderBg = Color(0xFFE8E0C8);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _placeholderBg,
              border: Border.all(color: _border, width: 0.5),
              borderRadius: BorderRadius.circular(8.043),
            ),
            child: const Icon(
              Icons.image_outlined,
              size: 16,
              color: Color(0xFF998C5F),
            ),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _removeRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddImageButton extends StatelessWidget {
  const _AddImageButton({required this.onTap});

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
            const Text(
              'Image (Tối đa 5)',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _textGray,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

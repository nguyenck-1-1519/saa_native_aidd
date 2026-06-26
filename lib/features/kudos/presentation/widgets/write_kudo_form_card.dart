import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/kudo_recipient.dart';
import 'write_kudo_field_row.dart';
import 'write_kudo_hashtag_input.dart';
import 'write_kudo_image_section.dart';
import 'write_kudo_message_section.dart';
import 'write_kudo_recipient_suggestions.dart';

const Color _kCardBg = Color(0xFFFFF8E1);
const Color _kBorder = Color(0xFF998C5F);
const Color _kTextDark = Color(0xFF00101A);
const Color _kTextGray = Color(0xFF999999);
const Color _kGold = Color(0xFFFFEA9E);

/// Cream form card composing all Write Kudo fields.
///
/// All state lives in the parent [WriteKudoScreen] and is passed in as
/// controllers/callbacks — this widget is purely presentational layout.
///
/// Design source: "Viết KUDO" frame (6885:9291).
/// bg: rgba(255,248,225,1), border-radius: 10.723px, padding: 18px 12px.
class WriteKudoFormCard extends StatelessWidget {
  const WriteKudoFormCard({
    super.key,
    required this.recipientCtrl,
    required this.titleCtrl,
    required this.messageCtrl,
    required this.hashtags,
    required this.imageCount,
    required this.isAnonymous,
    required this.recipientError,
    required this.titleError,
    required this.messageError,
    required this.hashtagError,
    required this.onClearError,
    required this.onAddHashtag,
    required this.onRemoveHashtag,
    required this.onAddImage,
    required this.onRemoveImage,
    required this.onToggleAnonymous,
    // Recipient search (wired at INT)
    this.onRecipientChanged,
    this.showRecipientSuggestions = false,
    this.recipientSuggestionsAsync,
    this.onSelectRecipient,
    this.onCommunityStandards,
  });

  final TextEditingController recipientCtrl;
  final TextEditingController titleCtrl;
  final TextEditingController messageCtrl;
  final List<String> hashtags;
  final int imageCount;
  final bool isAnonymous;
  final String? recipientError;
  final String? titleError;
  final String? messageError;
  final String? hashtagError;
  final void Function(String field) onClearError;
  final Future<void> Function() onAddHashtag;
  final void Function(int index) onRemoveHashtag;
  final VoidCallback onAddImage;
  final void Function(int index) onRemoveImage;
  final VoidCallback onToggleAnonymous;

  /// Called on every keystroke in the recipient field.
  final ValueChanged<String>? onRecipientChanged;

  /// Whether to show the suggestions dropdown below the recipient field.
  final bool showRecipientSuggestions;

  /// AsyncValue from [recipientSearchControllerProvider]; null hides overlay.
  final AsyncValue<List<KudoRecipient>>? recipientSuggestionsAsync;

  /// Called when the user picks a suggestion row.
  final ValueChanged<KudoRecipient>? onSelectRecipient;

  final VoidCallback? onCommunityStandards;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(10.723),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gửi lời cám ơn và ghi nhận đến đồng đội',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _kTextDark,
              height: 20 / 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Người nhận* with live search suggestions
          _FieldRow(
            label: 'Người nhận',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WriteKudoSearchField(
                  controller: recipientCtrl,
                  hint: 'Tìm kiếm',
                  error: recipientError,
                  onChanged: onRecipientChanged ?? (_) => onClearError('recipient'),
                ),
                if (showRecipientSuggestions && recipientSuggestionsAsync != null)
                  WriteKudoRecipientSuggestions(
                    suggestionsAsync: recipientSuggestionsAsync!,
                    onSelect: onSelectRecipient,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Danh hiệu* + helper text
          _FieldRow(
            label: 'Danh hiệu',
            child: WriteKudoTextField(
              controller: titleCtrl,
              hint: 'Danh tặng một danh hiệu cho...',
              maxLength: 100,
              error: titleError,
              onChanged: (_) => onClearError('title'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Ví dụ: Người truyền động lực cho tôi.\n'
              'Danh hiệu sẽ hiển thị làm tiêu đề Kudos của bạn.',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _kTextGray,
                height: 16 / 12,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Message* with toolbar
          WriteKudoMessageSection(
            controller: messageCtrl,
            error: messageError,
            onChanged: (_) => onClearError('message'),
            onCommunityStandards: onCommunityStandards,
          ),
          const SizedBox(height: 16),

          // Hashtag* chips
          _LabeledRow(
            label: 'Hashtag',
            child: WriteKudoHashtagInput(
              tags: hashtags,
              onAdd: onAddHashtag,
              onRemove: onRemoveHashtag,
              errorText: hashtagError,
            ),
          ),
          const SizedBox(height: 16),

          // Image (optional) thumbnails
          WriteKudoImageSection(
            imageCount: imageCount,
            onAdd: onAddImage,
            onRemove: onRemoveImage,
          ),
          const SizedBox(height: 16),

          // Anonymous checkbox
          _AnonymousRow(isAnonymous: isAnonymous, onToggle: onToggleAnonymous),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Layout helpers (private — only used within this card)
// ---------------------------------------------------------------------------

/// 93px label | 8px gap | Expanded field — horizontal two-column layout.
class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 93,
          child: WriteKudoFieldLabel(label: label, required: true),
        ),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}

/// 93px label (top-aligned) | 8px gap | Expanded child — for multi-line rows.
class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 93,
          child: WriteKudoFieldLabel(label: label, required: true, topPadding: 8),
        ),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}

/// Anonymous toggle checkbox row. Design: mms_G_Gửi ẩn danh (6885:9363).
class _AnonymousRow extends StatelessWidget {
  const _AnonymousRow({required this.isAnonymous, required this.onToggle});

  final bool isAnonymous;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isAnonymous ? _kGold : Colors.white,
              border: Border.all(color: _kBorder, width: 1),
            ),
            child: isAnonymous
                ? const Icon(Icons.check, size: 16, color: _kTextDark)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Gửi lời cám ơn và ghi nhận ẩn danh',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _kTextGray,
              height: 16 / 12,
            ),
          ),
        ),
      ],
    );
  }
}

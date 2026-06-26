import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../domain/entities/kudo_recipient.dart';
import 'providers/kudos_filter_providers.dart';
import 'widgets/write_kudo_action_bar.dart';
import 'widgets/write_kudo_form_card.dart';

/// Write Kudo form screen — "New Kudo" / "Viết Kudo".
///
/// [ConsumerStatefulWidget] with local form state + validation.
/// Connects to [recipientSearchControllerProvider] for live recipient search.
/// "Tiêu chuẩn cộng đồng" routes to [Routes.communityStandards].
///
/// [onSubmit] fires after valid submission (default: SnackBar "Đã gửi Kudo" + pop).
/// [onCancel] fires on Huỷ (default: [Navigator.maybePop]).
///
/// Design: [iOS] Sun*Kudos_Viết Kudo_default
/// MoMorph: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/7fFAb-K35a
class WriteKudoScreen extends ConsumerStatefulWidget {
  const WriteKudoScreen({
    super.key,
    this.onSubmit,
    this.onCancel,
  });

  final void Function(WriteKudoFormData data)? onSubmit;
  final VoidCallback? onCancel;

  @override
  ConsumerState<WriteKudoScreen> createState() => _WriteKudoScreenState();
}

/// Immutable snapshot of a validated Write Kudo submission.
class WriteKudoFormData {
  const WriteKudoFormData({
    required this.recipient,
    required this.title,
    required this.message,
    required this.hashtags,
    required this.imageCount,
    required this.isAnonymous,
  });

  final String recipient;
  final String title;
  final String message;
  final List<String> hashtags;
  final int imageCount;
  final bool isAnonymous;
}

// ---------------------------------------------------------------------------
// Design tokens
// ---------------------------------------------------------------------------
const Color _kBg = Color(0xFF00101A);

class _WriteKudoScreenState extends ConsumerState<WriteKudoScreen> {
  final _recipientCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  final List<String> _hashtags = [];
  int _imageCount = 0;
  bool _isAnonymous = false;

  /// Tracks the selected recipient (from search results).
  KudoRecipient? _selectedRecipient;

  /// Whether the recipient suggestions overlay is visible.
  bool _showSuggestions = false;

  String? _recipientError;
  String? _titleError;
  String? _messageError;
  String? _hashtagError;

  /// Enables live re-validation on field change after first submit attempt.
  bool _submitted = false;

  @override
  void dispose() {
    _recipientCtrl.dispose();
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _onRecipientChanged(String text) {
    // Trigger debounced search.
    ref.read(recipientSearchControllerProvider.notifier).query(text);
    // Show suggestions when user is typing, hide when they cleared the field.
    setState(() {
      _showSuggestions = text.isNotEmpty;
      _selectedRecipient = null; // clear previous selection on new input
    });
    if (_submitted) setState(() => _recipientError = null);
  }

  void _selectRecipient(KudoRecipient recipient) {
    _recipientCtrl.text = recipient.name;
    setState(() {
      _selectedRecipient = recipient;
      _showSuggestions = false;
      if (_submitted) _recipientError = null;
    });
  }

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  bool _validate() {
    // Valid if a recipient was selected from results, or if the text field
    // has content (fallback for direct text entry).
    final recipientError =
        (_selectedRecipient == null && _recipientCtrl.text.trim().isEmpty)
            ? 'Vui lòng chọn người nhận'
            : null;

    final title = _titleCtrl.text.trim();
    final titleError = title.isEmpty
        ? 'Vui lòng nhập danh hiệu'
        : title.length > 100
            ? 'Danh hiệu tối đa 100 ký tự'
            : null;

    final message = _messageCtrl.text.trim();
    final messageError = message.isEmpty
        ? 'Vui lòng nhập nội dung lời cám ơn'
        : message.length > 1000
            ? 'Nội dung tối đa 1000 ký tự'
            : null;

    final hashtagError =
        _hashtags.isEmpty ? 'Vui lòng thêm ít nhất 1 hashtag' : null;

    setState(() {
      _recipientError = recipientError;
      _titleError = titleError;
      _messageError = messageError;
      _hashtagError = hashtagError;
    });

    return recipientError == null &&
        titleError == null &&
        messageError == null &&
        hashtagError == null;
  }

  void _clearError(String field) {
    if (!_submitted) return;
    setState(() {
      // Recipient errors are cleared by _onRecipientChanged / _selectRecipient.
      if (field == 'title') _titleError = null;
      if (field == 'message') _messageError = null;
    });
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  void _handleCancel() => widget.onCancel != null
      ? widget.onCancel!()
      : Navigator.maybePop(context);

  void _handleSubmit() {
    setState(() => _submitted = true);
    if (!_validate()) return;

    final data = WriteKudoFormData(
      recipient: _recipientCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      message: _messageCtrl.text.trim(),
      hashtags: List.unmodifiable(_hashtags),
      imageCount: _imageCount,
      isAnonymous: _isAnonymous,
    );

    if (widget.onSubmit != null) {
      widget.onSubmit!(data);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã gửi Kudo')));
      Navigator.maybePop(context);
    }
  }

  Future<void> _addHashtag() async {
    if (_hashtags.length >= 5) return;
    // The dialog owns + disposes its own controller (no parent-side leak).
    final tag = await showDialog<String>(
      context: context,
      builder: (ctx) => const _HashtagInputDialog(),
    );
    if (tag != null && tag.isNotEmpty) {
      final newTag = tag;
      setState(() {
        _hashtags.add(newTag);
        if (_submitted) _hashtagError = null;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: _handleCancel,
        ),
        title: const Text(
          'New Kudo',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              WriteKudoFormCard(
                recipientCtrl: _recipientCtrl,
                titleCtrl: _titleCtrl,
                messageCtrl: _messageCtrl,
                hashtags: _hashtags,
                imageCount: _imageCount,
                isAnonymous: _isAnonymous,
                recipientError: _recipientError,
                titleError: _titleError,
                messageError: _messageError,
                hashtagError: _hashtagError,
                onClearError: _clearError,
                onRecipientChanged: _onRecipientChanged,
                showRecipientSuggestions: _showSuggestions,
                recipientSuggestionsAsync: _showSuggestions
                    ? ref.watch(recipientSearchControllerProvider)
                    : null,
                onSelectRecipient: _selectRecipient,
                onAddHashtag: _addHashtag,
                onRemoveHashtag: (i) => setState(() {
                  _hashtags.removeAt(i);
                  if (_submitted && _hashtags.isEmpty) {
                    _hashtagError = 'Vui lòng thêm ít nhất 1 hashtag';
                  }
                }),
                onAddImage: () =>
                    setState(() => _imageCount = (_imageCount + 1).clamp(0, 5)),
                onRemoveImage: (_) =>
                    setState(() => _imageCount = (_imageCount - 1).clamp(0, 5)),
                onToggleAnonymous: () =>
                    setState(() => _isAnonymous = !_isAnonymous),
                onCommunityStandards: () =>
                    context.push(Routes.communityStandards),
              ),
              const SizedBox(height: 16),
              WriteKudoActionBar(
                onCancel: _handleCancel,
                onSubmit: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small dialog that owns and disposes its own [TextEditingController].
/// Returns the trimmed hashtag string (or null on cancel).
class _HashtagInputDialog extends StatefulWidget {
  const _HashtagInputDialog();

  @override
  State<_HashtagInputDialog> createState() => _HashtagInputDialogState();
}

class _HashtagInputDialogState extends State<_HashtagInputDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Thêm Hashtag',
        style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
      ),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        style: const TextStyle(fontFamily: 'Montserrat'),
        decoration: const InputDecoration(
          hintText: 'Nhập hashtag',
          hintStyle: TextStyle(fontFamily: 'Montserrat'),
        ),
        onSubmitted: (v) => Navigator.pop(context, v.trim()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huỷ'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _ctrl.text.trim()),
          child: const Text('Thêm'),
        ),
      ],
    );
  }
}

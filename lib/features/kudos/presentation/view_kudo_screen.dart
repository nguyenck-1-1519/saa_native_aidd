import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';

part 'view_kudo_screen_atom_parts.dart';
part 'view_kudo_screen_parts.dart';
part 'view_kudo_screen_content_parts.dart';

/// View-model carrying all data for a single kudo detail.
///
/// Passed by the calling route; no domain entity imported here (presentation-only).
/// Integration agent maps a real `KudoDetail` entity onto this class.
class KudoDetailViewModel {
  const KudoDetailViewModel({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.senderAvatarUrl,
    required this.recipientName,
    required this.recipientRole,
    required this.recipientCode,
    required this.recipientAvatarUrl,
    required this.senderHeroTag,
    required this.recipientHeroTag,
    required this.postedAt,
    required this.title,
    required this.message,
    required this.hashtags,
    required this.imageUrls,
    required this.heartCount,
    required this.isAnonymous,
  });

  final String id;

  // Sender fields — masked when isAnonymous == true.
  final String senderName;
  final String senderRole;
  final String? senderAvatarUrl;
  final String? senderHeroTag;

  // Recipient fields — always shown.
  final String recipientName;
  final String recipientRole;
  final String recipientCode;
  final String? recipientAvatarUrl;
  final String? recipientHeroTag;

  // Content
  final String postedAt;     // e.g. "10:01 - 01/02/2025"
  final String title;        // e.g. "NGƯỜI HÙNG CỦA LÒNG EM"
  final String message;
  final List<String> hashtags;
  final List<String> imageUrls;
  final int heartCount;

  /// When true, the sender block is masked per the anonymous design (5C2BL6GYXL).
  final bool isAnonymous;
}

// ---------------------------------------------------------------------------
// Mock data extracted from Figma designs (T0TR16k0vH + 5C2BL6GYXL)
// ---------------------------------------------------------------------------

/// Normal kudo mock — from T0TR16k0vH.
const KudoDetailViewModel kMockKudoDetail = KudoDetailViewModel(
  id: 'mock-001',
  senderName: 'Huỳnh T...',
  senderRole: 'Rising Hero',
  senderAvatarUrl: null,
  senderHeroTag: 'Rising Hero',
  recipientName: 'Dương Xuân Huỳnh...',
  recipientRole: 'CECV10',
  recipientCode: 'CECV10',
  recipientAvatarUrl: null,
  recipientHeroTag: 'Legend Hero',
  postedAt: '10:01 - 01/02/2025',
  title: 'NGƯỜI HÙNG CỦA LÒNG EM',
  message:
      'Cảm ơn người em bình thường nhưng phi thường :D Cảm ơn sự chăm chỉ, cần mẫn của em đã tạo '
      'động lực rất nhiều cho team, để luôn nhắc mình luôn phải nỗ lực hơn nữa trong công việc. '
      '<3 và cuộc sốngCảm ơn người em bình thường nhưng phi thường :D Cảm ơn sự chăm chỉ, cần '
      'mẫn của em đã tạo động lực rất nhiều cho team, để luôn nhắc mình luôn phải nỗ lực hơn nữa '
      'trong công việc. <3 và cuộc sống...',
  hashtags: ['#Dedicated', '#Inspiring', '#Dedicated', '#Inspiring', '#Dedicated'],
  imageUrls: ['', '', '', '', ''],
  heartCount: 10,
  isAnonymous: false,
);

/// Anonymous kudo mock — from 5C2BL6GYXL.
const KudoDetailViewModel kMockAnonymousKudoDetail = KudoDetailViewModel(
  id: 'mock-002',
  senderName: 'Anh Hùng Xạ Điêu',
  senderRole: '',
  senderAvatarUrl: null,
  senderHeroTag: null,
  recipientName: 'Dương Xuân Huỳnh...',
  recipientRole: 'CECV10',
  recipientCode: 'CECV10',
  recipientAvatarUrl: null,
  recipientHeroTag: 'Legend Hero',
  postedAt: '10:01 - 01/02/2025',
  title: 'NGƯỜI HÙNG CỦA LÒNG EM',
  message:
      'Cảm ơn người em bình thường nhưng phi thường :D Cảm ơn sự chăm chỉ, cần mẫn của em đã tạo '
      'động lực rất nhiều cho team, để luôn nhắc mình luôn phải nỗ lực hơn nữa trong công việc. '
      '<3 và cuộc sốngCảm ơn người em bình thường nhưng phi thường :D Cảm ơn sự chăm chỉ, cần '
      'mẫn của em đã tạo động lực rất nhiều cho team, để luôn nhắc mình luôn phải nỗ lực hơn nữa '
      'trong công việc. <3 và cuộc sống...',
  hashtags: ['#Dedicated', '#Inspiring', '#Dedicated', '#Inspiring', '#Inspiring'],
  imageUrls: ['', '', '', '', ''],
  heartCount: 10,
  isAnonymous: true,
);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// Single-kudo detail screen.
///
/// Design sources:
///   Normal:    https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/T0TR16k0vH
///   Anonymous: https://momorph.ai/files/9ypp4enmFmdK3YAFJLIu6C/screens/5C2BL6GYXL
///
/// The [isAnonymous] flag (mirrored from [kudo.isAnonymous]) drives a single
/// render branch — one widget, DRY.
class ViewKudoScreen extends StatelessWidget {
  const ViewKudoScreen({
    super.key,
    required this.kudo,
    this.onCopyLink,
    this.onTapSender,
    this.onTapRecipient,
  });

  final KudoDetailViewModel kudo;
  final VoidCallback? onCopyLink;

  /// Called when the sender avatar/name is tapped.
  /// Null when sender is anonymous or userId is unavailable.
  final VoidCallback? onTapSender;

  /// Called when the recipient avatar/name is tapped.
  /// Null when userId is unavailable.
  final VoidCallback? onTapRecipient;

  static const Color _bg = Color(0xFF00101A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Kudo',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: _KudoDetailCard(
            kudo: kudo,
            onCopyLink: onCopyLink,
            onTapSender: onTapSender,
            onTapRecipient: onTapRecipient,
          ),
        ),
      ),
    );
  }
}

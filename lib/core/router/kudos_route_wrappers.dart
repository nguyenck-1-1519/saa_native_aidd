import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/kudos/presentation/all_kudos_screen.dart';
import '../../features/kudos/presentation/providers/kudos_detail_providers.dart';
import '../../features/kudos/presentation/providers/kudos_filter_providers.dart';
import '../../features/kudos/presentation/view_kudo_screen.dart';
import 'app_router.dart';

/// ConsumerWidget wrappers that bind presentational kudos screens to providers.
///
/// Kept in a separate file to keep [app_router.dart] under 200 lines.
/// These classes are intentionally package-private (no export) — only
/// [app_router.dart] instantiates them inside GoRoute builders.

// ---------------------------------------------------------------------------
// All Kudos route wrapper
// ---------------------------------------------------------------------------

/// Watches [allKudosProvider] + filter state and passes them to [AllKudosScreen].
class AllKudosRouteWrapper extends ConsumerWidget {
  const AllKudosRouteWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kudosAsync = ref.watch(allKudosProvider);
    final filter = ref.watch(feedFilterControllerProvider);
    final controller = ref.read(feedFilterControllerProvider.notifier);
    final hashtagsAsync = ref.watch(hashtagOptionsProvider);
    final depsAsync = ref.watch(departmentOptionsProvider);

    return kudosAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF00101A),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: const Color(0xFF00101A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Không tải được danh sách Kudos.', // TODO(l10n): move to arb
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(allKudosProvider),
                child: const Text(
                  'Thử lại', // TODO(l10n): move to arb
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (kudos) => AllKudosScreen(
        kudos: kudos,
        selectedHashtag: filter.hashtag,
        selectedDepartment: filter.department,
        hashtagOptions: hashtagsAsync.valueOrNull ?? const [],
        departmentOptions: depsAsync.valueOrNull ?? const [],
        onHashtagChanged: (v) => controller.setHashtag(v),
        onDepartmentChanged: (v) => controller.setDepartment(v),
        onViewDetail: (kudo) => context.push(Routes.kudoDetailPath(kudo.id)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// View Kudo route wrapper
// ---------------------------------------------------------------------------

/// Fetches [KudoDetail] by [id] and maps it onto [KudoDetailViewModel].
class ViewKudoRouteWrapper extends ConsumerWidget {
  const ViewKudoRouteWrapper({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(kudoDetailProvider(id));

    return detailAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF00101A),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: const Color(0xFF00101A),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Không tải được Kudo.', // TODO(l10n): move to arb
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(kudoDetailProvider(id)),
                child: const Text(
                  'Thử lại', // TODO(l10n): move to arb
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (detail) {
        final vm = KudoDetailViewModel(
          id: detail.id,
          senderName: detail.senderName,
          senderRole: detail.senderRole,
          senderAvatarUrl: detail.senderAvatarUrl,
          senderHeroTag: detail.heroTag.displayName,
          recipientName: detail.recipientName,
          recipientRole: detail.recipientRole,
          // TODO(backend): KudoDetail needs a distinct recipientCode (employee ID); using role as placeholder for mock.
          recipientCode: detail.recipientRole,
          recipientAvatarUrl: detail.recipientAvatarUrl,
          recipientHeroTag: detail.heroTag.displayName,
          postedAt: _formatDateTime(detail.createdAt),
          title: detail.title,
          message: detail.message,
          hashtags: detail.hashtags,
          imageUrls: detail.imageUrls,
          heartCount: detail.heartCount,
          isAnonymous: detail.isAnonymous,
        );
        return ViewKudoScreen(
          kudo: vm,
          onCopyLink: detail.linkUrl != null
              ? () => _copyLink(context, detail.linkUrl!)
              : null,
          // TODO(backend): KudoDetail has no stable sender/recipient userId.
          // Once the API exposes user IDs, replace null with:
          //   onTapSender: detail.isAnonymous ? null
          //       : () => context.push(Routes.profileUserPath(detail.senderId)),
          //   onTapRecipient: () => context.push(Routes.profileUserPath(detail.recipientId)),
          onTapSender: null,
          onTapRecipient: null,
        );
      },
    );
  }

  static String _formatDateTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final mo = dt.month.toString().padLeft(2, '0');
    return '$h:$m - $d/$mo/${dt.year}';
  }

  static void _copyLink(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(
          content: Text('Đã sao chép liên kết'))); // TODO(l10n): move to arb
  }
}

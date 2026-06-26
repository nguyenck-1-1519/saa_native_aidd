import 'package:flutter/material.dart';

import '../domain/entities/kudo.dart';
import 'widgets/kudos_card.dart';
import 'widgets/kudos_filter_row.dart';

/// "All Kudos" list screen — target of the feed's "View all Kudos" button.
///
/// Design source: MoMorph [iOS] Sun*Kudos_All Kudos (screenId: j_a2GQWKDJ).
/// bg #00101A, AppBar dark, sub-header "Sun* Annual Awards 2025 / ALL KUDOS",
/// filter row (Hashtag + Phòng ban), scrollable KudosCard list.
///
/// All data is passed via constructor — presentational only.
/// Filter callbacks are exposed for Track B / integration wiring.
class AllKudosScreen extends StatelessWidget {
  const AllKudosScreen({
    super.key,
    required this.kudos,
    this.selectedHashtag,
    this.selectedDepartment,
    this.hashtagOptions = const [],
    this.departmentOptions = const [],
    this.onHashtagChanged,
    this.onDepartmentChanged,
    this.onViewDetail,
  });

  /// The full list of kudos to display.
  final List<Kudo> kudos;

  /// Currently selected hashtag filter value (null = all).
  final String? selectedHashtag;

  /// Currently selected department filter value (null = all).
  final String? selectedDepartment;

  /// Available hashtag options for the dropdown picker.
  final List<String> hashtagOptions;

  /// Available department options for the dropdown picker.
  final List<String> departmentOptions;

  /// Called when the user taps the hashtag dropdown. Integration binds this.
  final ValueChanged<String?>? onHashtagChanged;

  /// Called when the user taps the department dropdown. Integration binds this.
  final ValueChanged<String?>? onDepartmentChanged;

  /// Called when "Xem chi tiết" is tapped on a card.
  final ValueChanged<Kudo>? onViewDetail;

  static const Color _bgColor = Color(0xFF00101A);
  static const double _hPad = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _AllKudosAppBar(onBack: () => Navigator.of(context).pop()),
      body: CustomScrollView(
        slivers: [
          // Sub-header: label + "ALL KUDOS" gold title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(_hPad, 24, _hPad, 0),
              child: _SubHeader(),
            ),
          ),

          // Filter row: Hashtag + Phòng ban dropdowns
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
              child: KudosFilterRow(
                selectedHashtag: selectedHashtag,
                selectedDepartment: selectedDepartment,
                hashtagOptions: hashtagOptions,
                departmentOptions: departmentOptions,
                onHashtagChanged: onHashtagChanged,
                onDepartmentChanged: onDepartmentChanged,
              ),
            ),
          ),

          // Empty state
          if (kudos.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyState(),
            )
          else ...[
            // Kudos list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(_hPad, 16, _hPad, 0),
              sliver: SliverList.separated(
                itemCount: kudos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final kudo = kudos[index];
                  return KudosCard(
                    kudo: kudo,
                    onViewDetail:
                        onViewDetail != null ? () => onViewDetail!(kudo) : null,
                  );
                },
              ),
            ),

            // Bottom padding / safe area
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar
// ---------------------------------------------------------------------------

class _AllKudosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AllKudosAppBar({this.onBack});

  final VoidCallback? onBack;

  static const double _height = kToolbarHeight;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF00101A),
      elevation: 0,
      centerTitle: true,
      leading: GestureDetector(
        onTap: onBack ?? () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: const Text(
        'All Kudos',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-header
// ---------------------------------------------------------------------------

class _SubHeader extends StatelessWidget {
  const _SubHeader();

  static const Color _gold = Color(0xFFFFEA9E);
  static const Color _separator = Color(0xFF2E3940);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            Expanded(child: Container(height: 1, color: _separator)),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'ALL KUDOS',
          style: TextStyle(
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

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Chưa có Kudos nào.',
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
      ),
    );
  }
}

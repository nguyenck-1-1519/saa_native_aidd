import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/secret_box/domain/entities/secret_box_reward.dart';
import '../../features/secret_box/domain/value_objects/secret_box_phase.dart';
import '../../features/secret_box/presentation/providers/secret_box_providers.dart';
import '../../features/secret_box/presentation/secret_box_screen.dart';

/// Route wrapper that binds [SecretBoxScreen] to [SecretBoxController].
///
/// **Phase → view mapping:**
///
///   closed                     → [SecretBoxView.closed]
///   opening                    → [SecretBoxView.opening]
///   revealed, kind=icon        → [SecretBoxView.revealedIcon]
///   revealed, kind=gift        → [SecretBoxView.revealedGift]
///
/// **Animation/phase reconciliation:**
/// The controller transitions opening→revealed as soon as the async usecase
/// resolves (~800 ms stub), but the opening animation runs for ~1 200 ms.
/// This widget gates the view on a local [_animationDone] flag: it stays in
/// [SecretBoxView.opening] until [onOpeningComplete] fires, regardless of
/// controller phase. Once [_animationDone] is true, the view branches on
/// [SecretBoxReward.kind].
///
/// **Stats sync:** unopenedCount is read from [secretBoxControllerProvider]
/// which keeps its own live count after each draw — same repository instance
/// the Kudos feed counter derives from, so both never desync.
class SecretBoxRouteWrapper extends ConsumerStatefulWidget {
  const SecretBoxRouteWrapper({super.key});

  @override
  ConsumerState<SecretBoxRouteWrapper> createState() =>
      _SecretBoxRouteWrapperState();
}

class _SecretBoxRouteWrapperState extends ConsumerState<SecretBoxRouteWrapper> {
  /// True once the 1 200 ms opening animation completes.
  bool _animationDone = false;

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(secretBoxControllerProvider);

    // Map domain phase → view, gating opening→revealed behind _animationDone.
    final SecretBoxView view;
    switch (uiState.phase) {
      case SecretBoxPhase.closed:
        view = SecretBoxView.closed;
        // Reset animation gate when returning to closed (close() or error path).
        if (_animationDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _animationDone = false);
          });
        }
      case SecretBoxPhase.opening:
        view = SecretBoxView.opening;
      case SecretBoxPhase.revealed:
        if (!_animationDone) {
          // Keep showing opening until the UI animation fires onOpeningComplete.
          view = SecretBoxView.opening;
        } else {
          // Branch on reward kind — null-safe: default to icon if reward missing.
          view = uiState.reward?.kind == SecretBoxRewardKind.gift
              ? SecretBoxView.revealedGift
              : SecretBoxView.revealedIcon;
        }
    }

    return SecretBoxScreen(
      view: view,
      unopenedCount: uiState.unopenedCount,
      rewardName: uiState.reward?.name,
      rewardAssetRef: uiState.reward?.assetRef,
      onOpen: () => ref.read(secretBoxControllerProvider.notifier).open(),
      onClose: () {
        ref.read(secretBoxControllerProvider.notifier).close();
        context.pop();
      },
      onOpeningComplete: () {
        // Step 1: mark animation done so the view branches correctly.
        if (mounted) setState(() => _animationDone = true);
        // Step 2: notify the controller — it applies the draw and stores reward.
        ref
            .read(secretBoxControllerProvider.notifier)
            .onOpeningComplete();
      },
    );
  }
}

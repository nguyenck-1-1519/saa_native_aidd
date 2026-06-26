import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/secret_box/domain/value_objects/secret_box_phase.dart';
import '../../features/secret_box/presentation/providers/secret_box_providers.dart';
import '../../features/secret_box/presentation/secret_box_screen.dart';

/// Route wrapper that binds [SecretBoxScreen] to [SecretBoxController].
///
/// **Animation/phase reconciliation:**
/// The controller transitions opening→revealed as soon as the async usecase
/// resolves (~800 ms stub), but the opening animation runs for ~1 200 ms.
/// To ensure the reveal is always seen, this widget gates the view on a local
/// [_animationDone] flag: it stays in [SecretBoxView.opening] until
/// [onOpeningComplete] fires, regardless of controller phase.
/// Once [_animationDone] is true, the controller's revealed phase is reflected.
///
/// Stats sync: unopenedCount is read from [secretBoxStateProvider] which
/// derives from the SHARED [secretBoxRepositoryProvider] — same instance the
/// controller mutates — so the feed counter and the screen stay in sync.
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
    final boxStateAsync = ref.watch(secretBoxStateProvider);
    final unopenedCount = boxStateAsync.valueOrNull?.unopenedCount ?? 0;

    // Map domain phase → view, gating opening→revealed behind _animationDone.
    final SecretBoxView view;
    switch (uiState.phase) {
      case SecretBoxPhase.closed:
        view = SecretBoxView.closed;
        // Reset animation gate when returning to closed (reset() or error path).
        if (_animationDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _animationDone = false);
          });
        }
      case SecretBoxPhase.opening:
        view = SecretBoxView.opening;
      case SecretBoxPhase.revealed:
        // Stay in opening view until animation completes.
        view = _animationDone ? SecretBoxView.revealed : SecretBoxView.opening;
    }

    return SecretBoxScreen(
      view: view,
      unopenedCount: unopenedCount,
      rewardName: uiState.reward?.name,
      rewardAssetRef: uiState.reward?.assetRef,
      onOpen: () => ref.read(secretBoxControllerProvider.notifier).open(),
      onClose: () {
        ref.read(secretBoxControllerProvider.notifier).reset();
        context.pop();
      },
      onOpeningComplete: () {
        if (mounted) setState(() => _animationDone = true);
      },
    );
  }
}

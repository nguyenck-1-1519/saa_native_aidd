import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/countdown_state.dart';
import '../../domain/usecases/compute_countdown.dart';

/// Real-time countdown controller that ticks every second.
///
/// Uses [ComputeCountdown] (pure domain logic) so the elapsed/clamp rule
/// is tested independently of the timer. Once elapsed:
///   - [CountdownState.isElapsed] is true
///   - days/hours/minutes are all 0 — negatives never reach the UI (FR3)
/// Timer is cancelled via [ref.onDispose] to prevent leaks (Phase 04 spec).
///
/// MOCK (no event API): the real event date (26/12/2025) is already in the
/// past, which would leave the hero stuck on the "event ended" state forever.
/// Until a remote source supplies the live target, the countdown re-anchors to
/// [_mockRemaining] (24h) ahead of the moment the app opens — so every launch
/// starts fresh at ~24h remaining and ticks down. Swap [_resolveTarget] for the
/// API/remote-config value once it exists; nothing else changes.
class CountdownController extends Notifier<CountdownState> {
  static const _compute = ComputeCountdown();

  /// Mocked time-to-event, re-anchored to "now" on every controller build.
  static const _mockRemaining = Duration(hours: 24);

  Timer? _timer;
  late final DateTime _target;

  /// The instant the countdown runs out. Mocked to now + 24h per build.
  DateTime _resolveTarget(DateTime now) => now.add(_mockRemaining);

  @override
  CountdownState build() {
    // Capture a single `now` so the target and the initial frame agree
    // (the first frame reads exactly [_mockRemaining], e.g. 1 day / 0h / 0m).
    final now = DateTime.now();
    _target = _resolveTarget(now);
    final initial = _compute(target: _target, now: now);

    // No need to tick if already elapsed.
    if (!initial.isElapsed) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final next = _compute(target: _target, now: DateTime.now());
        state = next;
        if (next.isElapsed) {
          _timer?.cancel();
          _timer = null;
        }
      });
    }

    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });

    return initial;
  }
}

final countdownControllerProvider =
    NotifierProvider<CountdownController, CountdownState>(
  CountdownController.new,
);

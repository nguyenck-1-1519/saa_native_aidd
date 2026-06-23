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
class CountdownController extends Notifier<CountdownState> {
  static final _target = DateTime(2025, 12, 26);
  static const _compute = ComputeCountdown();

  Timer? _timer;

  @override
  CountdownState build() {
    final initial = _compute(target: _target, now: DateTime.now());

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

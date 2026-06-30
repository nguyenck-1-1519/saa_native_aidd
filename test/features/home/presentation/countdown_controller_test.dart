import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/home/domain/entities/countdown_state.dart';
import 'package:saa_2025/features/home/domain/usecases/compute_countdown.dart';
import 'package:saa_2025/features/home/presentation/providers/countdown_controller.dart';

void main() {
  group('CountdownController mock (no event API)', () {
    test('build() anchors to ~24h remaining on every app open', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(countdownControllerProvider);

      // Mock re-anchors target to now + 24h, so the first frame reads exactly
      // 1 day / 0h / 0m and is never the elapsed/event-ended state.
      expect(state.isElapsed, isFalse);
      expect(state.days, 1);
      expect(state.hours, 0);
      expect(state.minutes, 0);
    });
  });

  group('CountdownController', () {
    test('build() returns valid countdown state', () {
      // The countdown state should always have non-negative values
      final target = DateTime(2025, 12, 26);
      final now = DateTime.now();
      const compute = ComputeCountdown();

      final result = compute(target: target, now: now);

      // The state should be a valid CountdownState
      expect(result, isA<CountdownState>());
      // Days, hours, minutes should be non-negative
      expect(result.days, greaterThanOrEqualTo(0));
      expect(result.hours, greaterThanOrEqualTo(0));
      expect(result.minutes, greaterThanOrEqualTo(0));
    });

    test('elapsed state never has negative values', () {
      final target = DateTime(2020, 1, 1);
      final now = DateTime(2026, 6, 23);
      const compute = ComputeCountdown();

      final result = compute(target: target, now: now);

      expect(result.isElapsed, isTrue);
      expect(result.days, 0);
      expect(result.hours, 0);
      expect(result.minutes, 0);
    });

    test('pre-event countdown computes correctly', () {
      final now = DateTime(2025, 12, 25, 21, 30, 0);     // 2h30m before event
      final target = DateTime(2025, 12, 26, 0, 0, 0);
      const compute = ComputeCountdown();

      final result = compute(target: target, now: now);

      expect(result.isElapsed, isFalse);
      expect(result.days, 0);
      expect(result.hours, 2);
      expect(result.minutes, 30);
    });
  });
}

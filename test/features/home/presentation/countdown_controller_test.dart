import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/home/domain/entities/countdown_state.dart';
import 'package:saa_2025/features/home/domain/usecases/compute_countdown.dart';

void main() {
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

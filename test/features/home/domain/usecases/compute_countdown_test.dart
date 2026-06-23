import 'package:flutter_test/flutter_test.dart';
import 'package:saa_2025/features/home/domain/entities/countdown_state.dart';
import 'package:saa_2025/features/home/domain/usecases/compute_countdown.dart';

void main() {
  const compute = ComputeCountdown();

  group('ComputeCountdown', () {
    test('returns elapsed when target is in the past', () {
      final target = DateTime(2025, 12, 26);
      final now = DateTime(2026, 1, 1);

      final result = compute(target: target, now: now);

      expect(result, CountdownState.elapsed);
      expect(result.isElapsed, isTrue);
      expect(result.days, 0);
      expect(result.hours, 0);
      expect(result.minutes, 0);
    });

    test('returns elapsed when target equals now', () {
      final target = DateTime(2025, 12, 26, 12);
      final result = compute(target: target, now: target);

      expect(result.isElapsed, isTrue);
    });

    test('returns elapsed for far-past target — no negatives leak', () {
      final target = DateTime(2020, 1, 1);
      final now = DateTime(2026, 6, 23);

      final result = compute(target: target, now: now);

      expect(result.days, 0);
      expect(result.hours, 0);
      expect(result.minutes, 0);
      expect(result.isElapsed, isTrue);
    });

    test('returns correct days/hours/minutes for future target', () {
      final now = DateTime(2025, 12, 25, 0, 0, 0);     // 1 day before
      final target = DateTime(2025, 12, 26, 0, 0, 0);

      final result = compute(target: target, now: now);

      expect(result.isElapsed, isFalse);
      expect(result.days, 1);
      expect(result.hours, 0);
      expect(result.minutes, 0);
    });

    test('computes hours and minutes correctly within a day', () {
      final now = DateTime(2025, 12, 25, 21, 30, 0);   // 2h30m before midnight
      final target = DateTime(2025, 12, 26, 0, 0, 0);

      final result = compute(target: target, now: now);

      expect(result.isElapsed, isFalse);
      expect(result.days, 0);
      expect(result.hours, 2);
      expect(result.minutes, 30);
    });

    test('days/hours/minutes never go negative regardless of input order', () {
      final target = DateTime(2025, 1, 1);
      final now = DateTime(2025, 6, 1);

      final result = compute(target: target, now: now);

      expect(result.days, isNonNegative);
      expect(result.hours, isNonNegative);
      expect(result.minutes, isNonNegative);
    });

    test('returned CountdownState has value equality', () {
      final now = DateTime(2025, 12, 25, 0, 0, 0);
      final target = DateTime(2025, 12, 26, 0, 0, 0);

      final a = compute(target: target, now: now);
      final b = compute(target: target, now: now);

      expect(a, equals(b));
    });
  });
}

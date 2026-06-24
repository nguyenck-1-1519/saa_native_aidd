import '../entities/countdown_state.dart';

/// Computes remaining time from [now] to [target].
///
/// Pure function — no I/O, no Flutter, fully unit-testable.
///
/// Elapsed rule: if [target] is in the past (or equal to [now]), returns
/// [CountdownState.elapsed] (days/hours/minutes = 0, isElapsed = true).
/// Negatives never leak to the UI.
///
/// Seconds are intentionally excluded — the design shows DAYS/HOURS/MINUTES.
class ComputeCountdown {
  const ComputeCountdown();

  CountdownState call({
    required DateTime target,
    required DateTime now,
  }) {
    final diff = target.difference(now);

    if (diff.isNegative || diff == Duration.zero) {
      return CountdownState.elapsed;
    }

    final totalMinutes = diff.inMinutes;
    final days = diff.inDays;
    final hours = (totalMinutes ~/ 60) % 24;
    final minutes = totalMinutes % 60;

    return CountdownState(
      days: days,
      hours: hours,
      minutes: minutes,
      isElapsed: false,
    );
  }
}

/// Remaining time to the event, derived from a target date vs now.
///
/// Values are clamped: once the target is in the past, [isElapsed] is true and
/// days/hours/minutes are all 0 — negatives never leak to the UI.
class CountdownState {
  const CountdownState({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.isElapsed,
  });

  final int days;
  final int hours;
  final int minutes;
  final bool isElapsed;

  static const CountdownState elapsed = CountdownState(
    days: 0,
    hours: 0,
    minutes: 0,
    isElapsed: true,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountdownState &&
          other.days == days &&
          other.hours == hours &&
          other.minutes == minutes &&
          other.isElapsed == isElapsed;

  @override
  int get hashCode => Object.hash(days, hours, minutes, isElapsed);
}

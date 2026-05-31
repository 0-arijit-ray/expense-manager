import 'dart:math' as math;

import '../data/local/enums.dart';

/// Pure date arithmetic for recurring rules. Kept dependency-free for testing.
class Recurrence {
  /// Returns the next occurrence strictly after [from] for the given cadence.
  static DateTime next(DateTime from, Frequency frequency, int interval) {
    final step = interval < 1 ? 1 : interval;
    final d = DateTime(from.year, from.month, from.day);
    switch (frequency) {
      case Frequency.daily:
        return d.add(Duration(days: step));
      case Frequency.weekly:
        return d.add(Duration(days: 7 * step));
      case Frequency.monthly:
        return _addMonths(d, step);
      case Frequency.yearly:
        return _addMonths(d, 12 * step);
    }
  }

  static DateTime _addMonths(DateTime d, int months) {
    final base = DateTime(d.year, d.month + months, 1);
    final lastDay = DateTime(base.year, base.month + 1, 0).day;
    return DateTime(base.year, base.month, math.min(d.day, lastDay));
  }

  /// Generates every occurrence in [start, until] inclusive, capped to [maxCount]
  /// to guard against pathological inputs.
  static List<DateTime> occurrencesUntil(
    DateTime start,
    DateTime until,
    Frequency frequency,
    int interval, {
    int maxCount = 730,
  }) {
    final out = <DateTime>[];
    var cursor = DateTime(start.year, start.month, start.day);
    final end = DateTime(until.year, until.month, until.day);
    var i = 0;
    while (!cursor.isAfter(end) && i < maxCount) {
      out.add(cursor);
      cursor = next(cursor, frequency, interval);
      i++;
    }
    return out;
  }
}

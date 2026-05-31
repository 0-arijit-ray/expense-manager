/// Time period used by the dashboard aggregations.
enum Period { weekly, monthly, yearly }

extension PeriodX on Period {
  String get label {
    switch (this) {
      case Period.weekly:
        return 'Weekly';
      case Period.monthly:
        return 'Monthly';
      case Period.yearly:
        return 'Yearly';
    }
  }
}

class DateRange {
  final DateTime start; // inclusive
  final DateTime end; // exclusive
  const DateRange(this.start, this.end);

  bool contains(DateTime d) =>
      !d.isBefore(start) && d.isBefore(end);
}

class Periods {
  /// Returns the range for [period] containing [anchor].
  /// Weeks start on Monday.
  static DateRange rangeFor(Period period, DateTime anchor) {
    switch (period) {
      case Period.weekly:
        final monday = DateTime(anchor.year, anchor.month, anchor.day)
            .subtract(Duration(days: anchor.weekday - 1));
        return DateRange(monday, monday.add(const Duration(days: 7)));
      case Period.monthly:
        final start = DateTime(anchor.year, anchor.month, 1);
        final end = DateTime(anchor.year, anchor.month + 1, 1);
        return DateRange(start, end);
      case Period.yearly:
        return DateRange(
          DateTime(anchor.year, 1, 1),
          DateTime(anchor.year + 1, 1, 1),
        );
    }
  }

  /// Shifts [anchor] by [delta] periods (e.g. previous month).
  static DateTime shift(Period period, DateTime anchor, int delta) {
    switch (period) {
      case Period.weekly:
        return anchor.add(Duration(days: 7 * delta));
      case Period.monthly:
        return DateTime(anchor.year, anchor.month + delta, anchor.day);
      case Period.yearly:
        return DateTime(anchor.year + delta, anchor.month, anchor.day);
    }
  }

  static String title(Period period, DateRange range) {
    switch (period) {
      case Period.weekly:
        final endIncl = range.end.subtract(const Duration(days: 1));
        return '${range.start.day}/${range.start.month} - ${endIncl.day}/${endIncl.month}';
      case Period.monthly:
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return '${months[range.start.month - 1]} ${range.start.year}';
      case Period.yearly:
        return '${range.start.year}';
    }
  }
}

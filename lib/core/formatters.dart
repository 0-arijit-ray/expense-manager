import 'package:intl/intl.dart';

/// Currency + date formatting helpers. Currency symbol is configurable so the
/// app works for any locale; defaults to Indian Rupee.
class Money {
  static String symbol = '\u20B9'; // ₹
  static String locale = 'en_IN';

  static NumberFormat get _compact =>
      NumberFormat.compactCurrency(locale: locale, symbol: symbol, decimalDigits: 1);

  static NumberFormat get _full =>
      NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 0);

  static NumberFormat get _precise =>
      NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 2);

  /// e.g. ₹1,23,456
  static String format(num value) => _full.format(value);

  /// e.g. ₹1.2L — good for chart axes & compact cards.
  static String compact(num value) => _compact.format(value);

  /// Two decimal places, for precise figures like EMI.
  static String precise(num value) => _precise.format(value);

  /// Signed, colored amount string (no symbol coloring here).
  static String signed(num value, bool isExpense) =>
      '${isExpense ? '-' : '+'} ${format(value.abs())}';
}

class Dates {
  static final _day = DateFormat('d MMM yyyy');
  static final _dayShort = DateFormat('d MMM');
  static final _month = DateFormat('MMMM yyyy');
  static final _monthShort = DateFormat('MMM');
  static final _weekday = DateFormat('EEE');
  static final _full = DateFormat('EEE, d MMM yyyy');

  static String day(DateTime d) => _day.format(d);
  static String dayShort(DateTime d) => _dayShort.format(d);
  static String month(DateTime d) => _month.format(d);
  static String monthShort(DateTime d) => _monthShort.format(d);
  static String weekday(DateTime d) => _weekday.format(d);
  static String full(DateTime d) => _full.format(d);

  static String relativeDay(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(d.year, d.month, d.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    if (diff == 1) return 'Tomorrow';
    return _day.format(d);
  }
}

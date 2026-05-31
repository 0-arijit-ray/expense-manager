import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/date_range.dart';
import '../../data/local/database.dart';
import '../../data/local/enums.dart';
import '../../data/repositories/expense_repository.dart';
import '../expenses/expenses_providers.dart';

class PeriodState {
  final Period period;
  final DateTime anchor;
  const PeriodState(this.period, this.anchor);
}

class PeriodController extends Notifier<PeriodState> {
  @override
  PeriodState build() => PeriodState(Period.monthly, DateTime.now());

  void setPeriod(Period p) => state = PeriodState(p, DateTime.now());
  void next() =>
      state = PeriodState(state.period, Periods.shift(state.period, state.anchor, 1));
  void prev() =>
      state = PeriodState(state.period, Periods.shift(state.period, state.anchor, -1));
}

final periodControllerProvider =
    NotifierProvider<PeriodController, PeriodState>(PeriodController.new);

class SeriesPoint {
  final String label;
  final double expense;
  final double income;
  const SeriesPoint(this.label, this.expense, this.income);
}

class CategorySlice {
  final Category? category;
  final double total;
  const CategorySlice(this.category, this.total);
}

class DashboardData {
  final double income;
  final double expense;
  final List<SeriesPoint> series;
  final List<CategorySlice> byCategory;
  final int txnCount;

  const DashboardData({
    required this.income,
    required this.expense,
    required this.series,
    required this.byCategory,
    required this.txnCount,
  });

  double get net => income - expense;
}

/// Aggregates the transactions inside the currently selected period.
final dashboardDataProvider = Provider<AsyncValue<DashboardData>>((ref) {
  final ps = ref.watch(periodControllerProvider);
  final range = Periods.rangeFor(ps.period, ps.anchor);
  final txnsAsync =
      ref.watch(transactionsInRangeProvider((from: range.start, to: range.end)));
  return txnsAsync.whenData(
    (txns) => _aggregate(txns, ps.period, range),
  );
});

DashboardData _aggregate(
  List<TransactionWithCategory> txns,
  Period period,
  DateRange range,
) {
  var income = 0.0;
  var expense = 0.0;
  final catTotals = <int?, double>{};
  final catLookup = <int?, Category?>{};

  for (final t in txns) {
    if (t.txn.type == TxnType.income) {
      income += t.txn.amount;
    } else {
      expense += t.txn.amount;
      catTotals.update(t.category?.id, (v) => v + t.txn.amount,
          ifAbsent: () => t.txn.amount);
      catLookup[t.category?.id] = t.category;
    }
  }

  final byCategory = catTotals.entries
      .map((e) => CategorySlice(catLookup[e.key], e.value))
      .toList()
    ..sort((a, b) => b.total.compareTo(a.total));

  return DashboardData(
    income: income,
    expense: expense,
    series: _buildSeries(txns, period, range),
    byCategory: byCategory,
    txnCount: txns.length,
  );
}

List<SeriesPoint> _buildSeries(
  List<TransactionWithCategory> txns,
  Period period,
  DateRange range,
) {
  const wd = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const mn = [
    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'
  ];

  switch (period) {
    case Period.weekly:
      final exp = List<double>.filled(7, 0);
      final inc = List<double>.filled(7, 0);
      for (final t in txns) {
        final idx = t.txn.date.weekday - 1;
        if (t.txn.type == TxnType.expense) {
          exp[idx] += t.txn.amount;
        } else {
          inc[idx] += t.txn.amount;
        }
      }
      return [for (var i = 0; i < 7; i++) SeriesPoint(wd[i], exp[i], inc[i])];

    case Period.monthly:
      // Group into weeks of the month (W1..W5).
      final exp = List<double>.filled(6, 0);
      final inc = List<double>.filled(6, 0);
      for (final t in txns) {
        final w = ((t.txn.date.day - 1) ~/ 7).clamp(0, 5);
        if (t.txn.type == TxnType.expense) {
          exp[w] += t.txn.amount;
        } else {
          inc[w] += t.txn.amount;
        }
      }
      final weeks = DateTime(range.start.year, range.start.month + 1, 0).day > 28
          ? 5
          : 4;
      return [for (var i = 0; i < weeks; i++) SeriesPoint('W${i + 1}', exp[i], inc[i])];

    case Period.yearly:
      final exp = List<double>.filled(12, 0);
      final inc = List<double>.filled(12, 0);
      for (final t in txns) {
        final m = t.txn.date.month - 1;
        if (t.txn.type == TxnType.expense) {
          exp[m] += t.txn.amount;
        } else {
          inc[m] += t.txn.amount;
        }
      }
      return [for (var i = 0; i < 12; i++) SeriesPoint(mn[i], exp[i], inc[i])];
  }
}

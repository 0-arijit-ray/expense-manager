import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/loan_repository.dart';

final loansProvider = StreamProvider<List<Loan>>(
  (ref) => ref.watch(loanRepoProvider).watchLoans(),
);

final loanSummariesProvider = FutureProvider<List<LoanSummary>>((ref) async {
  // Recompute whenever loans or schedules change.
  ref.watch(loansProvider);
  ref.watch(scheduleRefreshProvider);
  return ref.watch(loanRepoProvider).summaries();
});

final loanScheduleProvider =
    StreamProvider.family<List<EmiSchedule>, int>(
  (ref, loanId) => ref.watch(loanRepoProvider).watchSchedule(loanId),
);

final upcomingEmisProvider =
    FutureProvider<List<({EmiSchedule emi, Loan loan})>>((ref) async {
  ref.watch(loansProvider);
  ref.watch(scheduleRefreshProvider);
  return ref.watch(loanRepoProvider).upcoming(days: 60);
});

/// Bumped after EMI paid/unpaid actions to refresh the FutureProviders above.
class ScheduleRefresh extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

final scheduleRefreshProvider =
    NotifierProvider<ScheduleRefresh, int>(ScheduleRefresh.new);

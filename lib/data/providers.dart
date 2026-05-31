import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/recurring_engine.dart';
import 'local/database.dart';
import 'repositories/expense_repository.dart';
import 'repositories/investment_repository.dart';
import 'repositories/loan_repository.dart';
import 'repositories/recurring_repository.dart';

/// Single app-wide database instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final expenseRepoProvider = Provider<ExpenseRepository>(
  (ref) => ExpenseRepository(ref.watch(databaseProvider)),
);

final loanRepoProvider = Provider<LoanRepository>(
  (ref) => LoanRepository(ref.watch(databaseProvider)),
);

final investmentRepoProvider = Provider<InvestmentRepository>(
  (ref) => InvestmentRepository(ref.watch(databaseProvider)),
);

final recurringRepoProvider = Provider<RecurringRepository>(
  (ref) => RecurringRepository(ref.watch(databaseProvider)),
);

final recurringEngineProvider = Provider<RecurringEngine>(
  (ref) => RecurringEngine(
    ref.watch(recurringRepoProvider),
    ref.watch(loanRepoProvider),
  ),
);

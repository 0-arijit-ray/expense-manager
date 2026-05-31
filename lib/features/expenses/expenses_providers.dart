import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/expense_repository.dart';

/// All categories (for pickers + dashboards).
final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(expenseRepoProvider).watchCategories(),
);

/// Recent transactions for the expenses list.
final recentTransactionsProvider =
    StreamProvider<List<TransactionWithCategory>>(
  (ref) => ref.watch(expenseRepoProvider).watchTransactions(limit: 300),
);

/// Transactions within an explicit date range (dashboard / period views).
final transactionsInRangeProvider = StreamProvider.family<
    List<TransactionWithCategory>, ({DateTime from, DateTime to})>(
  (ref, range) => ref
      .watch(expenseRepoProvider)
      .watchTransactions(from: range.from, to: range.to),
);

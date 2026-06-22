import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../data/repositories/expense_repository.dart';
import '../../shared/widgets.dart';
import 'expense_form.dart';
import 'expenses_providers.dart';
import 'transaction_tile.dart';

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txnsAsync = ref.watch(recentTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.repeat),
            tooltip: 'Recurring',
            onPressed: () => context.push('/recurring'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ExpenseForm.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: txnsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (txns) {
          if (txns.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long,
              title: 'No transactions yet',
              message: 'Add your first expense or income to get started.',
              action: FilledButton.icon(
                onPressed: () => ExpenseForm.show(context),
                icon: const Icon(Icons.add),
                label: const Text('Add transaction'),
              ),
            );
          }
          return _GroupedList(txns: txns);
        },
      ),
    );
  }
}

class _GroupedList extends ConsumerWidget {
  final List<TransactionWithCategory> txns;
  const _GroupedList({required this.txns});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group by calendar day, preserving date-desc order.
    final groups = <DateTime, List<TransactionWithCategory>>{};
    for (final t in txns) {
      final day = DateTime(t.txn.date.year, t.txn.date.month, t.txn.date.day);
      groups.putIfAbsent(day, () => []).add(t);
    }
    final days = groups.keys.toList();

    // Calculate summary stats
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final monthStart = DateTime(now.year, now.month, 1);

    final thisWeek = txns.where((t) =>
        !t.txn.date.isBefore(weekStart)).toList();
    final thisMonth = txns.where((t) =>
        !t.txn.date.isBefore(monthStart)).toList();

    final weekIncome = thisWeek
        .where((t) => t.txn.type == TxnType.income)
        .fold(0.0, (s, t) => s + t.txn.amount);
    final weekExpense = thisWeek
        .where((t) => t.txn.type == TxnType.expense)
        .fold(0.0, (s, t) => s + t.txn.amount);
    final monthIncome = thisMonth
        .where((t) => t.txn.type == TxnType.income)
        .fold(0.0, (s, t) => s + t.txn.amount);
    final monthExpense = thisMonth
        .where((t) => t.txn.type == TxnType.expense)
        .fold(0.0, (s, t) => s + t.txn.amount);

    return Column(
      children: [
        // Summary chips
        if (txns.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'THIS WEEK',
                    income: weekIncome,
                    expense: weekExpense,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryCard(
                    label: 'THIS MONTH',
                    income: monthIncome,
                    expense: monthExpense,
                  ),
                ),
              ],
            ),
          ),
        // Grouped list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: days.length,
            itemBuilder: (context, i) {
              final day = days[i];
              final items = groups[day]!;
              final dayIncome = items
                  .where((t) => t.txn.type == TxnType.income)
                  .fold(0.0, (s, t) => s + t.txn.amount);
              final dayExpense = items
                  .where((t) => t.txn.type == TxnType.expense)
                  .fold(0.0, (s, t) => s + t.txn.amount);
              final dayTotal = dayIncome - dayExpense;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Day header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Dates.relativeDay(day),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[600],
                          ),
                        ),
                        Row(
                          children: [
                            if (dayIncome > 0)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  '+${Money.format(dayIncome)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            if (dayExpense > 0)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  '-${Money.format(dayExpense)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            Text(
                              '${dayTotal < 0 ? '-' : '+'}${Money.format(dayTotal.abs())}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: dayTotal >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Transactions
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        for (int j = 0; j < items.length; j++) ...[
                          Dismissible(
                            key: ValueKey(items[j].txn.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              color: Theme.of(context).colorScheme.errorContainer,
                              child: Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.onErrorContainer),
                            ),
                            confirmDismiss: (_) async {
                              await ref
                                  .read(expenseRepoProvider)
                                  .deleteTransaction(items[j].txn.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Transaction deleted')),
                                );
                              }
                              return true;
                            },
                            child: TransactionTile(
                              item: items[j],
                              onTap: () => ExpenseForm.show(context, existing: items[j].txn),
                            ),
                          ),
                          if (j < items.length - 1)
                            Divider(height: 1, indent: 60, color: Colors.grey[100]),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double income;
  final double expense;

  const _SummaryCard({
    required this.label,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Income',
                    style: TextStyle(fontSize: 9, color: Colors.green),
                  ),
                  Text(
                    Money.format(income),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expense',
                    style: TextStyle(fontSize: 9, color: Colors.red),
                  ),
                  Text(
                    Money.format(expense),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

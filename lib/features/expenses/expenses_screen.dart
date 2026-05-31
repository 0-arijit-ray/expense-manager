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

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: days.length,
      itemBuilder: (context, i) {
        final day = days[i];
        final items = groups[day]!;
        final dayTotal = items.fold<double>(
          0,
          (s, t) => s + (t.txn.type == TxnType.expense ? -t.txn.amount : t.txn.amount),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Dates.relativeDay(day),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary)),
                  Text(
                    '${dayTotal < 0 ? '-' : '+'} ${Money.format(dayTotal.abs())}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            ...items.map((t) => Dismissible(
                  key: ValueKey(t.txn.id),
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
                        .deleteTransaction(t.txn.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaction deleted')),
                      );
                    }
                    return true;
                  },
                  child: TransactionTile(
                    item: t,
                    onTap: () => ExpenseForm.show(context, existing: t.txn),
                  ),
                )),
          ],
        );
      },
    );
  }
}

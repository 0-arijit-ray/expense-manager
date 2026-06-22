import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../data/repositories/recurring_repository.dart';
import '../../shared/widgets.dart';
import 'recurring_form.dart';
import 'recurring_providers.dart';

double _monthlyProjection(double amount, Frequency freq, int interval) {
  switch (freq) {
    case Frequency.daily:
      return amount / interval * 30;
    case Frequency.weekly:
      return amount / interval * 4.33;
    case Frequency.monthly:
      return amount / interval;
    case Frequency.yearly:
      return amount / interval / 12;
  }
}

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsync = ref.watch(recurringRulesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recurring')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => RecurringForm.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Add recurring'),
      ),
      body: rulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (rules) {
          if (rules.isEmpty) {
            return EmptyState(
              icon: Icons.repeat,
              title: 'No recurring entries',
              message:
                  'Automate salary, rent, subscriptions and SIPs. They post on their own and show up across the app.',
              action: FilledButton.icon(
                onPressed: () => RecurringForm.show(context),
                icon: const Icon(Icons.add),
                label: const Text('Add recurring'),
              ),
            );
          }

          // Summary
          final activeRules =
              rules.where((r) => r.rule.active).toList();
          final monthlyIncome = activeRules
              .where((r) => r.rule.type == TxnType.income)
              .fold(0.0, (sum, r) => sum + _monthlyProjection(r.rule.amount, r.rule.frequency, r.rule.interval));
          final monthlyExpense = activeRules
              .where((r) => r.rule.type == TxnType.expense)
              .fold(0.0, (sum, r) => sum + _monthlyProjection(r.rule.amount, r.rule.frequency, r.rule.interval));

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              // Summary row
              if (activeRules.isNotEmpty) ...[
                _SummaryRow(
                  income: monthlyIncome,
                  expense: monthlyExpense,
                ),
                const SizedBox(height: 12),
              ],
              for (final r in rules)
                _RuleCard(item: r),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final double income;
  final double expense;
  const _SummaryRow({required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    final net = income - expense;
    return Row(
      children: [
        Expanded(
          child: _SummaryChip(
            label: 'INCOME/mo',
            amount: income,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryChip(
            label: 'EXPENSE/mo',
            amount: expense,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryChip(
            label: 'NET/mo',
            amount: net,
            color: Theme.of(context).colorScheme.primary,
            showSign: true,
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool showSign;

  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    this.showSign = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
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
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${showSign && amount >= 0 ? '+' : ''}${Money.format(amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleCard extends ConsumerWidget {
  final RecurringWithCategory item;
  const _RuleCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rule = item.rule;
    final isIncome = rule.type == TxnType.income;
    final cat = item.category;
    final color = cat != null
        ? Color(cat.color)
        : Theme.of(context).colorScheme.primary;
    final icon = cat != null
        ? IconData(cat.iconCodepoint, fontFamily: 'MaterialIcons')
        : Icons.repeat;

    final now = DateTime.now();
    final daysUntilDue = rule.nextDueDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    final isOverdue = daysUntilDue < 0;
    final isDueSoon = daysUntilDue >= 0 && daysUntilDue <= 3;
    final monthlyAmount = _monthlyProjection(rule.amount, rule.frequency, rule.interval);

    return Dismissible(
      key: ValueKey(rule.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.delete,
            color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      confirmDismiss: (_) async {
        await ref.read(recurringRepoProvider).delete(rule.id);
        return true;
      },
      child: PaddedCard(
        onTap: () => RecurringForm.show(context, existing: rule),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                IconBadge(icon, color: color, size: 38),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(rule.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isIncome ? 'INC' : 'EXP',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isIncome ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${rule.frequency.describe(rule.interval)}${cat != null ? ' · ${cat.name}' : ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AmountText(rule.amount,
                        isExpense: !isIncome,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    Text(
                      '~${Money.format(monthlyAmount)}/mo',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: rule.active,
                  onChanged: (v) =>
                      ref.read(recurringRepoProvider).setActive(rule.id, v),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Bottom row: due date + actions
            Container(
              padding: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: isOverdue
                        ? Colors.red
                        : isDueSoon
                            ? Colors.orange
                            : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOverdue
                        ? '${daysUntilDue.abs()}d overdue'
                        : daysUntilDue == 0
                            ? 'Due today'
                            : 'Due in ${daysUntilDue}d',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isOverdue || isDueSoon
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isOverdue
                          ? Colors.red
                          : isDueSoon
                              ? Colors.orange
                              : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Dates.dayShort(rule.nextDueDate),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  if (rule.endDate != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      'Ends ${Dates.dayShort(rule.endDate!)}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      onPressed: () =>
                          RecurringForm.show(context, existing: rule),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

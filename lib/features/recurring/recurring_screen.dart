import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../data/repositories/recurring_repository.dart';
import '../../shared/widgets.dart';
import 'recurring_form.dart';
import 'recurring_providers.dart';

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
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              for (final r in rules)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _RuleCard(item: r),
                ),
            ],
          );
        },
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

    return Dismissible(
      key: ValueKey(rule.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(20)),
        child: Icon(Icons.delete,
            color: Theme.of(context).colorScheme.onErrorContainer),
      ),
      confirmDismiss: (_) async {
        await ref.read(recurringRepoProvider).delete(rule.id);
        return true;
      },
      child: PaddedCard(
        onTap: () => RecurringForm.show(context, existing: rule),
        child: Row(
          children: [
            IconBadge(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rule.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    '${rule.frequency.describe(rule.interval)} · next ${Dates.relativeDay(rule.nextDueDate)}',
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
                Switch(
                  value: rule.active,
                  onChanged: (v) =>
                      ref.read(recurringRepoProvider).setActive(rule.id, v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

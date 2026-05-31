import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../data/repositories/loan_repository.dart';
import '../../shared/widgets.dart';
import 'loan_form.dart';
import 'loans_providers.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaries = ref.watch(loanSummariesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Loans & EMIs')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => LoanForm.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Add loan'),
      ),
      body: summaries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return EmptyState(
              icon: Icons.account_balance,
              title: 'No loans tracked',
              message:
                  'Add a home, car or personal loan to generate its EMI schedule and reminders.',
              action: FilledButton.icon(
                onPressed: () => LoanForm.show(context),
                icon: const Icon(Icons.add),
                label: const Text('Add loan'),
              ),
            );
          }
          final active = list.where((l) => !l.loan.closed).toList();
          final totalOutstanding =
              active.fold<double>(0, (s, l) => s + l.outstanding);
          final totalEmi =
              active.fold<double>(0, (s, l) => s + l.loan.emiAmount);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: 'Total outstanding',
                          value: Money.format(totalOutstanding),
                          icon: Icons.trending_down,
                        ),
                      ),
                      Expanded(
                        child: StatTile(
                          label: 'Monthly EMIs',
                          value: Money.format(totalEmi),
                          icon: Icons.calendar_month,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...list.map((s) => Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: _LoanCard(summary: s),
                  )),
            ],
          );
        },
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final LoanSummary summary;
  const _LoanCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final loan = summary.loan;
    final scheme = Theme.of(context).colorScheme;
    return PaddedCard(
      onTap: () => context.push('/loans/${loan.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(loan.type.icon, color: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loan.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    Text(
                      '${loan.type.label}${loan.lender != null ? ' · ${loan.lender}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (loan.closed)
                const Chip(
                  label: Text('Closed'),
                  visualDensity: VisualDensity.compact,
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(Money.format(loan.emiAmount),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('/month',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${summary.paidCount}/${summary.totalCount} paid',
                  style: Theme.of(context).textTheme.bodySmall),
              Text('Outstanding ${Money.format(summary.outstanding)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ThinProgress(summary.progress),
          if (summary.nextDue != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.notifications_active,
                    size: 14, color: scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  'Next EMI ${Dates.relativeDay(summary.nextDue!.dueDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/finance_math.dart';
import '../../core/formatters.dart';
import '../../data/local/database.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../services/notification_service.dart';
import '../../shared/widgets.dart';
import 'loans_providers.dart';

class LoanDetailScreen extends ConsumerWidget {
  final int loanId;
  const LoanDetailScreen({required this.loanId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider);
    final scheduleAsync = ref.watch(loanScheduleProvider(loanId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              final repo = ref.read(loanRepoProvider);
              if (v == 'delete') {
                final ok = await _confirm(context, 'Delete this loan and its schedule?');
                if (ok) {
                  await repo.deleteLoan(loanId);
                  await NotificationService.instance.cancelAll();
                  ref.read(scheduleRefreshProvider.notifier).bump();
                  if (context.mounted) context.pop();
                }
              } else if (v == 'close') {
                final loan = await repo.getLoan(loanId);
                await repo.setClosed(loanId, !loan.closed);
                ref.read(scheduleRefreshProvider.notifier).bump();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'close', child: Text('Toggle closed')),
              PopupMenuItem(value: 'delete', child: Text('Delete loan')),
            ],
          ),
        ],
      ),
      body: loansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (loans) {
          final loan = loans.where((l) => l.id == loanId).firstOrNull;
          if (loan == null) {
            return const EmptyState(
                icon: Icons.error_outline,
                title: 'Loan not found',
                message: 'It may have been deleted.');
          }
          return scheduleAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (schedule) =>
                _Body(loan: loan, schedule: schedule, ref: ref),
          );
        },
      ),
    );
  }

  Future<bool> _confirm(BuildContext context, String message) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm')),
        ],
      ),
    );
    return res ?? false;
  }
}

class _Body extends StatelessWidget {
  final Loan loan;
  final List<EmiSchedule> schedule;
  final WidgetRef ref;
  const _Body({required this.loan, required this.schedule, required this.ref});

  @override
  Widget build(BuildContext context) {
    final totalInterest = FinanceMath.totalInterest(
      principal: loan.principal,
      annualRatePct: loan.annualRate,
      tenureMonths: loan.tenureMonths,
    );
    final paid = schedule.where((e) => e.paid).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Row(
          children: [
            IconBadge(loan.type.icon,
                color: Theme.of(context).colorScheme.primary, size: 52),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loan.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text(
                      '${loan.type.label} · ${loan.annualRate}% · ${loan.tenureMonths} mo'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: StatTile(
                            label: 'Principal',
                            value: Money.format(loan.principal))),
                    Expanded(
                        child: StatTile(
                            label: 'Monthly EMI',
                            value: Money.format(loan.emiAmount))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: StatTile(
                            label: 'Total interest',
                            value: Money.format(totalInterest))),
                    Expanded(
                        child: StatTile(
                            label: 'Total payable',
                            value: Money.format(loan.principal + totalInterest))),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                value: loan.alertsEnabled,
                title: const Text('EMI reminders'),
                subtitle: Text(loan.alertsEnabled
                    ? '${loan.alertLeadDays} days before due date'
                    : 'Off'),
                secondary: const Icon(Icons.notifications_active),
                onChanged: (v) async {
                  await (ref.read(databaseProvider).update(
                          ref.read(databaseProvider).loans)
                        ..where((l) => l.id.equals(loan.id)))
                      .write(LoansCompanion(alertsEnabled: Value(v)));
                  if (v) {
                    for (final e in schedule.where((e) => !e.paid).take(6)) {
                      await NotificationService.instance
                          .scheduleEmiReminder(loan: loan, emi: e);
                    }
                  }
                  ref.read(scheduleRefreshProvider.notifier).bump();
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                value: loan.autoDebit,
                title: const Text('Auto-pay EMIs on due date'),
                subtitle: const Text('Marks EMIs paid automatically once due'),
                secondary: const Icon(Icons.event_repeat),
                onChanged: (v) async {
                  final db = ref.read(databaseProvider);
                  await (db.update(db.loans)..where((l) => l.id.equals(loan.id)))
                      .write(LoansCompanion(autoDebit: Value(v)));
                  if (v) {
                    await ref
                        .read(loanRepoProvider)
                        .autoProcessDueEmis(DateTime.now());
                  }
                  ref.read(scheduleRefreshProvider.notifier).bump();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Amortization schedule',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            Text('$paid / ${schedule.length} paid',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        ...schedule.map((e) => _EmiRow(emi: e, loan: loan, ref: ref)),
      ],
    );
  }
}

class _EmiRow extends StatelessWidget {
  final EmiSchedule emi;
  final Loan loan;
  final WidgetRef ref;
  const _EmiRow({required this.emi, required this.loan, required this.ref});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final overdue = !emi.paid && emi.dueDate.isBefore(DateTime.now());
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: emi.paid
            ? scheme.primaryContainer
            : overdue
                ? scheme.errorContainer
                : scheme.surfaceContainerHighest,
        child: emi.paid
            ? Icon(Icons.check, size: 18, color: scheme.onPrimaryContainer)
            : Text('${emi.installmentNo}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      title: Text(Dates.day(emi.dueDate),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: emi.paid ? TextDecoration.lineThrough : null,
          )),
      subtitle: Text(
          'P ${Money.compact(emi.principalComponent)} · I ${Money.compact(emi.interestComponent)} · Bal ${Money.compact(emi.balance)}',
          style: const TextStyle(fontSize: 11)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(Money.format(emi.emiAmount),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () async {
              final repo = ref.read(loanRepoProvider);
              if (emi.paid) {
                await repo.markEmiUnpaid(emi);
              } else {
                await repo.markEmiPaid(emi, loan);
              }
              ref.read(scheduleRefreshProvider.notifier).bump();
            },
            child: Text(emi.paid ? 'Undo' : 'Mark paid',
                style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

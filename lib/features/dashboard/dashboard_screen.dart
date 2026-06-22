import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/date_range.dart';
import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../shared/widgets.dart';
import '../../shared/widgets/app_footer.dart';
import '../expenses/expense_form.dart';
import '../loans/loans_providers.dart';
import '../networth/networth_providers.dart';
import 'dashboard_charts.dart';
import 'dashboard_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ps = ref.watch(periodControllerProvider);
    final dataAsync = ref.watch(dashboardDataProvider);
    final range = Periods.rangeFor(ps.period, ps.anchor);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => ExpenseForm.show(context),
            tooltip: 'New transaction',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.go('/loans'),
            tooltip: 'EMIs & alerts',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(recurringEngineProvider).run();
          ref.invalidate(loanSummariesProvider);
          ref.invalidate(upcomingEmisProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            _PeriodSelector(period: ps.period),
            const SizedBox(height: 12),
            _PeriodNavigator(title: Periods.title(ps.period, range)),
            const SizedBox(height: 12),
            dataAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('Error: $e'),
              data: (data) => Column(
                children: [
                  _SummaryCard(data: data),
                  const SizedBox(height: 16),
                  PaddedCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader('Cash flow'),
                        IncomeExpenseBarChart(data.series),
                        const SizedBox(height: 8),
                        const _Legend(),
                      ],
                    ),
                  ),
                  if (data.byCategory.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    PaddedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader('Spending by category'),
                          CategoryDonut(data.byCategory),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _NetWorthMiniCard(),
            const SizedBox(height: 16),
            const _UpcomingEmisCard(),
            const SizedBox(height: 24),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  final Period period;
  const _PeriodSelector({required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<Period>(
      segments: const [
        ButtonSegment(value: Period.weekly, label: Text('Week')),
        ButtonSegment(value: Period.monthly, label: Text('Month')),
        ButtonSegment(value: Period.yearly, label: Text('Year')),
      ],
      selected: {period},
      showSelectedIcon: false,
      onSelectionChanged: (s) =>
          ref.read(periodControllerProvider.notifier).setPeriod(s.first),
    );
  }
}

class _PeriodNavigator extends ConsumerWidget {
  final String title;
  const _PeriodNavigator({required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = ref.read(periodControllerProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          onPressed: ctrl.prev,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        IconButton.filledTonal(
          onPressed: ctrl.next,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final DashboardData data;
  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Net balance',
                style: TextStyle(color: scheme.onPrimaryContainer)),
            const SizedBox(height: 4),
            Text(
              Money.format(data.net),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onPrimaryContainer),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Income',
                    value: Money.format(data.income),
                    icon: Icons.south_west,
                    valueColor: const Color(0xFF1B5E20),
                  ),
                ),
                Expanded(
                  child: StatTile(
                    label: 'Expense',
                    value: Money.format(data.expense),
                    icon: Icons.north_east,
                    valueColor: scheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget dot(Color c, String l) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 6),
            Text(l, style: Theme.of(context).textTheme.bodySmall),
          ],
        );
    return Row(
      children: [
        dot(scheme.error, 'Expense'),
        const SizedBox(width: 16),
        dot(scheme.primary, 'Income'),
      ],
    );
  }
}

class _NetWorthMiniCard extends ConsumerWidget {
  const _NetWorthMiniCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nw = ref.watch(netWorthProvider);
    return PaddedCard(
      onTap: () => context.go('/networth'),
      child: nw.when(
        loading: () => const SizedBox(
            height: 48, child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Text('Error: $e'),
        data: (d) => Row(
          children: [
            IconBadge(Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Net worth',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(Money.format(d.withLoans),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _UpcomingEmisCard extends ConsumerWidget {
  const _UpcomingEmisCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingEmisProvider);
    return upcoming.maybeWhen(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        final next = items.take(3).toList();
        return PaddedCard(
          onTap: () => context.go('/loans'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader('Upcoming EMIs'),
              ...next.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(e.loan.type.icon,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(child: Text(e.loan.name)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(Money.format(e.emi.emiAmount),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            Text(Dates.relativeDay(e.emi.dueDate),
                                style:
                                    Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

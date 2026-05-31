import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../data/local/database.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';
import '../../services/rates_service.dart';
import '../../shared/widgets.dart';
import 'investment_form.dart';
import 'investments_providers.dart';

class InvestmentsScreen extends ConsumerWidget {
  const InvestmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invAsync = ref.watch(investmentsProvider);
    final summaryAsync = ref.watch(portfolioSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => InvestmentForm.show(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: invAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              summaryAsync.maybeWhen(
                data: (s) => _PortfolioCard(summary: s),
                orElse: () => const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              const _RatesSection(),
              const SizedBox(height: 16),
              const SectionHeader('Holdings'),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: EmptyState(
                    icon: Icons.pie_chart_outline,
                    title: 'No investments yet',
                    message:
                        'Track FDs, mutual funds, equities, gold and more to see your portfolio grow.',
                    action: FilledButton.icon(
                      onPressed: () => InvestmentForm.show(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add investment'),
                    ),
                  ),
                )
              else
                ...list.map((i) => Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: _HoldingCard(inv: i),
                    )),
            ],
          );
        },
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final PortfolioSummary summary;
  const _PortfolioCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gainPositive = summary.gain >= 0;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current value',
                style: TextStyle(color: scheme.onPrimaryContainer)),
            const SizedBox(height: 4),
            Text(Money.format(summary.current),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onPrimaryContainer)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(gainPositive ? Icons.trending_up : Icons.trending_down,
                    size: 18,
                    color: gainPositive
                        ? const Color(0xFF1B5E20)
                        : scheme.error),
                const SizedBox(width: 4),
                Text(
                  '${gainPositive ? '+' : ''}${Money.format(summary.gain)} (${summary.gainPct.toStringAsFixed(1)}%)',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: gainPositive
                          ? const Color(0xFF1B5E20)
                          : scheme.error),
                ),
                const Spacer(),
                Text('Invested ${Money.compact(summary.invested)}',
                    style: TextStyle(color: scheme.onPrimaryContainer)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HoldingCard extends ConsumerWidget {
  final Investment inv;
  const _HoldingCard({required this.inv});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gain = inv.currentValue - inv.investedAmount;
    final gainPct =
        inv.investedAmount == 0 ? 0.0 : gain / inv.investedAmount * 100;
    final positive = gain >= 0;
    final scheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(inv.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
            color: scheme.errorContainer,
            borderRadius: BorderRadius.circular(20)),
        child: Icon(Icons.delete, color: scheme.onErrorContainer),
      ),
      confirmDismiss: (_) async {
        await ref.read(investmentRepoProvider).delete(inv.id);
        return true;
      },
      child: PaddedCard(
        onTap: () => InvestmentForm.show(context, existing: inv),
        child: Row(
          children: [
            IconBadge(inv.type.icon, color: scheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(inv.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(
                    '${inv.type.label}${inv.annualRate != null ? ' · ${inv.annualRate}%' : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Money.format(inv.currentValue),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  '${positive ? '+' : ''}${gainPct.toStringAsFixed(1)}%',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: positive
                          ? const Color(0xFF2E7D32)
                          : scheme.error),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RatesSection extends ConsumerWidget {
  const _RatesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratesAsync = ref.watch(ratesProvider);
    return PaddedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            'Indicative rates',
            trailing: ratesAsync.maybeWhen(
              data: (s) => Chip(
                label: Text(s.isLive ? 'Live' : 'Reference',
                    style: const TextStyle(fontSize: 11)),
                visualDensity: VisualDensity.compact,
                avatar: Icon(s.isLive ? Icons.cloud_done : Icons.info_outline,
                    size: 14),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          ratesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Could not load rates: $e'),
            data: (snapshot) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: snapshot.rates
                  .map((r) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.label,
                                style:
                                    Theme.of(context).textTheme.bodySmall),
                            Text('${r.ratePct}% ${r.unit}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/formatters.dart';
import '../../data/local/enums.dart';
import '../../shared/widgets.dart';
import '../loans/loans_providers.dart';
import 'networth_providers.dart';

class NetWorthScreen extends ConsumerWidget {
  const NetWorthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nwAsync = ref.watch(netWorthProvider);
    final includeLoans = ref.watch(includeLoansProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Net worth')),
      body: nwAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (d) {
          final value = includeLoans ? d.withLoans : d.withoutLoans;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _HeroCard(value: value, includeLoans: includeLoans),
              const SizedBox(height: 16),
              Card(
                child: SwitchListTile(
                  value: includeLoans,
                  onChanged: (v) =>
                      ref.read(includeLoansProvider.notifier).set(v),
                  title: const Text('Subtract outstanding loans'),
                  subtitle: Text(includeLoans
                      ? 'Showing net worth after liabilities'
                      : 'Showing gross assets only'),
                  secondary: const Icon(Icons.account_balance),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MiniCard(
                      label: 'Assets',
                      value: d.assets,
                      color: const Color(0xFF2E7D32),
                      icon: Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MiniCard(
                      label: 'Liabilities',
                      value: d.liabilities,
                      color: Theme.of(context).colorScheme.error,
                      icon: Icons.trending_down,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (d.assetBreakdown.isNotEmpty) _AssetBreakdown(data: d),
              const SizedBox(height: 16),
              const _LiabilitiesList(),
            ],
          );
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final double value;
  final bool includeLoans;
  const _HeroCard({required this.value, required this.includeLoans});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: scheme.onPrimary),
                const SizedBox(width: 8),
                Text(
                  includeLoans ? 'Net worth' : 'Gross net worth',
                  style: TextStyle(
                      color: scheme.onPrimary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              Money.format(value),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: scheme.onPrimary, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  const _MiniCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(Money.format(value),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _AssetBreakdown extends StatelessWidget {
  final NetWorthData data;
  const _AssetBreakdown({required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.assetBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = data.assets;
    return PaddedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('Asset allocation'),
          ...entries.map((e) {
            final pct = total == 0 ? 0.0 : e.value / total;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(e.key.icon, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e.key.label)),
                      Text(Money.format(e.value),
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ThinProgress(pct),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LiabilitiesList extends ConsumerWidget {
  const _LiabilitiesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loanSummariesProvider);
    return loans.maybeWhen(
      data: (list) {
        final active = list.where((l) => !l.loan.closed && l.outstanding > 0).toList();
        if (active.isEmpty) return const SizedBox.shrink();
        return PaddedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader('Liabilities'),
              ...active.map((l) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Icon(l.loan.type.icon, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(l.loan.name)),
                        Text(Money.format(l.outstanding),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.error)),
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

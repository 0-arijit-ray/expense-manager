import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database.dart';
import '../../data/local/enums.dart';
import '../../data/providers.dart';

final investmentsProvider = StreamProvider<List<Investment>>(
  (ref) => ref.watch(investmentRepoProvider).watchInvestments(),
);

class PortfolioSummary {
  final double invested;
  final double current;
  final Map<AssetType, double> byType;
  const PortfolioSummary(this.invested, this.current, this.byType);

  double get gain => current - invested;
  double get gainPct => invested == 0 ? 0 : gain / invested * 100;
}

final portfolioSummaryProvider = Provider<AsyncValue<PortfolioSummary>>((ref) {
  final inv = ref.watch(investmentsProvider);
  return inv.whenData((list) {
    var invested = 0.0;
    var current = 0.0;
    final byType = <AssetType, double>{};
    for (final i in list) {
      invested += i.investedAmount;
      current += i.currentValue;
      byType.update(i.type, (v) => v + i.currentValue,
          ifAbsent: () => i.currentValue);
    }
    return PortfolioSummary(invested, current, byType);
  });
});

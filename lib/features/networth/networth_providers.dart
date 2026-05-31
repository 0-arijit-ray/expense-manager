import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/enums.dart';
import '../investments/investments_providers.dart';
import '../loans/loans_providers.dart';

class NetWorthData {
  final double assets;
  final double liabilities;
  final Map<AssetType, double> assetBreakdown;
  const NetWorthData(this.assets, this.liabilities, this.assetBreakdown);

  /// Net worth counting loans as liabilities.
  double get withLoans => assets - liabilities;

  /// Gross net worth ignoring outstanding loans.
  double get withoutLoans => assets;
}

/// Combines the portfolio (assets) with outstanding loan balances (liabilities).
final netWorthProvider = Provider<AsyncValue<NetWorthData>>((ref) {
  final portfolio = ref.watch(portfolioSummaryProvider);
  final loans = ref.watch(loanSummariesProvider);

  if (portfolio is AsyncLoading || loans is AsyncLoading) {
    return const AsyncLoading();
  }
  if (portfolio is AsyncError) {
    return AsyncError(portfolio.error!, portfolio.stackTrace!);
  }
  if (loans is AsyncError) {
    return AsyncError(loans.error!, loans.stackTrace!);
  }

  final p = portfolio.value!;
  final loanList = loans.value!;
  final liabilities = loanList
      .where((l) => !l.loan.closed)
      .fold<double>(0, (s, l) => s + l.outstanding);

  return AsyncData(NetWorthData(p.current, liabilities, p.byType));
});

/// Toggle: include outstanding loans (liabilities) in the net-worth figure.
class IncludeLoansToggle extends Notifier<bool> {
  @override
  bool build() => true;
  void set(bool v) => state = v;
}

final includeLoansProvider =
    NotifierProvider<IncludeLoansToggle, bool>(IncludeLoansToggle.new);

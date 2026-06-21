import { usePortfolioSummary } from '../../db/investment-repository';
import { useLoanSummaries } from '../../db/loan-repository';
import { useNetWorthStore } from '../../stores/networth-store';
import { formatMoney } from '../../lib/formatters';
import { AssetTypeLabels } from '../../lib/enum-labels';
import { Landmark, TrendingUp, ArrowDown } from 'lucide-react';
import type { AssetType } from '../../types';

export default function NetWorthScreen() {
  const portfolio = usePortfolioSummary();
  const loanSummaries = useLoanSummaries();
  const { includeLoans, toggleIncludeLoans } = useNetWorthStore();

  const totalLiabilities = loanSummaries
    .filter((s) => !s.loan.closed)
    .reduce((sum, s) => sum + s.outstanding, 0);

  const assets = portfolio.current;
  const liabilities = totalLiabilities;
  const netWorth = includeLoans ? assets - liabilities : assets;

  const assetBreakdown = Array.from(portfolio.byType.entries()).map(([type, values]) => ({
    type,
    value: values.current,
    percentage: assets > 0 ? (values.current / assets) * 100 : 0,
  }));

  return (
    <div className="p-4 pb-24">
      <h1 className="text-xl font-bold text-gray-900 dark:text-white mb-4">Net Worth</h1>

      <div className="bg-gradient-to-br from-primary to-primary-dark rounded-2xl p-6 text-white mb-4">
        <div className="text-sm opacity-80 mb-1">
          {includeLoans ? 'Net Worth' : 'Gross Assets'}
        </div>
        <div className="text-3xl font-bold mb-4">{formatMoney(netWorth)}</div>

        <div className="flex gap-4">
          <div className="flex-1 bg-white/10 rounded-xl p-3">
            <div className="flex items-center gap-2 mb-1">
              <TrendingUp className="w-4 h-4 text-green-300" />
              <span className="text-xs opacity-80">Assets</span>
            </div>
            <div className="text-lg font-semibold">{formatMoney(assets)}</div>
          </div>

          <div className="flex-1 bg-white/10 rounded-xl p-3">
            <div className="flex items-center gap-2 mb-1">
              <ArrowDown className="w-4 h-4 text-red-300" />
              <span className="text-xs opacity-80">Liabilities</span>
            </div>
            <div className="text-lg font-semibold">{formatMoney(liabilities)}</div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm mb-4">
        <label className="flex items-center gap-3">
          <input
            type="checkbox"
            checked={includeLoans}
            onChange={toggleIncludeLoans}
            className="w-4 h-4 text-primary rounded focus:ring-primary"
          />
          <span className="text-sm text-gray-700 dark:text-gray-300">
            Subtract outstanding loans
          </span>
        </label>
      </div>

      {assetBreakdown.length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm mb-4">
          <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-3">
            Asset Allocation
          </h3>
          <div className="space-y-3">
            {assetBreakdown.map((item) => (
              <div key={item.type}>
                <div className="flex items-center justify-between mb-1">
                  <span className="text-sm text-gray-700 dark:text-gray-300">
                    {AssetTypeLabels[item.type as AssetType]}
                  </span>
                  <span className="text-sm font-medium text-gray-900 dark:text-white">
                    {formatMoney(item.value)}
                  </span>
                </div>
                <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                  <div
                    className="bg-primary h-2 rounded-full transition-all"
                    style={{ width: `${item.percentage}%` }}
                  />
                </div>
                <div className="text-xs text-gray-500 mt-1">
                  {item.percentage.toFixed(1)}%
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {loanSummaries.filter((s) => !s.loan.closed).length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-3">
            Liabilities
          </h3>
          <div className="space-y-2">
            {loanSummaries
              .filter((s) => !s.loan.closed)
              .map((summary) => (
                <div
                  key={summary.loan.id}
                  className="flex items-center justify-between p-2 rounded-lg bg-gray-50 dark:bg-gray-750"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-red-100 dark:bg-red-900/30 flex items-center justify-center">
                      <Landmark className="w-4 h-4 text-red-600 dark:text-red-400" />
                    </div>
                    <div>
                      <div className="text-sm font-medium text-gray-900 dark:text-white">
                        {summary.loan.name}
                      </div>
                      <div className="text-xs text-gray-500">
                        {summary.paidCount}/{summary.totalCount} paid
                      </div>
                    </div>
                  </div>
                  <div className="text-sm font-semibold text-red-600 dark:text-red-400">
                    {formatMoney(summary.outstanding)}
                  </div>
                </div>
              ))}
          </div>
        </div>
      )}
    </div>
  );
}

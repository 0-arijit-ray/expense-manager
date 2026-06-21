import { usePortfolioSummary } from '../../db/investment-repository';
import { useLoanSummaries } from '../../db/loan-repository';
import { useNetWorthStore } from '../../stores/networth-store';
import { formatMoney, formatMoneyCompact } from '../../lib/formatters';
import { AssetTypeLabels } from '../../lib/enum-labels';
import { Card, Toggle } from '../../components/ui';
import { Landmark, TrendingUp, ArrowDown, Wallet } from 'lucide-react';
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

  const assetBreakdown = Array.from(portfolio.byType.entries()).map(
    ([type, values]) => ({
      type,
      value: values.current,
      percentage: assets > 0 ? (values.current / assets) * 100 : 0,
    })
  );

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
          Net Worth
        </h1>
        <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
          Your financial position
        </p>
      </div>

      {/* Hero Card */}
      <Card variant="gradient" padding="lg" className="relative overflow-hidden">
        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxnIGZpbGw9IiNmZmZmZmYiIGZpbGwtb3BhY2l0eT0iMC4wNSI+PHBhdGggZD0iTTM2IDM0djItSDI0di0yaDEyem0wLTR2Mkg4VjI4aDI4em0wLTRWMjBIMnYyaDM0eiIvPjwvZz48L2c+PC9zdmc+')] opacity-30" />
        <div className="relative">
          <div className="flex items-center gap-2 mb-2">
            <Wallet className="w-5 h-5 opacity-80" />
            <span className="text-sm font-medium opacity-80">
              {includeLoans ? 'Net Worth' : 'Gross Assets'}
            </span>
          </div>
          <div className="text-4xl font-bold mb-6">
            {formatMoneyCompact(netWorth)}
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="bg-white/10 rounded-xl p-4">
              <div className="flex items-center gap-2 mb-1">
                <TrendingUp className="w-4 h-4 text-green-300" />
                <span className="text-xs font-medium opacity-80">Assets</span>
              </div>
              <div className="text-xl font-bold">{formatMoney(assets)}</div>
            </div>
            <div className="bg-white/10 rounded-xl p-4">
              <div className="flex items-center gap-2 mb-1">
                <ArrowDown className="w-4 h-4 text-red-300" />
                <span className="text-xs font-medium opacity-80">Liabilities</span>
              </div>
              <div className="text-xl font-bold">{formatMoney(liabilities)}</div>
            </div>
          </div>
        </div>
      </Card>

      {/* Toggle */}
      <Card padding="md">
        <Toggle
          checked={includeLoans}
          onChange={toggleIncludeLoans}
          label="Subtract outstanding loans from net worth"
        />
      </Card>

      {/* Asset Allocation */}
      {assetBreakdown.length > 0 && (
        <Card padding="lg">
          <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-4">
            Asset Allocation
          </h3>
          <div className="space-y-4">
            {assetBreakdown.map((item) => (
              <div key={item.type}>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm text-gray-700 dark:text-gray-300">
                    {AssetTypeLabels[item.type as AssetType]}
                  </span>
                  <div className="flex items-center gap-3">
                    <span className="text-sm font-medium text-gray-900 dark:text-white">
                      {formatMoney(item.value)}
                    </span>
                    <span className="text-xs text-gray-500 dark:text-gray-400 w-12 text-right">
                      {item.percentage.toFixed(1)}%
                    </span>
                  </div>
                </div>
                <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                  <div
                    className="bg-gradient-to-r from-primary to-primary-light h-2 rounded-full transition-all duration-500"
                    style={{ width: `${item.percentage}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </Card>
      )}

      {/* Liabilities */}
      {loanSummaries.filter((s) => !s.loan.closed).length > 0 && (
        <Card padding="lg">
          <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-4">
            Liabilities
          </h3>
          <div className="space-y-3">
            {loanSummaries
              .filter((s) => !s.loan.closed)
              .map((summary) => (
                <div
                  key={summary.loan.id}
                  className="flex items-center justify-between p-4 rounded-xl bg-gray-50 dark:bg-gray-750"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center">
                      <Landmark className="w-5 h-5 text-red-600 dark:text-red-400" />
                    </div>
                    <div>
                      <div className="text-sm font-medium text-gray-900 dark:text-white">
                        {summary.loan.name}
                      </div>
                      <div className="text-xs text-gray-500 dark:text-gray-400">
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
        </Card>
      )}
    </div>
  );
}

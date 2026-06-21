import { useInvestments, usePortfolioSummary } from '../../db/investment-repository';
import { formatMoney, formatMoneyCompact } from '../../lib/formatters';
import { AssetTypeLabels } from '../../lib/enum-labels';
import InvestmentForm from './InvestmentForm';
import { useState } from 'react';
import { Plus, PiggyBank, TrendingUp, TrendingDown } from 'lucide-react';
import { clsx } from 'clsx';

export default function InvestmentsScreen() {
  const investments = useInvestments();
  const portfolio = usePortfolioSummary();
  const [showForm, setShowForm] = useState(false);

  return (
    <div className="p-4">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-xl font-bold text-gray-900 dark:text-white">Investments</h1>
      </div>

      {investments.length > 0 && (
        <div className="bg-gradient-to-br from-primary to-primary-dark rounded-2xl p-4 mb-4 text-white">
          <div className="flex items-center gap-2 mb-2">
            <PiggyBank className="w-4 h-4 opacity-80" />
            <span className="text-sm opacity-80">Portfolio Value</span>
          </div>
          <div className="text-2xl font-bold mb-1">{formatMoneyCompact(portfolio.current)}</div>
          <div className="flex items-center gap-2 mb-4">
            <span
              className={clsx(
                'text-sm font-medium',
                portfolio.gain >= 0 ? 'text-green-300' : 'text-red-300'
              )}
            >
              {portfolio.gain >= 0 ? '+' : ''} {formatMoney(portfolio.gain)} ({portfolio.gainPct.toFixed(1)}%)
            </span>
          </div>
          <div className="text-sm opacity-80">
            Invested: {formatMoney(portfolio.invested)}
          </div>
        </div>
      )}

      {investments.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-12 text-center">
          <div className="w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4">
            <Plus className="w-8 h-8 text-gray-400" />
          </div>
          <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-1">
            No investments yet
          </h3>
          <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
            Add your first investment to track your portfolio
          </p>
          <button
            onClick={() => setShowForm(true)}
            className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            Add Investment
          </button>
        </div>
      ) : (
        <div className="space-y-3">
          {investments.map((inv) => {
            const gain = inv.currentValue - inv.investedAmount;
            const gainPct = inv.investedAmount > 0 ? (gain / inv.investedAmount) * 100 : 0;

            return (
              <div
                key={inv.id}
                onClick={() => setShowForm(true)}
                className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors cursor-pointer"
              >
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
                      <PiggyBank className="w-5 h-5 text-primary" />
                    </div>
                    <div>
                      <div className="text-sm font-semibold text-gray-900 dark:text-white">
                        {inv.name}
                      </div>
                      <div className="text-xs text-gray-500 dark:text-gray-400">
                        {AssetTypeLabels[inv.type]}
                        {inv.institution && ` • ${inv.institution}`}
                      </div>
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-sm font-bold text-gray-900 dark:text-white">
                      {formatMoney(inv.currentValue)}
                    </div>
                    <div
                      className={clsx(
                        'text-xs font-medium flex items-center gap-1 justify-end',
                        gain >= 0 ? 'text-green-600 dark:text-green-400' : 'text-red-600 dark:text-red-400'
                      )}
                    >
                      {gain >= 0 ? (
                        <TrendingUp className="w-3 h-3" />
                      ) : (
                        <TrendingDown className="w-3 h-3" />
                      )}
                      {gain >= 0 ? '+' : ''} {gainPct.toFixed(1)}%
                    </div>
                  </div>
                </div>

                <div className="mt-3 flex items-center justify-between text-xs text-gray-500">
                  <span>Invested: {formatMoney(inv.investedAmount)}</span>
                  {inv.annualRate && <span>Rate: {inv.annualRate}%</span>}
                </div>
              </div>
            );
          })}
        </div>
      )}

      <button
        onClick={() => setShowForm(true)}
        className="fixed bottom-24 right-4 w-14 h-14 bg-primary rounded-full shadow-lg flex items-center justify-center text-white hover:bg-primary-dark transition-colors z-40"
      >
        <Plus className="w-6 h-6" />
      </button>

      {showForm && (
        <InvestmentForm
          onClose={() => setShowForm(false)}
          onSave={() => setShowForm(false)}
        />
      )}
    </div>
  );
}

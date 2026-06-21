import { useEffect, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { usePeriodStore } from '../../stores/period-store';
import { rangeFor } from '../../lib/date-range';
import { useTransactions } from '../../db/expense-repository';
import { useLoanSummaries, useUpcomingEmis } from '../../db/loan-repository';
import { usePortfolioSummary } from '../../db/investment-repository';
import { formatMoney } from '../../lib/formatters';
import PeriodSelector from './PeriodSelector';
import SummaryCard from './SummaryCard';
import { IncomeExpenseBarChart, CategoryDonut } from './DashboardCharts';
import { seedDefaultCategories } from '../../db/database';
import { processAllRecurring } from '../../db/recurring-repository';
import { autoProcessDueEmis } from '../../db/loan-repository';
import { Settings, Bell, Plus, TrendingUp } from 'lucide-react';
import type { DashboardData, SeriesPoint, CategorySlice } from '../../types';
import { TxnType } from '../../types';

export default function DashboardScreen() {
  const navigate = useNavigate();
  const { period, anchor } = usePeriodStore();
  const range = rangeFor(period, anchor);
  const transactions = useTransactions({ from: range.start, to: range.end });
  const loanSummaries = useLoanSummaries();
  const upcomingEmis = useUpcomingEmis(60);
  const portfolio = usePortfolioSummary();

  useEffect(() => {
    seedDefaultCategories();
    processAllRecurring();
    autoProcessDueEmis();
  }, []);

  const dashboardData = useMemo<DashboardData>(() => {
    let income = 0;
    let expense = 0;
    const categoryTotals = new Map<number, { category: any; total: number }>();

    for (const txn of transactions) {
      if (txn.type === TxnType.Income) {
        income += txn.amount;
      } else {
        expense += txn.amount;
      }

      if (txn.categoryId) {
        const existing = categoryTotals.get(txn.categoryId);
        if (existing) {
          existing.total += txn.amount;
        } else {
          categoryTotals.set(txn.categoryId, {
            category: txn.category,
            total: txn.amount,
          });
        }
      }
    }

    const series: SeriesPoint[] = [];
    const byCategory: CategorySlice[] = Array.from(categoryTotals.values())
      .sort((a, b) => b.total - a.total)
      .slice(0, 6);

    return {
      income,
      expense,
      net: income - expense,
      series,
      byCategory,
      txnCount: transactions.length,
    };
  }, [transactions]);

  const totalOutstanding = loanSummaries.reduce((sum, s) => sum + s.outstanding, 0);

  return (
    <div className="p-4 space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-xl font-bold text-gray-900 dark:text-white">Dashboard</h1>
        <div className="flex gap-2">
          <button
            onClick={() => navigate('/settings')}
            className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
          >
            <Settings className="w-5 h-5 text-gray-600 dark:text-gray-400" />
          </button>
          <button
            onClick={() => navigate('/loans')}
            className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors relative"
          >
            <Bell className="w-5 h-5 text-gray-600 dark:text-gray-400" />
            {upcomingEmis.length > 0 && (
              <span className="absolute -top-1 -right-1 w-4 h-4 bg-red-500 rounded-full text-white text-[10px] flex items-center justify-center">
                {upcomingEmis.length}
              </span>
            )}
          </button>
        </div>
      </div>

      <PeriodSelector />

      <SummaryCard
        income={dashboardData.income}
        expense={dashboardData.expense}
        net={dashboardData.net}
      />

      {dashboardData.series.length > 0 && (
        <IncomeExpenseBarChart data={dashboardData.series} />
      )}

      <CategoryDonut data={dashboardData.byCategory} />

      <button
        onClick={() => navigate('/networth')}
        className="w-full bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm flex items-center justify-between hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
      >
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
            <TrendingUp className="w-5 h-5 text-primary" />
          </div>
          <div className="text-left">
            <div className="text-sm text-gray-500 dark:text-gray-400">Net Worth</div>
            <div className="text-lg font-semibold text-gray-900 dark:text-white">
              {formatMoney(portfolio.current - totalOutstanding)}
            </div>
          </div>
        </div>
      </button>

      {upcomingEmis.length > 0 && (
        <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
          <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-3">
            Upcoming EMIs
          </h3>
          <div className="space-y-2">
            {upcomingEmis.slice(0, 3).map(({ emi, loan }) => (
              <div
                key={emi.id}
                className="flex items-center justify-between p-2 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-750 cursor-pointer"
                onClick={() => navigate(`/loans/${loan.id}`)}
              >
                <div>
                  <div className="text-sm font-medium text-gray-900 dark:text-white">
                    {loan.name}
                  </div>
                  <div className="text-xs text-gray-500">
                    #{emi.installmentNo} • Due {new Date(emi.dueDate).toLocaleDateString()}
                  </div>
                </div>
                <div className="text-sm font-semibold text-red-600">
                  {formatMoney(emi.emiAmount)}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      <button
        onClick={() => navigate('/expenses')}
        className="fixed bottom-24 right-4 w-14 h-14 bg-primary rounded-full shadow-lg flex items-center justify-center text-white hover:bg-primary-dark transition-colors z-40"
      >
        <Plus className="w-6 h-6" />
      </button>
    </div>
  );
}

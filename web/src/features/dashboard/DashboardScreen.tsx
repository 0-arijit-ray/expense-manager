import { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { usePeriodStore } from '../../stores/period-store';
import { useSettingsStore } from '../../stores/settings-store';
import { rangeFor } from '../../lib/date-range';
import { useTransactions } from '../../db/expense-repository';
import { useLoanSummaries, useUpcomingEmis } from '../../db/loan-repository';
import { usePortfolioSummary } from '../../db/investment-repository';
import { formatMoney, formatMoneyCompact } from '../../lib/formatters';
import { seedDefaultCategories } from '../../db/database';
import { processAllRecurring } from '../../db/recurring-repository';
import { autoProcessDueEmis } from '../../db/loan-repository';
import { Card, Button } from '../../components/ui';
import PeriodSelector from './PeriodSelector';
import { IncomeExpenseBarChart, CategoryDonut } from './DashboardCharts';
import ExpenseForm from '../expenses/ExpenseForm';
import {
  Settings,
  Bell,
  Plus,
  TrendingUp,
  TrendingDown,
  ArrowUpRight,
  ArrowDownRight,
  PiggyBank,
  Landmark,
  Receipt,
  CircleDollarSign,
  Target,
  Zap,
  Sun,
  Moon,
} from 'lucide-react';
import { TxnType } from '../../types';
import type { DashboardData, SeriesPoint, CategorySlice } from '../../types';
import { format } from 'date-fns';

function getGreeting(): string {
  const hour = new Date().getHours();
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

export default function DashboardScreen() {
  const navigate = useNavigate();
  const { period, anchor } = usePeriodStore();
  const range = rangeFor(period, anchor);
  const transactions = useTransactions({ from: range.start, to: range.end });
  const loanSummaries = useLoanSummaries();
  const upcomingEmis = useUpcomingEmis(60);
  const portfolio = usePortfolioSummary();
  const [showAlerts, setShowAlerts] = useState(false);
  const [showTransactionForm, setShowTransactionForm] = useState(false);
  const { themeMode, setThemeMode } = useSettingsStore();

  const toggleTheme = () => {
    const next = themeMode === 'light' ? 'dark' : 'light';
    setThemeMode(next);
  };

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
  const netWorth = portfolio.current - totalOutstanding;
  const savingsRate = dashboardData.income > 0
    ? Math.round(((dashboardData.income - dashboardData.expense) / dashboardData.income) * 100)
    : 0;
  const topCategory = dashboardData.byCategory[0];
  const expenseBarWidth = dashboardData.income > 0
    ? Math.min((dashboardData.expense / dashboardData.income) * 100, 100)
    : 0;

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            {getGreeting()}
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {format(new Date(), 'EEEE, MMMM d')}
          </p>
        </div>
        <div className="flex gap-2">
          <Button
            variant="ghost"
            size="sm"
            onClick={toggleTheme}
            className="rounded-xl"
          >
            {themeMode === 'dark' ? (
              <Sun className="w-5 h-5" />
            ) : (
              <Moon className="w-5 h-5" />
            )}
          </Button>
          <Button
            variant="ghost"
            size="sm"
            onClick={() => navigate('/settings')}
            className="rounded-xl"
          >
            <Settings className="w-5 h-5" />
          </Button>
          <div className="relative">
            <Button
              variant="ghost"
              size="sm"
              onClick={() => setShowAlerts(!showAlerts)}
              className="rounded-xl relative"
            >
              <Bell className="w-5 h-5" />
              {upcomingEmis.length > 0 && (
                <span className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full text-white text-[10px] flex items-center justify-center font-medium">
                  {upcomingEmis.length}
                </span>
              )}
            </Button>

            {/* Alerts Dropdown */}
            {showAlerts && (
              <>
                <div
                  className="fixed inset-0 z-40"
                  onClick={() => setShowAlerts(false)}
                />
                <div className="absolute right-0 top-full mt-2 w-80 bg-white dark:bg-gray-800 rounded-2xl shadow-xl border border-gray-200 dark:border-gray-700 z-50 overflow-hidden animate-slideInUp">
                  <div className="px-4 py-3 border-b border-gray-200 dark:border-gray-700">
                    <h3 className="text-sm font-semibold text-gray-900 dark:text-white">
                      Upcoming EMIs
                    </h3>
                    <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
                      {upcomingEmis.length === 0
                        ? 'No upcoming payments'
                        : `${upcomingEmis.length} payment${upcomingEmis.length !== 1 ? 's' : ''} due in the next 60 days`}
                    </p>
                  </div>

                  {upcomingEmis.length > 0 ? (
                    <div className="max-h-72 overflow-y-auto">
                      {upcomingEmis.map(({ emi, loan }) => (
                        <div
                          key={emi.id}
                          onClick={() => {
                            navigate(`/loans/${loan.id}`);
                            setShowAlerts(false);
                          }}
                          className="flex items-center justify-between px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors cursor-pointer border-b border-gray-100 dark:border-gray-700 last:border-0"
                        >
                          <div className="flex items-center gap-3">
                            <div className="w-9 h-9 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center">
                              <Landmark className="w-4 h-4 text-red-600 dark:text-red-400" />
                            </div>
                            <div>
                              <div className="text-sm font-medium text-gray-900 dark:text-white">
                                {loan.name}
                              </div>
                              <div className="text-xs text-gray-500 dark:text-gray-400">
                                #{emi.installmentNo} • Due{' '}
                                {new Date(emi.dueDate).toLocaleDateString('en', {
                                  month: 'short',
                                  day: 'numeric',
                                })}
                              </div>
                            </div>
                          </div>
                          <div className="text-sm font-semibold text-red-600 dark:text-red-400">
                            {formatMoney(emi.emiAmount)}
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="px-4 py-8 text-center">
                      <Bell className="w-8 h-8 text-gray-300 dark:text-gray-600 mx-auto mb-2" />
                      <p className="text-sm text-gray-500 dark:text-gray-400">
                        All clear! No upcoming EMIs.
                      </p>
                    </div>
                  )}

                  {upcomingEmis.length > 0 && (
                    <div className="px-4 py-2.5 border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800">
                      <button
                        onClick={() => {
                          navigate('/loans');
                          setShowAlerts(false);
                        }}
                        className="w-full text-sm font-medium text-primary hover:text-primary-dark transition-colors"
                      >
                        View all loans
                      </button>
                    </div>
                  )}
                </div>
              </>
            )}
          </div>
        </div>
      </div>

      {/* Period Selector */}
      <PeriodSelector />

      {/* Hero Card */}
      <Card variant="gradient" padding="lg" className="relative overflow-hidden">
        <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxnIGZpbGw9IiNmZmZmZmYiIGZpbGwtb3BhY2l0eT0iMC4wNSI+PHBhdGggZD0iTTM2IDM0djItSDI0di0yaDEyem0wLTR2Mkg4VjI4aDI4em0wLTRWMjBIMnYyaDM0eiIvPjwvZz48L2c+PC9zdmc+')] opacity-30" />
        <div className="relative">
          {/* Savings Rate */}
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 bg-white/15 rounded-xl flex items-center justify-center">
                <Target className="w-5 h-5" />
              </div>
              <div>
                <span className="text-xs font-medium opacity-70">Savings Rate</span>
                <div className="text-2xl font-bold">{savingsRate}%</div>
              </div>
            </div>
            <div className="text-right">
              <span className="text-xs font-medium opacity-70">Net Balance</span>
              <div className="text-2xl font-bold">{formatMoneyCompact(dashboardData.net)}</div>
            </div>
          </div>

          {/* Income vs Expense Bar */}
          <div className="mb-4">
            <div className="flex items-center justify-between text-xs mb-1.5">
              <span className="opacity-70">Spent {expenseBarWidth.toFixed(0)}% of income</span>
              <span className="opacity-70">{formatMoney(dashboardData.income - dashboardData.expense)} saved</span>
            </div>
            <div className="w-full bg-white/15 rounded-full h-2">
              <div
                className="bg-white h-2 rounded-full transition-all duration-700"
                style={{ width: `${expenseBarWidth}%` }}
              />
            </div>
          </div>

          {/* Income / Expense split */}
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-white/10 rounded-xl p-3">
              <div className="flex items-center gap-1.5 mb-1">
                <ArrowUpRight className="w-3.5 h-3.5 text-green-300" />
                <span className="text-xs font-medium opacity-80">Income</span>
              </div>
              <div className="text-lg font-bold">{formatMoney(dashboardData.income)}</div>
            </div>
            <div className="bg-white/10 rounded-xl p-3">
              <div className="flex items-center gap-1.5 mb-1">
                <ArrowDownRight className="w-3.5 h-3.5 text-red-300" />
                <span className="text-xs font-medium opacity-80">Expense</span>
              </div>
              <div className="text-lg font-bold">{formatMoney(dashboardData.expense)}</div>
            </div>
          </div>
        </div>
      </Card>

      {/* Quick Actions */}
      <div className="grid grid-cols-3 gap-3">
        <button
          onClick={() => setShowTransactionForm(true)}
          className="flex flex-col items-center gap-2 p-4 bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 hover:shadow-md transition-shadow"
        >
          <div className="w-10 h-10 bg-primary/10 rounded-xl flex items-center justify-center">
            <Receipt className="w-5 h-5 text-primary" />
          </div>
          <span className="text-xs font-medium text-gray-700 dark:text-gray-300">Transaction</span>
        </button>
        <button
          onClick={() => navigate('/loans')}
          className="flex flex-col items-center gap-2 p-4 bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 hover:shadow-md transition-shadow"
        >
          <div className="w-10 h-10 bg-amber-100 dark:bg-amber-900/30 rounded-xl flex items-center justify-center">
            <Landmark className="w-5 h-5 text-amber-600 dark:text-amber-400" />
          </div>
          <span className="text-xs font-medium text-gray-700 dark:text-gray-300">Loan</span>
        </button>
        <button
          onClick={() => navigate('/investments')}
          className="flex flex-col items-center gap-2 p-4 bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 hover:shadow-md transition-shadow"
        >
          <div className="w-10 h-10 bg-blue-100 dark:bg-blue-900/30 rounded-xl flex items-center justify-center">
            <PiggyBank className="w-5 h-5 text-blue-600 dark:text-blue-400" />
          </div>
          <span className="text-xs font-medium text-gray-700 dark:text-gray-300">Invest</span>
        </button>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 stagger-children">
        <Card variant="hover" padding="md" onClick={() => navigate('/expenses')}>
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 bg-green-100 dark:bg-green-900/30 rounded-xl flex items-center justify-center">
              <CircleDollarSign className="w-5 h-5 text-green-600 dark:text-green-400" />
            </div>
            <span className="text-xs text-gray-500 dark:text-gray-400">
              {dashboardData.txnCount} txn{dashboardData.txnCount !== 1 ? 's' : ''}
            </span>
          </div>
          <div className="text-sm text-gray-500 dark:text-gray-400">Income</div>
          <div className="text-lg font-bold text-gray-900 dark:text-white">
            {formatMoney(dashboardData.income)}
          </div>
        </Card>

        <Card variant="hover" padding="md" onClick={() => navigate('/expenses')}>
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center">
              <Zap className="w-5 h-5 text-red-600 dark:text-red-400" />
            </div>
            {topCategory && (
              <span className="text-xs text-gray-500 dark:text-gray-400 truncate max-w-[80px]">
                Top: {topCategory.category?.name || 'Other'}
              </span>
            )}
          </div>
          <div className="text-sm text-gray-500 dark:text-gray-400">Expense</div>
          <div className="text-lg font-bold text-gray-900 dark:text-white">
            {formatMoney(dashboardData.expense)}
          </div>
        </Card>

        <Card variant="hover" padding="md" onClick={() => navigate('/investments')}>
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 bg-blue-100 dark:bg-blue-900/30 rounded-xl flex items-center justify-center">
              <PiggyBank className="w-5 h-5 text-blue-600 dark:text-blue-400" />
            </div>
            {portfolio.invested > 0 && (
              <span
                className={`text-xs font-medium flex items-center gap-0.5 ${
                  portfolio.gain >= 0
                    ? 'text-green-600 dark:text-green-400'
                    : 'text-red-600 dark:text-red-400'
                }`}
              >
                {portfolio.gain >= 0 ? (
                  <TrendingUp className="w-3 h-3" />
                ) : (
                  <TrendingDown className="w-3 h-3" />
                )}
                {portfolio.gainPct.toFixed(1)}%
              </span>
            )}
          </div>
          <div className="text-sm text-gray-500 dark:text-gray-400">Portfolio</div>
          <div className="text-lg font-bold text-gray-900 dark:text-white">
            {formatMoneyCompact(portfolio.current)}
          </div>
        </Card>

        <Card variant="hover" padding="md" onClick={() => navigate('/networth')}>
          <div className="flex items-center justify-between mb-3">
            <div className="w-10 h-10 bg-amber-100 dark:bg-amber-900/30 rounded-xl flex items-center justify-center">
              <Landmark className="w-5 h-5 text-amber-600 dark:text-amber-400" />
            </div>
            {loanSummaries.length > 0 && (
              <span className="text-xs text-gray-500 dark:text-gray-400">
                {loanSummaries.length} loan{loanSummaries.length !== 1 ? 's' : ''}
              </span>
            )}
          </div>
          <div className="text-sm text-gray-500 dark:text-gray-400">Outstanding</div>
          <div className="text-lg font-bold text-gray-900 dark:text-white">
            {formatMoneyCompact(totalOutstanding)}
          </div>
        </Card>
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
        <IncomeExpenseBarChart data={dashboardData.series} />
        <CategoryDonut data={dashboardData.byCategory} />
      </div>

      {/* Net Worth & Upcoming EMIs */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
        <Card
          variant="hover"
          padding="lg"
          onClick={() => navigate('/networth')}
        >
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center">
              <TrendingUp className="w-6 h-6 text-primary" />
            </div>
            <div>
              <div className="text-sm text-gray-500 dark:text-gray-400">Net Worth</div>
              <div className="text-2xl font-bold text-gray-900 dark:text-white">
                {formatMoneyCompact(netWorth)}
              </div>
            </div>
          </div>
          <div className="text-sm text-primary font-medium flex items-center gap-1">
            View Details
            <ArrowUpRight className="w-4 h-4" />
          </div>
        </Card>

        {upcomingEmis.length > 0 && (
          <Card padding="lg">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300">
                Upcoming EMIs
              </h3>
              <span className="text-xs font-medium text-gray-500">
                {upcomingEmis.length} due
              </span>
            </div>
            <div className="space-y-3">
              {upcomingEmis.slice(0, 3).map(({ emi, loan }) => (
                <div
                  key={emi.id}
                  onClick={() => navigate(`/loans/${loan.id}`)}
                  className="flex items-center justify-between p-3 rounded-xl bg-gray-50 dark:bg-gray-750 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors cursor-pointer"
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-red-100 dark:bg-red-900/30 rounded-xl flex items-center justify-center">
                      <Landmark className="w-5 h-5 text-red-600 dark:text-red-400" />
                    </div>
                    <div>
                      <div className="text-sm font-medium text-gray-900 dark:text-white">
                        {loan.name}
                      </div>
                      <div className="text-xs text-gray-500">
                        #{emi.installmentNo} • Due{' '}
                        {new Date(emi.dueDate).toLocaleDateString()}
                      </div>
                    </div>
                  </div>
                  <div className="text-sm font-semibold text-red-600 dark:text-red-400">
                    {formatMoney(emi.emiAmount)}
                  </div>
                </div>
              ))}
            </div>
          </Card>
        )}
      </div>

      {/* Quick Add FAB */}
      <div className="fixed bottom-8 right-8 lg:bottom-12 lg:right-12">
        <Button
          onClick={() => setShowTransactionForm(true)}
          className="w-14 h-14 rounded-full shadow-lg hover:shadow-xl"
        >
          <Plus className="w-6 h-6" />
        </Button>
      </div>

      {/* Transaction Form Modal */}
      {showTransactionForm && (
        <ExpenseForm
          onClose={() => setShowTransactionForm(false)}
          onSave={() => {
            setShowTransactionForm(false);
            navigate('/expenses');
          }}
        />
      )}
    </div>
  );
}

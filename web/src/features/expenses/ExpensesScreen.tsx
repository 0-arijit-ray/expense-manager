import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTransactions, deleteTransaction } from '../../db/expense-repository';
import { formatMoney } from '../../lib/formatters';
import { Card, Button, EmptyState, ConfirmDialog } from '../../components/ui';
import TransactionTile from './TransactionTile';
import ExpenseForm from './ExpenseForm';
import { Plus, Repeat, Receipt, ArrowRightLeft } from 'lucide-react';
import type { TransactionWithCategory } from '../../types';
import { format, isToday, isYesterday, startOfWeek, endOfWeek, startOfMonth, endOfMonth, isWithinInterval } from 'date-fns';

export default function ExpensesScreen() {
  const navigate = useNavigate();
  const transactions = useTransactions({ limit: 300 });
  const [showForm, setShowForm] = useState(false);
  const [editingTransaction, setEditingTransaction] = useState<TransactionWithCategory | undefined>();
  const [deletingTxn, setDeletingTxn] = useState<TransactionWithCategory | null>(null);

  const now = new Date();
  const weekStart = startOfWeek(now, { weekStartsOn: 1 });
  const weekEnd = endOfWeek(now, { weekStartsOn: 1 });
  const monthStart = startOfMonth(now);
  const monthEnd = endOfMonth(now);

  const stats = useMemo(() => {
    const thisWeek = transactions.filter((t) =>
      isWithinInterval(new Date(t.date), { start: weekStart, end: weekEnd })
    );
    const thisMonth = transactions.filter((t) =>
      isWithinInterval(new Date(t.date), { start: monthStart, end: monthEnd })
    );

    const weekIncome = thisWeek
      .filter((t) => t.type === 1)
      .reduce((s, t) => s + t.amount, 0);
    const weekExpense = thisWeek
      .filter((t) => t.type === 0)
      .reduce((s, t) => s + t.amount, 0);
    const monthIncome = thisMonth
      .filter((t) => t.type === 1)
      .reduce((s, t) => s + t.amount, 0);
    const monthExpense = thisMonth
      .filter((t) => t.type === 0)
      .reduce((s, t) => s + t.amount, 0);

    return { weekIncome, weekExpense, monthIncome, monthExpense };
  }, [transactions, weekStart, weekEnd, monthStart, monthEnd]);

  const groupedTransactions = useMemo(() => {
    const groups = new Map<string, TransactionWithCategory[]>();

    for (const txn of transactions) {
      const dateKey = format(new Date(txn.date), 'yyyy-MM-dd');
      const existing = groups.get(dateKey) || [];
      existing.push(txn);
      groups.set(dateKey, existing);
    }

    return Array.from(groups.entries()).map(([dateKey, txns]) => ({
      date: new Date(dateKey),
      transactions: txns,
      income: txns
        .filter((t) => t.type === 1)
        .reduce((sum, t) => sum + t.amount, 0),
      expense: txns
        .filter((t) => t.type === 0)
        .reduce((sum, t) => sum + t.amount, 0),
      net: txns.reduce((sum, t) => {
        return sum + (t.type === 1 ? t.amount : -t.amount);
      }, 0),
    }));
  }, [transactions]);

  const handleEdit = (txn: TransactionWithCategory) => {
    setEditingTransaction(txn);
    setShowForm(true);
  };

  const handleDelete = async (txn: TransactionWithCategory) => {
    setDeletingTxn(txn);
  };

  const confirmDelete = async () => {
    if (deletingTxn) {
      await deleteTransaction(deletingTxn.id!);
      setDeletingTxn(null);
    }
  };

  return (
    <div className="space-y-4 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-xl font-bold text-gray-900 dark:text-white">
            Transactions
          </h1>
          <p className="text-xs text-gray-500 dark:text-gray-400">
            {transactions.length} total
          </p>
        </div>
        <div className="flex gap-2">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => navigate('/recurring')}
            className="rounded-xl"
          >
            <Repeat className="w-4 h-4" />
          </Button>
          <Button
            size="sm"
            onClick={() => {
              setEditingTransaction(undefined);
              setShowForm(true);
            }}
            className="rounded-xl"
          >
            <Plus className="w-4 h-4 mr-1" />
            Add
          </Button>
        </div>
      </div>

      {/* Summary Chips */}
      {transactions.length > 0 && (
        <div className="grid grid-cols-2 gap-2">
          <div className="p-2.5 bg-gray-50 dark:bg-gray-800 rounded-xl">
            <div className="flex items-center gap-1.5 mb-1">
              <ArrowRightLeft className="w-3 h-3 text-gray-400" />
              <span className="text-[10px] font-medium text-gray-400 uppercase tracking-wide">
                This Week
              </span>
            </div>
            <div className="flex items-center gap-3">
              <div>
                <div className="text-[10px] text-green-500">Income</div>
                <div className="text-xs font-bold text-green-600 dark:text-green-400">
                  {formatMoney(stats.weekIncome)}
                </div>
              </div>
              <div className="text-gray-300 dark:text-gray-600">/</div>
              <div>
                <div className="text-[10px] text-red-500">Expense</div>
                <div className="text-xs font-bold text-red-600 dark:text-red-400">
                  {formatMoney(stats.weekExpense)}
                </div>
              </div>
            </div>
          </div>
          <div className="p-2.5 bg-gray-50 dark:bg-gray-800 rounded-xl">
            <div className="flex items-center gap-1.5 mb-1">
              <ArrowRightLeft className="w-3 h-3 text-gray-400" />
              <span className="text-[10px] font-medium text-gray-400 uppercase tracking-wide">
                This Month
              </span>
            </div>
            <div className="flex items-center gap-3">
              <div>
                <div className="text-[10px] text-green-500">Income</div>
                <div className="text-xs font-bold text-green-600 dark:text-green-400">
                  {formatMoney(stats.monthIncome)}
                </div>
              </div>
              <div className="text-gray-300 dark:text-gray-600">/</div>
              <div>
                <div className="text-[10px] text-red-500">Expense</div>
                <div className="text-xs font-bold text-red-600 dark:text-red-400">
                  {formatMoney(stats.monthExpense)}
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Transaction List */}
      {groupedTransactions.length === 0 ? (
        <Card padding="lg">
          <EmptyState
            icon={<Receipt className="w-8 h-8" />}
            title="No transactions yet"
            description="Add your first transaction to start tracking"
            action={{
              label: 'Add Transaction',
              onClick: () => {
                setEditingTransaction(undefined);
                setShowForm(true);
              },
            }}
          />
        </Card>
      ) : (
        <div className="space-y-3">
          {groupedTransactions.map((group) => (
            <div key={group.date.toISOString()}>
              {/* Day Header */}
              <div className="flex items-center justify-between px-1 mb-1.5">
                <h3 className="text-xs font-semibold text-gray-500 dark:text-gray-400">
                  {isToday(group.date)
                    ? 'Today'
                    : isYesterday(group.date)
                    ? 'Yesterday'
                    : format(group.date, 'EEE, MMM d')}
                </h3>
                <span
                  className={`text-xs font-medium ${
                    group.net >= 0
                      ? 'text-green-600 dark:text-green-400'
                      : 'text-red-600 dark:text-red-400'
                  }`}
                >
                  {group.net >= 0 ? '+' : ''}{formatMoney(group.net)}
                </span>
              </div>

              {/* Transactions */}
              <Card padding="none" className="divide-y divide-gray-100 dark:divide-gray-700/50">
                {group.transactions.map((txn) => (
                  <TransactionTile
                    key={txn.id}
                    transaction={txn}
                    onClick={() => handleEdit(txn)}
                    onDelete={() => handleDelete(txn)}
                  />
                ))}
              </Card>
            </div>
          ))}
        </div>
      )}

      {/* Form Modal */}
      {showForm && (
        <ExpenseForm
          transaction={editingTransaction}
          onClose={() => {
            setShowForm(false);
            setEditingTransaction(undefined);
          }}
          onSave={() => {
            setShowForm(false);
            setEditingTransaction(undefined);
          }}
        />
      )}

      {/* Delete Confirmation */}
      <ConfirmDialog
        isOpen={!!deletingTxn}
        onClose={() => setDeletingTxn(null)}
        onConfirm={confirmDelete}
        title="Delete Transaction"
        message={`Are you sure you want to delete "${deletingTxn?.title}"? This action cannot be undone.`}
        confirmLabel="Delete"
      />
    </div>
  );
}

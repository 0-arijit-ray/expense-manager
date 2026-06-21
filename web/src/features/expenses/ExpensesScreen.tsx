import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTransactions, deleteTransaction } from '../../db/expense-repository';
import { formatMoney } from '../../lib/formatters';
import { Card, Button, EmptyState } from '../../components/ui';
import TransactionTile from './TransactionTile';
import ExpenseForm from './ExpenseForm';
import { Plus, Repeat, Receipt } from 'lucide-react';
import type { TransactionWithCategory } from '../../types';
import { format, isToday, isYesterday } from 'date-fns';

export default function ExpensesScreen() {
  const navigate = useNavigate();
  const transactions = useTransactions({ limit: 300 });
  const [showForm, setShowForm] = useState(false);
  const [editingTransaction, setEditingTransaction] = useState<TransactionWithCategory | undefined>();

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
    if (confirm(`Delete "${txn.title}"?`)) {
      await deleteTransaction(txn.id!);
    }
  };

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Transactions
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {transactions.length} transactions
          </p>
        </div>
        <div className="flex gap-2">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => navigate('/recurring')}
            className="rounded-xl"
          >
            <Repeat className="w-5 h-5" />
          </Button>
          <Button
            onClick={() => {
              setEditingTransaction(undefined);
              setShowForm(true);
            }}
            className="rounded-xl"
          >
            <Plus className="w-4 h-4 mr-2" />
            Add
          </Button>
        </div>
      </div>

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
        <div className="space-y-6 stagger-children">
          {groupedTransactions.map((group) => (
            <div key={group.date.toISOString()}>
              <div className="flex items-center justify-between mb-3">
                <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300">
                  {isToday(group.date)
                    ? 'Today'
                    : isYesterday(group.date)
                    ? 'Yesterday'
                    : format(group.date, 'EEEE, MMMM d')}
                </h3>
                <span
                  className={`text-sm font-medium ${
                    group.net >= 0
                      ? 'text-green-600 dark:text-green-400'
                      : 'text-red-600 dark:text-red-400'
                  }`}
                >
                  {group.net >= 0 ? '+' : ''} {formatMoney(group.net)}
                </span>
              </div>

              <Card padding="none" className="divide-y divide-gray-100 dark:divide-gray-700">
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
    </div>
  );
}

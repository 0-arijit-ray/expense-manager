import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTransactions } from '../../db/expense-repository';
import { formatMoney } from '../../lib/formatters';
import TransactionTile from './TransactionTile';
import ExpenseForm from './ExpenseForm';
import { Plus, Repeat } from 'lucide-react';
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

  return (
    <div className="p-4">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-xl font-bold text-gray-900 dark:text-white">Expenses</h1>
        <button
          onClick={() => navigate('/recurring')}
          className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        >
          <Repeat className="w-5 h-5 text-gray-600 dark:text-gray-400" />
        </button>
      </div>

      {groupedTransactions.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-12 text-center">
          <div className="w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4">
            <Plus className="w-8 h-8 text-gray-400" />
          </div>
          <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-1">
            No transactions yet
          </h3>
          <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
            Add your first transaction to get started
          </p>
          <button
            onClick={() => setShowForm(true)}
            className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            Add Transaction
          </button>
        </div>
      ) : (
        <div className="space-y-4">
          {groupedTransactions.map((group) => (
            <div key={group.date.toISOString()}>
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                  {isToday(group.date)
                    ? 'Today'
                    : isYesterday(group.date)
                    ? 'Yesterday'
                    : format(group.date, 'MMM d, yyyy')}
                </span>
                <span
                  className={`text-xs font-medium ${
                    group.net >= 0 ? 'text-green-600' : 'text-red-600'
                  }`}
                >
                  {group.net >= 0 ? '+' : ''} {formatMoney(group.net)}
                </span>
              </div>

              <div className="space-y-2">
                {group.transactions.map((txn) => (
                  <TransactionTile
                    key={txn.id}
                    transaction={txn}
                    onClick={() => handleEdit(txn)}
                  />
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      <button
        onClick={() => {
          setEditingTransaction(undefined);
          setShowForm(true);
        }}
        className="fixed bottom-24 right-4 w-14 h-14 bg-primary rounded-full shadow-lg flex items-center justify-center text-white hover:bg-primary-dark transition-colors z-40"
      >
        <Plus className="w-6 h-6" />
      </button>

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

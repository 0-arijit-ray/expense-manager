import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useRecurringRules, deleteRecurringRule, setActive } from '../../db/recurring-repository';
import { formatMoney } from '../../lib/formatters';
import { describeFrequency, TxnTypeLabels } from '../../lib/enum-labels';
import { TxnType } from '../../types';
import RecurringForm from './RecurringForm';
import { Plus, ArrowLeft } from 'lucide-react';
import { format } from 'date-fns';

export default function RecurringScreen() {
  const navigate = useNavigate();
  const rules = useRecurringRules();
  const [showForm, setShowForm] = useState(false);

  const handleDelete = async (id: number) => {
    if (confirm('Delete this recurring rule?')) {
      await deleteRecurringRule(id);
    }
  };

  const handleToggleActive = async (id: number, active: boolean) => {
    await setActive(id, !active);
  };

  return (
    <div className="p-4 pb-24">
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={() => navigate(-1)}
          className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800"
        >
          <ArrowLeft className="w-5 h-5 text-gray-600 dark:text-gray-400" />
        </button>
        <h1 className="text-xl font-bold text-gray-900 dark:text-white">Recurring</h1>
      </div>

      {rules.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-12 text-center">
          <div className="w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4">
            <Plus className="w-8 h-8 text-gray-400" />
          </div>
          <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-1">
            No recurring rules
          </h3>
          <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
            Add recurring income or expenses
          </p>
          <button
            onClick={() => setShowForm(true)}
            className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            Add Recurring
          </button>
        </div>
      ) : (
        <div className="space-y-3">
          {rules.map((rule) => (
            <div
              key={rule.id}
              className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm"
            >
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-3">
                  <div
                    className="w-10 h-10 rounded-full flex items-center justify-center text-white text-sm font-medium"
                    style={{
                      backgroundColor: rule.category
                        ? `#${rule.category.color.toString(16).slice(-6).padStart(6, '0')}`
                        : rule.type === TxnType.Expense
                        ? '#EF4444'
                        : '#10B981',
                    }}
                  >
                    {rule.category?.name?.charAt(0) || (rule.type === TxnType.Expense ? 'E' : 'I')}
                  </div>
                  <div>
                    <div className="text-sm font-semibold text-gray-900 dark:text-white">
                      {rule.title}
                    </div>
                    <div className="text-xs text-gray-500 dark:text-gray-400">
                      {describeFrequency(rule.interval, rule.frequency)}
                      {rule.category && ` • ${rule.category.name}`}
                    </div>
                  </div>
                </div>

                <label className="relative inline-flex items-center cursor-pointer">
                  <input
                    type="checkbox"
                    checked={rule.active}
                    onChange={() => handleToggleActive(rule.id!, rule.active)}
                    className="sr-only peer"
                  />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary/30 dark:peer-focus:ring-primary/30 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-primary"></div>
                </label>
              </div>

              <div className="flex items-center justify-between mt-3 pt-3 border-t border-gray-100 dark:border-gray-700">
                <div>
                  <div className="text-xs text-gray-500">Next due</div>
                  <div className="text-sm text-gray-700 dark:text-gray-300">
                    {format(new Date(rule.nextDueDate), 'MMM d, yyyy')}
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-xs text-gray-500">{TxnTypeLabels[rule.type]}</div>
                  <div className="text-sm font-semibold text-gray-900 dark:text-white">
                    {formatMoney(rule.amount)}
                  </div>
                </div>
              </div>

              <div className="flex gap-2 mt-3">
                <button
                  onClick={() => setShowForm(true)}
                  className="flex-1 py-1.5 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 rounded-lg text-xs font-medium"
                >
                  Edit
                </button>
                <button
                  onClick={() => rule.id && handleDelete(rule.id)}
                  className="py-1.5 px-3 bg-red-100 dark:bg-red-900/30 text-red-600 dark:text-red-400 rounded-lg text-xs font-medium"
                >
                  Delete
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      <button
        onClick={() => setShowForm(true)}
        className="fixed bottom-24 right-4 w-14 h-14 bg-primary rounded-full shadow-lg flex items-center justify-center text-white hover:bg-primary-dark transition-colors z-40"
      >
        <Plus className="w-6 h-6" />
      </button>

      {showForm && (
        <RecurringForm
          onClose={() => setShowForm(false)}
          onSave={() => setShowForm(false)}
        />
      )}
    </div>
  );
}

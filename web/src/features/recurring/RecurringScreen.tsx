import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useRecurringRules, deleteRecurringRule } from '../../db/recurring-repository';
import { formatMoney } from '../../lib/formatters';
import { describeFrequency } from '../../lib/enum-labels';
import { TxnType } from '../../types';
import { Card, Button, EmptyState, Badge, Tabs, ConfirmDialog } from '../../components/ui';
import CategoryIcon from '../../components/ui/CategoryIcon';
import RecurringForm from './RecurringForm';
import { Plus, Repeat, ArrowLeft, Calendar, TrendingUp, TrendingDown, Edit2, Trash2 } from 'lucide-react';
import { format, differenceInDays } from 'date-fns';
import type { RecurringRule } from '../../types';

function getMonthlyProjection(amount: number, _frequency: number, interval: number): number {
  const dailyAmount = amount / interval;
  return dailyAmount * 30;
}

export default function RecurringScreen() {
  const navigate = useNavigate();
  const rules = useRecurringRules();
  const [showForm, setShowForm] = useState(false);
  const [editingRule, setEditingRule] = useState<RecurringRule | null>(null);
  const [activeTab, setActiveTab] = useState('expense');
  const [deletingRule, setDeletingRule] = useState<RecurringRule | null>(null);

  const filteredRules = rules.filter((rule) =>
    activeTab === 'expense'
      ? rule.type === TxnType.Expense
      : rule.type === TxnType.Income
  );

  const monthlyIncome = rules
    .filter((r) => r.type === TxnType.Income && r.active)
    .reduce((sum, r) => sum + getMonthlyProjection(r.amount, r.frequency, r.interval), 0);
  const monthlyExpense = rules
    .filter((r) => r.type === TxnType.Expense && r.active)
    .reduce((sum, r) => sum + getMonthlyProjection(r.amount, r.frequency, r.interval), 0);

  const handleEdit = (rule: RecurringRule) => {
    setEditingRule(rule);
    setShowForm(true);
  };

  const handleAdd = () => {
    setEditingRule(null);
    setShowForm(true);
  };

  const handleDelete = async (rule: RecurringRule) => {
    setDeletingRule(rule);
  };

  const confirmDelete = async () => {
    if (deletingRule?.id) {
      await deleteRecurringRule(deletingRule.id);
      setDeletingRule(null);
    }
  };

  return (
    <div className="space-y-4 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => navigate(-1)}
          className="rounded-xl"
        >
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div className="flex-1">
          <h1 className="text-xl font-bold text-gray-900 dark:text-white">
            Recurring
          </h1>
          <p className="text-xs text-gray-500 dark:text-gray-400">
            {rules.length} rules
          </p>
        </div>
        <Button onClick={handleAdd} size="sm" className="rounded-xl">
          <Plus className="w-4 h-4 mr-1" />
          Add
        </Button>
      </div>

      {/* Summary Chips */}
      <div className="flex gap-2">
        <div className="flex-1 p-2.5 bg-green-50 dark:bg-green-900/20 rounded-xl">
          <div className="flex items-center gap-1.5 mb-0.5">
            <TrendingUp className="w-3.5 h-3.5 text-green-600 dark:text-green-400" />
            <span className="text-[10px] font-medium text-green-600 dark:text-green-400 uppercase tracking-wide">
              Income/mo
            </span>
          </div>
          <div className="text-sm font-bold text-green-700 dark:text-green-300">
            {formatMoney(monthlyIncome)}
          </div>
        </div>
        <div className="flex-1 p-2.5 bg-red-50 dark:bg-red-900/20 rounded-xl">
          <div className="flex items-center gap-1.5 mb-0.5">
            <TrendingDown className="w-3.5 h-3.5 text-red-600 dark:text-red-400" />
            <span className="text-[10px] font-medium text-red-600 dark:text-red-400 uppercase tracking-wide">
              Expense/mo
            </span>
          </div>
          <div className="text-sm font-bold text-red-700 dark:text-red-300">
            {formatMoney(monthlyExpense)}
          </div>
        </div>
        <div className="flex-1 p-2.5 bg-primary/10 rounded-xl">
          <div className="flex items-center gap-1.5 mb-0.5">
            <Repeat className="w-3.5 h-3.5 text-primary" />
            <span className="text-[10px] font-medium text-primary uppercase tracking-wide">
              Net/mo
            </span>
          </div>
          <div className="text-sm font-bold text-primary-dark dark:text-primary-light">
            {monthlyIncome - monthlyExpense >= 0 ? '+' : ''}
            {formatMoney(monthlyIncome - monthlyExpense)}
          </div>
        </div>
      </div>

      {/* Tabs */}
      <Tabs
        tabs={[
          { id: 'expense', label: 'Expense' },
          { id: 'income', label: 'Income' },
        ]}
        activeTab={activeTab}
        onChange={setActiveTab}
      />

      {/* Rules List */}
      {filteredRules.length === 0 ? (
        <Card padding="lg">
          <EmptyState
            icon={<Repeat className="w-8 h-8" />}
            title={
              activeTab === 'expense'
                ? 'No recurring expenses'
                : 'No recurring income'
            }
            description="Add recurring income or expenses"
            action={{
              label: 'Add Recurring',
              onClick: handleAdd,
            }}
          />
        </Card>
      ) : (
        <div className="space-y-2">
          {filteredRules.map((rule) => {
            const daysUntilDue = differenceInDays(
              new Date(rule.nextDueDate),
              new Date()
            );
            const isOverdue = daysUntilDue < 0;
            const isDueSoon = daysUntilDue >= 0 && daysUntilDue <= 3;
            const monthlyAmount = getMonthlyProjection(
              rule.amount,
              rule.frequency,
              rule.interval
            );

            return (
              <Card key={rule.id} padding="sm" className="overflow-hidden">
                <div className="flex items-center gap-3 p-3">
                  {/* Color Icon */}
                  <div
                    className="w-10 h-10 rounded-lg flex items-center justify-center shrink-0"
                    style={{
                      backgroundColor: rule.category
                        ? `#${rule.category.color
                            .toString(16)
                            .slice(-6)
                            .padStart(6, '0')}18`
                        : rule.type === TxnType.Expense
                        ? '#EF444418'
                        : '#10B98118',
                    }}
                  >
                    {rule.category ? (
                      <CategoryIcon
                        name={rule.category.name}
                        color={`#${rule.category.color
                            .toString(16)
                            .slice(-6)
                            .padStart(6, '0')}`}
                        size={18}
                      />
                    ) : (
                      <Repeat
                        size={18}
                        color={
                          rule.type === TxnType.Expense ? '#EF4444' : '#10B981'
                        }
                      />
                    )}
                  </div>

                  {/* Main Info */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <h3 className="font-semibold text-sm text-gray-900 dark:text-white truncate">
                        {rule.title}
                      </h3>
                      {!rule.active && (
                        <Badge variant="default" size="sm">Paused</Badge>
                      )}
                    </div>
                    <div className="flex items-center gap-2 mt-0.5">
                      <span className="text-xs text-gray-500 dark:text-gray-400">
                        {describeFrequency(rule.interval, rule.frequency)}
                      </span>
                      {rule.category && (
                        <>
                          <span className="text-gray-300 dark:text-gray-600">·</span>
                          <span className="text-xs text-gray-500 dark:text-gray-400">
                            {rule.category.name}
                          </span>
                        </>
                      )}
                    </div>
                  </div>

                  {/* Amount */}
                  <div className="text-right shrink-0">
                    <div className="text-sm font-bold text-gray-900 dark:text-white">
                      {formatMoney(rule.amount)}
                    </div>
                    <div className="text-[10px] text-gray-400 dark:text-gray-500">
                      ~{formatMoney(monthlyAmount)}/mo
                    </div>
                  </div>
                </div>

                {/* Bottom Row: Due Date + Actions */}
                <div className="flex items-center justify-between px-3 pb-2 pt-1 border-t border-gray-100 dark:border-gray-700/50">
                  <div className="flex items-center gap-3">
                    <div
                      className={`flex items-center gap-1 text-xs ${
                        isOverdue
                          ? 'text-red-500 font-medium'
                          : isDueSoon
                          ? 'text-amber-500 font-medium'
                          : 'text-gray-500 dark:text-gray-400'
                      }`}
                    >
                      <Calendar className="w-3 h-3" />
                      {isOverdue
                        ? `${Math.abs(daysUntilDue)}d overdue`
                        : daysUntilDue === 0
                        ? 'Due today'
                        : `Due in ${daysUntilDue}d`}
                    </div>
                    <span className="text-gray-300 dark:text-gray-600">·</span>
                    <span className="text-xs text-gray-400 dark:text-gray-500">
                      {format(new Date(rule.nextDueDate), 'MMM d')}
                    </span>
                    {rule.endDate && (
                      <>
                        <span className="text-gray-300 dark:text-gray-600">·</span>
                        <span className="text-xs text-gray-400 dark:text-gray-500">
                          Ends {format(new Date(rule.endDate), 'MMM d, yy')}
                        </span>
                      </>
                    )}
                  </div>
                  <div className="flex gap-1">
                    <button
                      onClick={() => handleEdit(rule)}
                      className="p-1.5 text-gray-400 hover:text-primary hover:bg-primary/10 rounded-lg transition-colors"
                      title="Edit"
                    >
                      <Edit2 className="w-3.5 h-3.5" />
                    </button>
                    <button
                      onClick={() => handleDelete(rule)}
                      className="p-1.5 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
                      title="Delete"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>
              </Card>
            );
          })}
        </div>
      )}

      {/* Form Modal */}
      {showForm && (
        <RecurringForm
          rule={editingRule ?? undefined}
          onClose={() => {
            setShowForm(false);
            setEditingRule(null);
          }}
          onSave={() => {
            setShowForm(false);
            setEditingRule(null);
          }}
        />
      )}

      {/* Delete Confirmation */}
      <ConfirmDialog
        isOpen={!!deletingRule}
        onClose={() => setDeletingRule(null)}
        onConfirm={confirmDelete}
        title="Delete Recurring Rule"
        message={`Are you sure you want to delete "${deletingRule?.title}"? This action cannot be undone.`}
        confirmLabel="Delete"
      />
    </div>
  );
}

import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useRecurringRules, deleteRecurringRule, setActive } from '../../db/recurring-repository';
import { formatMoney } from '../../lib/formatters';
import { describeFrequency, TxnTypeLabels } from '../../lib/enum-labels';
import { TxnType } from '../../types';
import { Card, Button, EmptyState, Toggle, Badge, Tabs } from '../../components/ui';
import RecurringForm from './RecurringForm';
import { Plus, Repeat, ArrowLeft, Calendar } from 'lucide-react';
import { format } from 'date-fns';

export default function RecurringScreen() {
  const navigate = useNavigate();
  const rules = useRecurringRules();
  const [showForm, setShowForm] = useState(false);
  const [activeTab, setActiveTab] = useState('active');

  const filteredRules = rules.filter((rule) =>
    activeTab === 'active' ? rule.active : !rule.active
  );

  const handleDelete = async (id: number) => {
    if (confirm('Delete this recurring rule?')) {
      await deleteRecurringRule(id);
    }
  };

  const handleToggleActive = async (id: number, active: boolean) => {
    await setActive(id, !active);
  };

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => navigate(-1)}
          className="rounded-xl"
        >
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div className="flex-1">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            Recurring
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {rules.length} rules
          </p>
        </div>
        <Button onClick={() => setShowForm(true)} className="rounded-xl">
          <Plus className="w-4 h-4 mr-2" />
          Add Rule
        </Button>
      </div>

      {/* Tabs */}
      <Tabs
        tabs={[
          { id: 'active', label: 'Active' },
          { id: 'inactive', label: 'Inactive' },
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
              activeTab === 'active'
                ? 'No active rules'
                : 'No inactive rules'
            }
            description="Add recurring income or expenses"
            action={{
              label: 'Add Recurring',
              onClick: () => setShowForm(true),
            }}
          />
        </Card>
      ) : (
        <div className="space-y-4 stagger-children">
          {filteredRules.map((rule) => (
            <Card key={rule.id} variant="hover" padding="lg">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div
                    className="w-12 h-12 rounded-xl flex items-center justify-center text-white text-sm font-semibold shadow-sm"
                    style={{
                      backgroundColor: rule.category
                        ? `#${rule.category.color
                            .toString(16)
                            .slice(-6)
                            .padStart(6, '0')}`
                        : rule.type === TxnType.Expense
                        ? '#EF4444'
                        : '#10B981',
                    }}
                  >
                    {rule.category?.name?.charAt(0) ||
                      (rule.type === TxnType.Expense ? 'E' : 'I')}
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {rule.title}
                    </h3>
                    <p className="text-sm text-gray-500 dark:text-gray-400">
                      {describeFrequency(rule.interval, rule.frequency)}
                      {rule.category && ` • ${rule.category.name}`}
                    </p>
                  </div>
                </div>
                <Toggle
                  checked={rule.active}
                  onChange={() => rule.id && handleToggleActive(rule.id, rule.active)}
                />
              </div>

              <div className="flex items-center justify-between mb-4 p-3 bg-gray-50 dark:bg-gray-750 rounded-xl">
                <div className="flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-gray-500 dark:text-gray-400" />
                  <span className="text-sm text-gray-700 dark:text-gray-300">
                    Next due:{' '}
                    {format(new Date(rule.nextDueDate), 'MMM d, yyyy')}
                  </span>
                </div>
                <div className="text-right">
                  <Badge
                    variant={
                      rule.type === TxnType.Income ? 'success' : 'danger'
                    }
                  >
                    {TxnTypeLabels[rule.type]}
                  </Badge>
                </div>
              </div>

              <div className="flex items-center justify-between">
                <div className="text-xl font-bold text-gray-900 dark:text-white">
                  {formatMoney(rule.amount)}
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="secondary"
                    size="sm"
                    onClick={() => setShowForm(true)}
                    className="rounded-lg"
                  >
                    Edit
                  </Button>
                  <Button
                    variant="danger"
                    size="sm"
                    onClick={() => rule.id && handleDelete(rule.id)}
                    className="rounded-lg"
                  >
                    Delete
                  </Button>
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* Form Modal */}
      {showForm && (
        <RecurringForm
          onClose={() => setShowForm(false)}
          onSave={() => setShowForm(false)}
        />
      )}
    </div>
  );
}

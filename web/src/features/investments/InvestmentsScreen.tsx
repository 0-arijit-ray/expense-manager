import { useState } from 'react';
import { useInvestments, usePortfolioSummary, deleteInvestment } from '../../db/investment-repository';
import { formatMoney, formatMoneyCompact } from '../../lib/formatters';
import { AssetTypeLabels } from '../../lib/enum-labels';
import { Card, Button, EmptyState, Badge, ConfirmDialog } from '../../components/ui';
import InvestmentForm from './InvestmentForm';
import { Plus, PiggyBank, TrendingUp, TrendingDown, Trash2, Pencil } from 'lucide-react';
import { clsx } from 'clsx';
import type { Investment } from '../../types';

export default function InvestmentsScreen() {
  const investments = useInvestments();
  const portfolio = usePortfolioSummary();
  const [showForm, setShowForm] = useState(false);
  const [selectedInvestment, setSelectedInvestment] = useState<Investment | null>(null);
  const [deletingInvestment, setDeletingInvestment] = useState<Investment | null>(null);

  const handleEdit = (inv: Investment) => {
    setSelectedInvestment(inv);
    setShowForm(true);
  };

  const handleAdd = () => {
    setSelectedInvestment(null);
    setShowForm(true);
  };

  const handleDelete = async (inv: Investment) => {
    setDeletingInvestment(inv);
  };

  const confirmDelete = async () => {
    if (deletingInvestment?.id) {
      await deleteInvestment(deletingInvestment.id);
      setDeletingInvestment(null);
    }
  };

  const handleClose = () => {
    setShowForm(false);
    setSelectedInvestment(null);
  };

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Investments</h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {investments.length} holdings
          </p>
        </div>
        <Button onClick={handleAdd} className="rounded-xl">
          <Plus className="w-4 h-4 mr-2" />
          Add Investment
        </Button>
      </div>

      {/* Portfolio Summary */}
      {investments.length > 0 && (
        <Card variant="gradient" padding="lg" className="relative overflow-hidden">
          <div className="absolute top-0 right-0 w-40 h-40 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2" />
          <div className="relative">
            <div className="flex items-center gap-2 mb-2">
              <PiggyBank className="w-5 h-5 opacity-80" />
              <span className="text-sm font-medium opacity-80">Portfolio Value</span>
            </div>
            <div className="text-3xl font-bold mb-2">
              {formatMoneyCompact(portfolio.current)}
            </div>
            <div className="flex items-center gap-4">
              <span
                className={clsx(
                  'text-sm font-medium flex items-center gap-1',
                  portfolio.gain >= 0 ? 'text-green-300' : 'text-red-300'
                )}
              >
                {portfolio.gain >= 0 ? (
                  <TrendingUp className="w-4 h-4" />
                ) : (
                  <TrendingDown className="w-4 h-4" />
                )}
                {portfolio.gain >= 0 ? '+' : ''} {formatMoney(portfolio.gain)} (
                {portfolio.gainPct.toFixed(1)}%)
              </span>
              <span className="text-sm opacity-80">
                Invested: {formatMoney(portfolio.invested)}
              </span>
            </div>
          </div>
        </Card>
      )}

      {/* Investment List */}
      {investments.length === 0 ? (
        <Card padding="lg">
          <EmptyState
            icon={<PiggyBank className="w-8 h-8" />}
            title="No investments yet"
            description="Add your first investment to track your portfolio"
            action={{
              label: 'Add Investment',
              onClick: handleAdd,
            }}
          />
        </Card>
      ) : (
        <div className="space-y-4 stagger-children">
          {investments.map((inv) => {
            const gain = inv.currentValue - inv.investedAmount;
            const gainPct =
              inv.investedAmount > 0 ? (gain / inv.investedAmount) * 100 : 0;

            return (
              <Card
                key={inv.id}
                variant="hover"
                padding="lg"
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-3 cursor-pointer flex-1" onClick={() => handleEdit(inv)}>
                    <div className="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center">
                      <PiggyBank className="w-6 h-6 text-primary" />
                    </div>
                    <div>
                      <h3 className="font-semibold text-gray-900 dark:text-white">
                        {inv.name}
                      </h3>
                      <p className="text-sm text-gray-500 dark:text-gray-400">
                        {AssetTypeLabels[inv.type]}
                        {inv.institution && ` • ${inv.institution}`}
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="text-right">
                      <div className="text-lg font-bold text-gray-900 dark:text-white">
                        {formatMoney(inv.currentValue)}
                      </div>
                      <div
                        className={clsx(
                          'text-sm font-medium flex items-center gap-1 justify-end',
                          gain >= 0
                            ? 'text-green-600 dark:text-green-400'
                            : 'text-red-600 dark:text-red-400'
                        )}
                      >
                        {gain >= 0 ? (
                          <TrendingUp className="w-4 h-4" />
                        ) : (
                          <TrendingDown className="w-4 h-4" />
                        )}
                        {gain >= 0 ? '+' : ''} {gainPct.toFixed(1)}%
                      </div>
                    </div>
                    <div className="flex flex-col gap-1">
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          handleEdit(inv);
                        }}
                        className="p-1.5 text-gray-400 hover:text-primary hover:bg-primary/10 rounded-lg transition-colors"
                        title="Edit"
                      >
                        <Pencil className="w-4 h-4" />
                      </button>
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          handleDelete(inv);
                        }}
                        className="p-1.5 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
                        title="Delete"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                </div>

                <div className="flex items-center justify-between text-sm cursor-pointer" onClick={() => handleEdit(inv)}>
                  <span className="text-gray-500 dark:text-gray-400">
                    Invested: {formatMoney(inv.investedAmount)}
                  </span>
                  {inv.annualRate && (
                    <Badge variant="info">{inv.annualRate}% p.a.</Badge>
                  )}
                </div>
              </Card>
            );
          })}
        </div>
      )}

      {/* Form Modal */}
      {showForm && (
        <InvestmentForm
          investment={selectedInvestment ?? undefined}
          onClose={handleClose}
          onSave={handleClose}
        />
      )}

      {/* Delete Confirmation */}
      <ConfirmDialog
        isOpen={!!deletingInvestment}
        onClose={() => setDeletingInvestment(null)}
        onConfirm={confirmDelete}
        title="Delete Investment"
        message={`Are you sure you want to delete "${deletingInvestment?.name}"? This action cannot be undone.`}
        confirmLabel="Delete"
      />
    </div>
  );
}

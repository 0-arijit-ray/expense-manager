import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useLoanSummaries } from '../../db/loan-repository';
import { formatMoney, formatMoneyCompact } from '../../lib/formatters';
import { LoanTypeLabels } from '../../lib/enum-labels';
import { Card, Button, EmptyState, Badge } from '../../components/ui';
import LoanForm from './LoanForm';
import { Plus, Landmark, ChevronRight, ArrowDownRight } from 'lucide-react';

export default function LoansScreen() {
  const navigate = useNavigate();
  const loanSummaries = useLoanSummaries();
  const [showForm, setShowForm] = useState(false);

  const totalOutstanding = loanSummaries.reduce((sum, s) => sum + s.outstanding, 0);
  const totalMonthlyEmi = loanSummaries.reduce((sum, s) => sum + s.loan.emiAmount, 0);

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Loans</h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {loanSummaries.length} active loans
          </p>
        </div>
        <Button onClick={() => setShowForm(true)} className="rounded-xl">
          <Plus className="w-4 h-4 mr-2" />
          Add Loan
        </Button>
      </div>

      {/* Summary Card */}
      {loanSummaries.length > 0 && (
        <Card variant="gradient" padding="lg" className="relative overflow-hidden">
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2" />
          <div className="relative">
            <div className="flex items-center gap-2 mb-2">
              <Landmark className="w-5 h-5 opacity-80" />
              <span className="text-sm font-medium opacity-80">Total Outstanding</span>
            </div>
            <div className="text-3xl font-bold mb-4">
              {formatMoneyCompact(totalOutstanding)}
            </div>
            <div className="flex items-center gap-2 text-sm opacity-80">
              <ArrowDownRight className="w-4 h-4" />
              <span>Monthly EMI: {formatMoney(totalMonthlyEmi)}</span>
            </div>
          </div>
        </Card>
      )}

      {/* Loan List */}
      {loanSummaries.length === 0 ? (
        <Card padding="lg">
          <EmptyState
            icon={<Landmark className="w-8 h-8" />}
            title="No loans yet"
            description="Add your first loan to track EMIs"
            action={{
              label: 'Add Loan',
              onClick: () => setShowForm(true),
            }}
          />
        </Card>
      ) : (
        <div className="space-y-4 stagger-children">
          {loanSummaries.map((summary) => (
            <Card
              key={summary.loan.id}
              variant="hover"
              padding="lg"
              onClick={() => navigate(`/loans/${summary.loan.id}`)}
            >
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-primary/10 rounded-xl flex items-center justify-center">
                    <Landmark className="w-6 h-6 text-primary" />
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900 dark:text-white">
                      {summary.loan.name}
                    </h3>
                    <p className="text-sm text-gray-500 dark:text-gray-400">
                      {LoanTypeLabels[summary.loan.type]}
                      {summary.loan.lender && ` • ${summary.loan.lender}`}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  {summary.loan.closed && (
                    <Badge variant="success">Closed</Badge>
                  )}
                  <ChevronRight className="w-5 h-5 text-gray-400 dark:text-gray-500" />
                </div>
              </div>

              <div className="mb-4">
                <div className="flex items-center justify-between text-sm mb-2">
                  <span className="text-gray-500 dark:text-gray-400">
                    Progress
                  </span>
                  <span className="font-medium text-gray-700 dark:text-gray-300">
                    {summary.paidCount}/{summary.totalCount} EMIs
                  </span>
                </div>
                <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                  <div
                    className="bg-gradient-to-r from-primary to-primary-light h-2 rounded-full transition-all duration-500"
                    style={{ width: `${summary.progress * 100}%` }}
                  />
                </div>
              </div>

              <div className="grid grid-cols-3 gap-4">
                <div>
                  <div className="text-xs text-gray-500 dark:text-gray-400">EMI</div>
                  <div className="text-sm font-semibold text-gray-900 dark:text-white">
                    {formatMoney(summary.loan.emiAmount)}
                  </div>
                </div>
                <div>
                  <div className="text-xs text-gray-500 dark:text-gray-400">Outstanding</div>
                  <div className="text-sm font-semibold text-red-600 dark:text-red-400">
                    {formatMoney(summary.outstanding)}
                  </div>
                </div>
                <div>
                  <div className="text-xs text-gray-500 dark:text-gray-400">Next Due</div>
                  <div className="text-sm font-semibold text-gray-900 dark:text-white">
                    {summary.nextDue
                      ? new Date(summary.nextDue.dueDate).toLocaleDateString('en', {
                          month: 'short',
                          day: 'numeric',
                        })
                      : 'N/A'}
                  </div>
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* Form Modal */}
      {showForm && (
        <LoanForm
          onClose={() => setShowForm(false)}
          onSave={() => setShowForm(false)}
        />
      )}
    </div>
  );
}

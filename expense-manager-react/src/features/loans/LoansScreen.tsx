import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useLoanSummaries } from '../../db/loan-repository';
import { formatMoney } from '../../lib/formatters';
import { LoanTypeLabels } from '../../lib/enum-labels';
import LoanForm from './LoanForm';
import { Plus, Landmark, ChevronRight } from 'lucide-react';

export default function LoansScreen() {
  const navigate = useNavigate();
  const loanSummaries = useLoanSummaries();
  const [showForm, setShowForm] = useState(false);

  const totalOutstanding = loanSummaries.reduce((sum, s) => sum + s.outstanding, 0);
  const totalMonthlyEmi = loanSummaries.reduce((sum, s) => sum + s.loan.emiAmount, 0);

  return (
    <div className="p-4">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-xl font-bold text-gray-900 dark:text-white">Loans</h1>
      </div>

      {loanSummaries.length > 0 && (
        <div className="bg-gradient-to-br from-red-500 to-red-600 rounded-2xl p-4 mb-4 text-white">
          <div className="flex items-center gap-2 mb-2">
            <Landmark className="w-4 h-4 opacity-80" />
            <span className="text-sm opacity-80">Total Outstanding</span>
          </div>
          <div className="text-2xl font-bold mb-2">{formatMoney(totalOutstanding)}</div>
          <div className="text-sm opacity-80">
            Monthly EMI: {formatMoney(totalMonthlyEmi)}
          </div>
        </div>
      )}

      {loanSummaries.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-12 text-center">
          <div className="w-16 h-16 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-4">
            <Plus className="w-8 h-8 text-gray-400" />
          </div>
          <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-1">
            No loans yet
          </h3>
          <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
            Add your first loan to track EMIs
          </p>
          <button
            onClick={() => setShowForm(true)}
            className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-primary-dark transition-colors"
          >
            Add Loan
          </button>
        </div>
      ) : (
        <div className="space-y-3">
          {loanSummaries.map((summary) => (
            <div
              key={summary.loan.id}
              onClick={() => navigate(`/loans/${summary.loan.id}`)}
              className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors cursor-pointer"
            >
              <div className="flex items-start justify-between mb-3">
                <div>
                  <div className="flex items-center gap-2">
                    <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
                      <Landmark className="w-5 h-5 text-primary" />
                    </div>
                    <div>
                      <div className="text-sm font-semibold text-gray-900 dark:text-white">
                        {summary.loan.name}
                      </div>
                      <div className="text-xs text-gray-500 dark:text-gray-400">
                        {LoanTypeLabels[summary.loan.type]}
                        {summary.loan.lender && ` • ${summary.loan.lender}`}
                      </div>
                    </div>
                  </div>
                </div>
                <ChevronRight className="w-5 h-5 text-gray-400" />
              </div>

              <div className="flex items-center justify-between mb-2">
                <span className="text-xs text-gray-500">
                  {summary.paidCount}/{summary.totalCount} paid
                </span>
                <span className="text-xs text-gray-500">
                  Next: {summary.nextDue ? new Date(summary.nextDue.dueDate).toLocaleDateString() : 'N/A'}
                </span>
              </div>

              <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2 mb-3">
                <div
                  className="bg-primary h-2 rounded-full transition-all"
                  style={{ width: `${summary.progress * 100}%` }}
                />
              </div>

              <div className="flex items-center justify-between">
                <div>
                  <div className="text-xs text-gray-500">EMI</div>
                  <div className="text-sm font-semibold text-gray-900 dark:text-white">
                    {formatMoney(summary.loan.emiAmount)}
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-xs text-gray-500">Outstanding</div>
                  <div className="text-sm font-semibold text-red-600 dark:text-red-400">
                    {formatMoney(summary.outstanding)}
                  </div>
                </div>
              </div>

              {summary.loan.closed && (
                <div className="mt-2 inline-block px-2 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 text-xs rounded-full">
                  Closed
                </div>
              )}
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
        <LoanForm
          onClose={() => setShowForm(false)}
          onSave={() => setShowForm(false)}
        />
      )}
    </div>
  );
}

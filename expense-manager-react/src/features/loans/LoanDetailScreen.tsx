import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getLoan, useLoanSchedule, markEmiPaid, markEmiUnpaid, deleteLoan, setClosed } from '../../db/loan-repository';
import { formatMoney } from '../../lib/formatters';
import { LoanTypeLabels } from '../../lib/enum-labels';
import { ArrowLeft, Trash2, CheckCircle, Undo2 } from 'lucide-react';
import type { Loan } from '../../types';
import { format } from 'date-fns';

export default function LoanDetailScreen() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const schedule = useLoanSchedule(parseInt(id || '0'));
  const [loan, setLoan] = useState<Loan | undefined>();

  useEffect(() => {
    if (id) {
      getLoan(parseInt(id)).then(setLoan);
    }
  }, [id]);

  if (!loan) {
    return (
      <div className="p-4">
        <div className="animate-pulse space-y-4">
          <div className="h-8 bg-gray-200 dark:bg-gray-700 rounded w-1/3" />
          <div className="h-32 bg-gray-200 dark:bg-gray-700 rounded" />
        </div>
      </div>
    );
  }

  const paidCount = schedule.filter((s) => s.paid).length;
  const totalCount = schedule.length;
  const outstanding = schedule.filter((s) => !s.paid).reduce((sum, s) => sum + s.emiAmount, 0);
  const totalInterest = schedule.reduce((sum, s) => sum + s.interestComponent, 0);
  const totalPayable = outstanding + schedule.filter((s) => s.paid).reduce((sum, s) => sum + s.emiAmount, 0);

  const handleMarkPaid = async (emiId: number) => {
    const emi = schedule.find((s) => s.id === emiId);
    if (emi && loan) {
      await markEmiPaid(emi, loan);
    }
  };

  const handleMarkUnpaid = async (emiId: number) => {
    const emi = schedule.find((s) => s.id === emiId);
    if (emi) {
      await markEmiUnpaid(emi);
    }
  };

  const handleDelete = async () => {
    if (confirm('Delete this loan and all its EMIs?')) {
      await deleteLoan(loan.id!);
      navigate('/loans');
    }
  };

  const handleToggleClosed = async () => {
    await setClosed(loan.id!, !loan.closed);
    setLoan({ ...loan, closed: !loan.closed });
  };

  return (
    <div className="p-4 pb-24">
      <div className="flex items-center gap-3 mb-4">
        <button
          onClick={() => navigate('/loans')}
          className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800"
        >
          <ArrowLeft className="w-5 h-5 text-gray-600 dark:text-gray-400" />
        </button>
        <h1 className="text-xl font-bold text-gray-900 dark:text-white">{loan.name}</h1>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm mb-4">
        <div className="text-sm text-gray-500 dark:text-gray-400 mb-1">
          {LoanTypeLabels[loan.type]}
          {loan.lender && ` • ${loan.lender}`}
        </div>

        <div className="grid grid-cols-2 gap-4 mt-4">
          <div>
            <div className="text-xs text-gray-500">Principal</div>
            <div className="text-lg font-bold text-gray-900 dark:text-white">
              {formatMoney(loan.principal)}
            </div>
          </div>
          <div>
            <div className="text-xs text-gray-500">EMI</div>
            <div className="text-lg font-bold text-primary">{formatMoney(loan.emiAmount)}</div>
          </div>
          <div>
            <div className="text-xs text-gray-500">Total Interest</div>
            <div className="text-lg font-bold text-orange-600">{formatMoney(totalInterest)}</div>
          </div>
          <div>
            <div className="text-xs text-gray-500">Total Payable</div>
            <div className="text-lg font-bold text-gray-900 dark:text-white">
              {formatMoney(totalPayable)}
            </div>
          </div>
        </div>

        <div className="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
          <div className="flex items-center justify-between mb-2">
            <span className="text-xs text-gray-500">Progress</span>
            <span className="text-xs text-gray-500">
              {paidCount}/{totalCount} EMIs
            </span>
          </div>
          <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
            <div
              className="bg-primary h-2 rounded-full transition-all"
              style={{ width: `${totalCount > 0 ? (paidCount / totalCount) * 100 : 0}%` }}
            />
          </div>
        </div>
      </div>

      <div className="flex gap-2 mb-4">
        <button
          onClick={handleToggleClosed}
          className={`flex-1 py-2 px-4 rounded-lg text-sm font-medium transition-colors ${
            loan.closed
              ? 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400'
              : 'bg-gray-100 text-gray-700 dark:bg-gray-700 dark:text-gray-300'
          }`}
        >
          {loan.closed ? 'Mark as Open' : 'Mark as Closed'}
        </button>
        <button
          onClick={handleDelete}
          className="py-2 px-4 bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400 rounded-lg text-sm font-medium"
        >
          <Trash2 className="w-4 h-4" />
        </button>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-sm">
        <div className="p-4 border-b border-gray-200 dark:border-gray-700">
          <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300">
            Amortization Schedule
          </h3>
        </div>
        <div className="divide-y divide-gray-100 dark:divide-gray-700">
          {schedule.map((emi) => (
            <div key={emi.id} className="p-4">
              <div className="flex items-center justify-between mb-2">
                <div>
                  <div className="text-sm font-medium text-gray-900 dark:text-white">
                    Installment #{emi.installmentNo}
                  </div>
                  <div className="text-xs text-gray-500">
                    Due: {format(new Date(emi.dueDate), 'MMM d, yyyy')}
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-sm font-semibold text-gray-900 dark:text-white">
                    {formatMoney(emi.emiAmount)}
                  </div>
                  {emi.paid ? (
                    <div className="text-xs text-green-600 dark:text-green-400">
                      Paid {emi.paidDate ? format(new Date(emi.paidDate), 'MMM d') : ''}
                    </div>
                  ) : (
                    <div className="text-xs text-gray-500">
                      Balance: {formatMoney(emi.balance)}
                    </div>
                  )}
                </div>
              </div>

              <div className="flex items-center justify-between text-xs text-gray-500 mb-2">
                <span>Principal: {formatMoney(emi.principalComponent)}</span>
                <span>Interest: {formatMoney(emi.interestComponent)}</span>
              </div>

              {emi.paid ? (
                <button
                  onClick={() => emi.id && handleMarkUnpaid(emi.id)}
                  className="w-full py-1.5 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 rounded-lg text-xs font-medium flex items-center justify-center gap-1"
                >
                  <Undo2 className="w-3 h-3" />
                  Undo
                </button>
              ) : (
                <button
                  onClick={() => emi.id && handleMarkPaid(emi.id)}
                  className="w-full py-1.5 bg-primary text-white rounded-lg text-xs font-medium flex items-center justify-center gap-1"
                >
                  <CheckCircle className="w-3 h-3" />
                  Mark Paid
                </button>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

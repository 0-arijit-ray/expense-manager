import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  getLoan,
  useLoanSchedule,
  markEmiPaid,
  markEmiUnpaid,
  deleteLoan,
  setClosed,
} from '../../db/loan-repository';
import { formatMoney } from '../../lib/formatters';
import { LoanTypeLabels } from '../../lib/enum-labels';
import { Card, Button, Badge, ConfirmDialog } from '../../components/ui';
import {
  ArrowLeft,
  Trash2,
  CheckCircle,
  Undo2,
  Calendar,
  Percent,
  ChevronDown,
  ChevronUp,
  TrendingDown,
  AlertCircle,
} from 'lucide-react';
import type { Loan } from '../../types';
import { format, differenceInDays } from 'date-fns';

export default function LoanDetailScreen() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const schedule = useLoanSchedule(parseInt(id || '0'));
  const [loan, setLoan] = useState<Loan | undefined>();
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [showCloseConfirm, setShowCloseConfirm] = useState(false);
  const [showAmortization, setShowAmortization] = useState(false);

  useEffect(() => {
    if (id) {
      getLoan(parseInt(id)).then(setLoan);
    }
  }, [id]);

  if (!loan) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-8 bg-gray-200 dark:bg-gray-700 rounded-xl w-1/3" />
        <div className="h-48 bg-gray-200 dark:bg-gray-700 rounded-2xl" />
        <div className="h-32 bg-gray-200 dark:bg-gray-700 rounded-2xl" />
      </div>
    );
  }

  const paidCount = schedule.filter((s) => s.paid).length;
  const totalCount = schedule.length;
  const outstanding = schedule
    .filter((s) => !s.paid)
    .reduce((sum, s) => sum + s.emiAmount, 0);
  const totalInterest = schedule.reduce((sum, s) => sum + s.interestComponent, 0);
  const totalPayable = loan.principal + totalInterest;
  const nextEmi = schedule.find((s) => !s.paid);
  const nextDueDays = nextEmi
    ? differenceInDays(new Date(nextEmi.dueDate), new Date())
    : null;

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

  const confirmDelete = async () => {
    await deleteLoan(loan.id!);
    navigate('/loans');
  };

  const handleToggleClosed = async () => {
    if (!loan.closed) {
      setShowCloseConfirm(true);
    } else {
      await setClosed(loan.id!, false);
      setLoan({ ...loan, closed: false });
    }
  };

  const confirmClose = async () => {
    if (loan) {
      await setClosed(loan.id!, true);
      setLoan({ ...loan, closed: true });
    }
  };

  const paidEmis = schedule.filter((s) => s.paid);
  const unpaidEmis = schedule.filter((s) => !s.paid);

  return (
    <div className="space-y-6 animate-fadeIn">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => navigate('/loans')}
          className="rounded-xl"
        >
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            <h1 className="text-xl sm:text-2xl font-bold text-gray-900 dark:text-white truncate">
              {loan.name}
            </h1>
            {loan.closed && <Badge variant="success">Closed</Badge>}
          </div>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-0.5">
            {LoanTypeLabels[loan.type]}
            {loan.lender && ` • ${loan.lender}`}
          </p>
        </div>
        <Button
          variant={loan.closed ? 'primary' : 'outline'}
          size="sm"
          onClick={handleToggleClosed}
          className="rounded-xl shrink-0"
        >
          {loan.closed ? 'Reopen' : 'Close'}
        </Button>
      </div>

      {/* Summary Hero */}
      <Card padding="none" className="overflow-hidden">
        <div className="relative bg-gradient-to-br from-primary via-emerald-600 to-teal-500 p-4 sm:p-6 lg:p-8 text-white overflow-hidden">
          <div className="absolute top-0 right-0 w-48 h-48 bg-white/5 rounded-full -translate-y-1/3 translate-x-1/3" />
          <div className="absolute bottom-0 left-1/4 w-32 h-32 bg-white/5 rounded-full translate-y-1/2 blur-xl" />

          <div className="relative min-w-0 overflow-hidden">
            {/* Main amount */}
            <p className="text-xs sm:text-sm opacity-80 mb-1">Outstanding</p>
            <p className="text-xl sm:text-3xl lg:text-4xl font-bold tracking-tight truncate">{formatMoney(outstanding)}</p>

            {/* Progress bar */}
            <div className="mt-4 sm:mt-5">
              <div className="flex items-center justify-between text-xs sm:text-sm mb-1.5 sm:mb-2">
                <span className="opacity-80">{paidCount} of {totalCount} EMIs paid</span>
                <span className="font-medium">{totalCount > 0 ? Math.round((paidCount / totalCount) * 100) : 0}%</span>
              </div>
              <div className="w-full bg-white/20 rounded-full h-2 sm:h-2.5">
                <div
                  className="bg-white h-2 sm:h-2.5 rounded-full transition-all duration-700"
                  style={{ width: `${totalCount > 0 ? (paidCount / totalCount) * 100 : 0}%` }}
                />
              </div>
            </div>

            {/* Key metrics row */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 sm:gap-4 mt-4 sm:mt-6 pt-4 sm:pt-5 border-t border-white/20">
              <div>
                <p className="text-[10px] sm:text-xs opacity-70 mb-0.5">Principal</p>
                <p className="text-xs sm:text-sm lg:text-base font-semibold">{formatMoney(loan.principal)}</p>
              </div>
              <div>
                <p className="text-[10px] sm:text-xs opacity-70 mb-0.5">Monthly EMI</p>
                <p className="text-xs sm:text-sm lg:text-base font-semibold">{formatMoney(loan.emiAmount)}</p>
              </div>
              <div>
                <p className="text-[10px] sm:text-xs opacity-70 mb-0.5">Total Interest</p>
                <p className="text-xs sm:text-sm lg:text-base font-semibold">{formatMoney(totalInterest)}</p>
              </div>
              <div>
                <p className="text-[10px] sm:text-xs opacity-70 mb-0.5">Total Payable</p>
                <p className="text-xs sm:text-sm lg:text-base font-semibold">{formatMoney(totalPayable)}</p>
              </div>
            </div>
          </div>
        </div>
      </Card>

      {/* Next EMI Due */}
      {nextEmi && !loan.closed && (
        <Card padding="lg">
          <div className="flex flex-col sm:flex-row sm:items-center gap-4">
            <div className="flex items-center gap-3 flex-1 min-w-0">
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 ${
                nextDueDays !== null && nextDueDays <= 3
                  ? 'bg-red-100 dark:bg-red-900/30'
                  : 'bg-amber-100 dark:bg-amber-900/30'
              }`}>
                {nextDueDays !== null && nextDueDays <= 3 ? (
                  <AlertCircle className="w-5 h-5 text-red-600 dark:text-red-400" />
                ) : (
                  <Calendar className="w-5 h-5 text-amber-600 dark:text-amber-400" />
                )}
              </div>
              <div className="min-w-0">
                <p className="text-sm text-gray-500 dark:text-gray-400">
                  Next EMI — #{nextEmi.installmentNo}
                </p>
                <p className="font-semibold text-gray-900 dark:text-white">
                  {formatMoney(nextEmi.emiAmount)}
                  <span className="text-sm font-normal text-gray-500 dark:text-gray-400 ml-2">
                    due {format(new Date(nextEmi.dueDate), 'MMM d, yyyy')}
                  </span>
                </p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              {nextDueDays !== null && (
                <Badge variant={nextDueDays <= 3 ? 'danger' : 'warning'} size="sm">
                  {nextDueDays <= 0 ? 'Overdue' : `${nextDueDays}d left`}
                </Badge>
              )}
              <Button
                size="sm"
                onClick={() => nextEmi.id && handleMarkPaid(nextEmi.id)}
                className="rounded-xl"
              >
                <CheckCircle className="w-4 h-4 mr-1.5" />
                Mark Paid
              </Button>
            </div>
          </div>
          <div className="flex items-center gap-4 mt-4 pt-4 border-t border-gray-100 dark:border-gray-700">
            <div className="flex items-center gap-1.5 text-sm text-gray-500 dark:text-gray-400">
              <TrendingDown className="w-3.5 h-3.5" />
              <span>Principal: {formatMoney(nextEmi.principalComponent)}</span>
            </div>
            <div className="flex items-center gap-1.5 text-sm text-gray-500 dark:text-gray-400">
              <Percent className="w-3.5 h-3.5" />
              <span>Interest: {formatMoney(nextEmi.interestComponent)}</span>
            </div>
          </div>
        </Card>
      )}

      {/* Closed loan summary */}
      {loan.closed && (
        <Card padding="lg">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-emerald-100 dark:bg-emerald-900/30 rounded-xl flex items-center justify-center">
              <CheckCircle className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
            </div>
            <div>
              <p className="font-medium text-gray-900 dark:text-white">Loan Closed</p>
              <p className="text-sm text-gray-500 dark:text-gray-400">
                All {totalCount} EMIs have been paid
              </p>
            </div>
          </div>
        </Card>
      )}

      {/* Quick Stats */}
      <div className="grid grid-cols-3 gap-2 sm:gap-3">
        <Card padding="sm" className="text-center overflow-hidden">
          <p className="text-[10px] sm:text-xs text-gray-500 dark:text-gray-400 mb-1">Paid</p>
          <p className="text-sm sm:text-lg font-bold text-emerald-600 dark:text-emerald-400">{paidCount}</p>
        </Card>
        <Card padding="sm" className="text-center overflow-hidden">
          <p className="text-[10px] sm:text-xs text-gray-500 dark:text-gray-400 mb-1">Remaining</p>
          <p className="text-sm sm:text-lg font-bold text-amber-600 dark:text-amber-400">{totalCount - paidCount}</p>
        </Card>
        <Card padding="sm" className="text-center overflow-hidden">
          <p className="text-[10px] sm:text-xs text-gray-500 dark:text-gray-400 mb-1">Outstanding</p>
          <p className="text-xs sm:text-lg font-bold text-red-600 dark:text-red-400 truncate">{formatMoney(outstanding)}</p>
        </Card>
      </div>

      {/* Amortization Schedule - On Demand */}
      <Card padding="none">
        <button
          onClick={() => setShowAmortization(!showAmortization)}
          className="w-full flex items-center justify-between p-4 lg:p-5 text-left hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors rounded-2xl"
        >
          <div>
            <h3 className="text-base font-semibold text-gray-900 dark:text-white">
              Amortization Schedule
            </h3>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-0.5">
              {paidEmis.length} paid, {unpaidEmis.length} remaining
            </p>
          </div>
          {showAmortization ? (
            <ChevronUp className="w-5 h-5 text-gray-400" />
          ) : (
            <ChevronDown className="w-5 h-5 text-gray-400" />
          )}
        </button>

        {showAmortization && (
          <div className="px-4 lg:px-5 pb-4 lg:pb-5 space-y-2">
            {schedule.map((emi) => (
              <div
                key={emi.id}
                className={`p-3 rounded-xl transition-colors ${
                  emi.paid
                    ? 'bg-emerald-50 dark:bg-emerald-900/10'
                    : 'bg-gray-50 dark:bg-gray-750 hover:bg-gray-100 dark:hover:bg-gray-700'
                }`}
              >
                <div className="flex items-center justify-between gap-3">
                  <div className="flex items-center gap-3 min-w-0">
                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center text-xs font-bold shrink-0 ${
                      emi.paid
                        ? 'bg-emerald-200 dark:bg-emerald-800 text-emerald-700 dark:text-emerald-300'
                        : 'bg-gray-200 dark:bg-gray-700 text-gray-600 dark:text-gray-400'
                    }`}>
                      {emi.installmentNo}
                    </div>
                    <div className="min-w-0">
                      <p className="text-sm font-medium text-gray-900 dark:text-white truncate">
                        {format(new Date(emi.dueDate), 'MMM d, yyyy')}
                      </p>
                      <p className="text-xs text-gray-500 dark:text-gray-400">
                        P: {formatMoney(emi.principalComponent)} • I: {formatMoney(emi.interestComponent)}
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-2 shrink-0">
                    <div className="text-right">
                      <p className="text-sm font-semibold text-gray-900 dark:text-white">
                        {formatMoney(emi.emiAmount)}
                      </p>
                      {emi.paid ? (
                        <p className="text-xs text-emerald-600 dark:text-emerald-400">
                          {emi.paidDate ? format(new Date(emi.paidDate), 'MMM d') : 'Paid'}
                        </p>
                      ) : (
                        <p className="text-xs text-gray-500 dark:text-gray-400">
                          Bal: {formatMoney(emi.balance)}
                        </p>
                      )}
                    </div>
                    {emi.paid ? (
                      <button
                        onClick={() => emi.id && handleMarkUnpaid(emi.id)}
                        className="p-1.5 rounded-lg text-gray-400 hover:text-amber-600 hover:bg-amber-50 dark:hover:bg-amber-900/20 transition-colors"
                        title="Undo payment"
                      >
                        <Undo2 className="w-4 h-4" />
                      </button>
                    ) : (
                      <button
                        onClick={() => emi.id && handleMarkPaid(emi.id)}
                        className="p-1.5 rounded-lg text-primary hover:bg-primary/10 transition-colors"
                        title="Mark as paid"
                      >
                        <CheckCircle className="w-4 h-4" />
                      </button>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </Card>

      {/* Delete */}
      {!loan.closed && (
        <div className="pb-4">
          <Button
            variant="ghost"
            onClick={() => setShowDeleteConfirm(true)}
            className="w-full text-red-500 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-xl"
          >
            <Trash2 className="w-4 h-4 mr-2" />
            Delete Loan
          </Button>
        </div>
      )}

      {/* Close Confirmation */}
      <ConfirmDialog
        isOpen={showCloseConfirm}
        onClose={() => setShowCloseConfirm(false)}
        onConfirm={confirmClose}
        title="Close Loan"
        message={`Are you sure you want to close "${loan.name}"? You can reopen it later if needed.`}
        confirmLabel="Close Loan"
      />

      {/* Delete Confirmation */}
      <ConfirmDialog
        isOpen={showDeleteConfirm}
        onClose={() => setShowDeleteConfirm(false)}
        onConfirm={confirmDelete}
        title="Delete Loan"
        message={`Are you sure you want to delete "${loan.name}" and all its EMIs? This action cannot be undone.`}
        confirmLabel="Delete"
      />
    </div>
  );
}

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
import { Card, Button, Badge } from '../../components/ui';
import {
  ArrowLeft,
  Trash2,
  CheckCircle,
  Undo2,
  Landmark,
  Calendar,
  Percent,
  Clock,
} from 'lucide-react';
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
      <div className="space-y-4 animate-pulse">
        <div className="h-8 bg-gray-200 dark:bg-gray-700 rounded-xl w-1/3" />
        <div className="h-48 bg-gray-200 dark:bg-gray-700 rounded-2xl" />
      </div>
    );
  }

  const paidCount = schedule.filter((s) => s.paid).length;
  const totalCount = schedule.length;
  const outstanding = schedule
    .filter((s) => !s.paid)
    .reduce((sum, s) => sum + s.emiAmount, 0);
  const totalInterest = schedule.reduce((sum, s) => sum + s.interestComponent, 0);

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
        <div className="flex-1">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            {loan.name}
          </h1>
          <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
            {LoanTypeLabels[loan.type]}
            {loan.lender && ` • ${loan.lender}`}
          </p>
        </div>
        {loan.closed && <Badge variant="success">Closed</Badge>}
      </div>

      {/* Loan Summary */}
      <Card variant="gradient" padding="lg" className="relative overflow-hidden">
        <div className="absolute top-0 right-0 w-32 h-32 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2" />
        <div className="relative">
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-6">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <Landmark className="w-4 h-4 opacity-80" />
                <span className="text-xs opacity-80">Principal</span>
              </div>
              <div className="text-xl font-bold">{formatMoney(loan.principal)}</div>
            </div>
            <div>
              <div className="flex items-center gap-2 mb-1">
                <Calendar className="w-4 h-4 opacity-80" />
                <span className="text-xs opacity-80">EMI</span>
              </div>
              <div className="text-xl font-bold">{formatMoney(loan.emiAmount)}</div>
            </div>
            <div>
              <div className="flex items-center gap-2 mb-1">
                <Percent className="w-4 h-4 opacity-80" />
                <span className="text-xs opacity-80">Total Interest</span>
              </div>
              <div className="text-xl font-bold">{formatMoney(totalInterest)}</div>
            </div>
            <div>
              <div className="flex items-center gap-2 mb-1">
                <Clock className="w-4 h-4 opacity-80" />
                <span className="text-xs opacity-80">Outstanding</span>
              </div>
              <div className="text-xl font-bold">{formatMoney(outstanding)}</div>
            </div>
          </div>

          <div className="mt-6 pt-4 border-t border-white/20">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm opacity-80">Progress</span>
              <span className="text-sm font-medium">
                {paidCount}/{totalCount} EMIs
              </span>
            </div>
            <div className="w-full bg-white/20 rounded-full h-2">
              <div
                className="bg-white h-2 rounded-full transition-all duration-500"
                style={{ width: `${totalCount > 0 ? (paidCount / totalCount) * 100 : 0}%` }}
              />
            </div>
          </div>
        </div>
      </Card>

      {/* Actions */}
      <div className="flex gap-3">
        <Button
          variant={loan.closed ? 'primary' : 'secondary'}
          onClick={handleToggleClosed}
          className="flex-1 rounded-xl"
        >
          {loan.closed ? 'Mark as Open' : 'Mark as Closed'}
        </Button>
        <Button variant="danger" onClick={handleDelete} className="rounded-xl">
          <Trash2 className="w-4 h-4" />
        </Button>
      </div>

      {/* Amortization Schedule */}
      <Card padding="lg">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Amortization Schedule
        </h3>
        <div className="space-y-3">
          {schedule.map((emi) => (
            <div
              key={emi.id}
              className="p-4 rounded-xl bg-gray-50 dark:bg-gray-750 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            >
              <div className="flex items-center justify-between mb-3">
                <div>
                  <div className="font-medium text-gray-900 dark:text-white">
                    Installment #{emi.installmentNo}
                  </div>
                  <div className="text-sm text-gray-500 dark:text-gray-400">
                    Due: {format(new Date(emi.dueDate), 'MMM d, yyyy')}
                  </div>
                </div>
                <div className="text-right">
                  <div className="font-semibold text-gray-900 dark:text-white">
                    {formatMoney(emi.emiAmount)}
                  </div>
                  {emi.paid ? (
                    <Badge variant="success" size="sm">
                      Paid {emi.paidDate ? format(new Date(emi.paidDate), 'MMM d') : ''}
                    </Badge>
                  ) : (
                    <div className="text-sm text-gray-500 dark:text-gray-400">
                      Balance: {formatMoney(emi.balance)}
                    </div>
                  )}
                </div>
              </div>

              <div className="flex items-center justify-between text-sm text-gray-500 dark:text-gray-400 mb-3">
                <span>Principal: {formatMoney(emi.principalComponent)}</span>
                <span>Interest: {formatMoney(emi.interestComponent)}</span>
              </div>

              {emi.paid ? (
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => emi.id && handleMarkUnpaid(emi.id)}
                  className="w-full rounded-lg"
                >
                  <Undo2 className="w-4 h-4 mr-2" />
                  Undo Payment
                </Button>
              ) : (
                <Button
                  size="sm"
                  onClick={() => emi.id && handleMarkPaid(emi.id)}
                  className="w-full rounded-lg"
                >
                  <CheckCircle className="w-4 h-4 mr-2" />
                  Mark as Paid
                </Button>
              )}
            </div>
          ))}
        </div>
      </Card>
    </div>
  );
}

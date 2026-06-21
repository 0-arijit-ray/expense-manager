import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import type { Loan } from '../../types';
import { LoanType } from '../../types';
import { LoanTypeLabels } from '../../lib/enum-labels';
import { emi as calculateEmi } from '../../lib/finance-math';
import { formatMoney } from '../../lib/formatters';
import { createLoan } from '../../db/loan-repository';
import Modal from '../../components/ui/Modal';
import { Calculator } from 'lucide-react';
import { format } from 'date-fns';

const schema = z.object({
  type: z.nativeEnum(LoanType),
  name: z.string().min(1, 'Name is required'),
  lender: z.string().optional(),
  principal: z.string().refine((val) => {
    const num = parseFloat(val.replace(/,/g, ''));
    return !isNaN(num) && num > 0;
  }, 'Principal must be greater than 0'),
  annualRate: z.string().refine((val) => {
    const num = parseFloat(val);
    return !isNaN(num) && num >= 0;
  }, 'Rate must be a valid number'),
  tenureMonths: z.string().refine((val) => {
    const num = parseInt(val);
    return !isNaN(num) && num > 0;
  }, 'Tenure must be greater than 0'),
  dueDay: z.string(),
  startDate: z.string(),
  autoPostExpense: z.boolean(),
  autoDebit: z.boolean(),
  alertsEnabled: z.boolean(),
  alertLeadDays: z.string(),
});

type FormData = z.infer<typeof schema>;

interface LoanFormProps {
  loan?: Loan;
  onClose: () => void;
  onSave: () => void;
}

export default function LoanForm({ loan, onClose, onSave }: LoanFormProps) {
  const {
    register,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      type: loan?.type ?? LoanType.Home,
      name: loan?.name ?? '',
      lender: loan?.lender ?? '',
      principal: loan?.principal?.toString() ?? '',
      annualRate: loan?.annualRate?.toString() ?? '8.5',
      tenureMonths: loan?.tenureMonths?.toString() ?? '60',
      dueDay: loan?.dueDay?.toString() ?? '5',
      startDate: format(loan?.startDate ?? new Date(), 'yyyy-MM-dd'),
      autoPostExpense: loan?.autoPostExpense ?? true,
      autoDebit: loan?.autoDebit ?? false,
      alertsEnabled: loan?.alertsEnabled ?? true,
      alertLeadDays: loan?.alertLeadDays?.toString() ?? '2',
    },
  });

  const principal = parseFloat(watch('principal')?.replace(/,/g, '') || '0');
  const annualRate = parseFloat(watch('annualRate') || '0');
  const tenureMonths = parseInt(watch('tenureMonths') || '0');

  const estimatedEmi = calculateEmi({ principal, annualRatePct: annualRate, tenureMonths });

  const onSubmit = async (data: FormData) => {
    await createLoan({
      type: data.type,
      name: data.name,
      lender: data.lender || undefined,
      principal: parseFloat(data.principal.replace(/,/g, '')),
      annualRate: parseFloat(data.annualRate),
      tenureMonths: parseInt(data.tenureMonths),
      startDate: new Date(data.startDate),
      dueDay: parseInt(data.dueDay),
      autoPostExpense: data.autoPostExpense,
      autoDebit: data.autoDebit,
      alertsEnabled: data.alertsEnabled,
      alertLeadDays: parseInt(data.alertLeadDays),
      closed: false,
    });

    onSave();
  };

  return (
    <Modal
      isOpen
      onClose={onClose}
      title={loan ? 'Edit Loan' : 'Add Loan'}
    >
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Loan Type
          </label>
          <select
            {...register('type')}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
          >
            {Object.entries(LoanTypeLabels).map(([key, label]) => (
              <option key={key} value={key}>
                {label}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Loan Name
          </label>
          <input
            type="text"
            {...register('name')}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            placeholder="e.g., SBI Home Loan"
          />
          {errors.name && (
            <p className="text-red-500 text-xs mt-1">{errors.name.message}</p>
          )}
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Lender (optional)
          </label>
          <input
            type="text"
            {...register('lender')}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            placeholder="e.g., State Bank of India"
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Principal
            </label>
            <input
              type="text"
              inputMode="decimal"
              {...register('principal')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              placeholder="0"
            />
            {errors.principal && (
              <p className="text-red-500 text-xs mt-1">{errors.principal.message}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Rate % p.a.
            </label>
            <input
              type="text"
              inputMode="decimal"
              {...register('annualRate')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              placeholder="8.5"
            />
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Tenure (months)
            </label>
            <input
              type="text"
              inputMode="numeric"
              {...register('tenureMonths')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              placeholder="60"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              EMI Day
            </label>
            <select
              {...register('dueDay')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            >
              {Array.from({ length: 28 }, (_, i) => i + 1).map((day) => (
                <option key={day} value={day}>
                  {day}
                </option>
              ))}
            </select>
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Start Date
          </label>
          <input
            type="date"
            {...register('startDate')}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
          />
        </div>

        {estimatedEmi > 0 && (
          <div className="bg-primary/10 rounded-lg p-3 flex items-center gap-3">
            <Calculator className="w-5 h-5 text-primary" />
            <div>
              <div className="text-xs text-gray-600 dark:text-gray-400">Estimated EMI</div>
              <div className="text-lg font-bold text-primary">{formatMoney(estimatedEmi)}</div>
            </div>
          </div>
        )}

        <div className="space-y-2">
          <label className="flex items-center gap-3 p-3 bg-gray-50 dark:bg-gray-750 rounded-lg">
            <input
              type="checkbox"
              {...register('autoPostExpense')}
              className="w-4 h-4 text-primary rounded focus:ring-primary"
            />
            <span className="text-sm text-gray-700 dark:text-gray-300">
              Auto-post expense on EMI payment
            </span>
          </label>

          <label className="flex items-center gap-3 p-3 bg-gray-50 dark:bg-gray-750 rounded-lg">
            <input
              type="checkbox"
              {...register('autoDebit')}
              className="w-4 h-4 text-primary rounded focus:ring-primary"
            />
            <span className="text-sm text-gray-700 dark:text-gray-300">
              Auto-pay EMIs on due date
            </span>
          </label>

          <label className="flex items-center gap-3 p-3 bg-gray-50 dark:bg-gray-750 rounded-lg">
            <input
              type="checkbox"
              {...register('alertsEnabled')}
              className="w-4 h-4 text-primary rounded focus:ring-primary"
            />
            <span className="text-sm text-gray-700 dark:text-gray-300">
              EMI reminders
            </span>
          </label>
        </div>

        <button
          type="submit"
          className="w-full py-3 bg-primary text-white font-medium rounded-lg hover:bg-primary-dark transition-colors"
        >
          {loan ? 'Update Loan' : 'Create Loan'}
        </button>
      </form>
    </Modal>
  );
}

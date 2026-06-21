import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import type { Investment } from '../../types';
import { AssetType } from '../../types';
import { AssetTypeLabels } from '../../lib/enum-labels';
import { upsertInvestment } from '../../db/investment-repository';
import { X } from 'lucide-react';
import { format } from 'date-fns';

const schema = z.object({
  type: z.nativeEnum(AssetType),
  name: z.string().min(1, 'Name is required'),
  institution: z.string().optional(),
  investedAmount: z.string().refine((val) => {
    const num = parseFloat(val.replace(/,/g, ''));
    return !isNaN(num) && num > 0;
  }, 'Invested amount must be greater than 0'),
  currentValue: z.string().optional(),
  units: z.string().optional(),
  annualRate: z.string().optional(),
  startDate: z.string().optional(),
  maturityDate: z.string().optional(),
  note: z.string().optional(),
});

type FormData = z.infer<typeof schema>;

interface InvestmentFormProps {
  investment?: Investment;
  onClose: () => void;
  onSave: () => void;
}

export default function InvestmentForm({ investment, onClose, onSave }: InvestmentFormProps) {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      type: investment?.type ?? AssetType.MutualFund,
      name: investment?.name ?? '',
      institution: investment?.institution ?? '',
      investedAmount: investment?.investedAmount?.toString() ?? '',
      currentValue: investment?.currentValue?.toString() ?? '',
      units: investment?.units?.toString() ?? '',
      annualRate: investment?.annualRate?.toString() ?? '',
      startDate: investment?.startDate ? format(investment.startDate, 'yyyy-MM-dd') : '',
      maturityDate: investment?.maturityDate ? format(investment.maturityDate, 'yyyy-MM-dd') : '',
      note: investment?.note ?? '',
    },
  });

  const onSubmit = async (data: FormData) => {
    const investedAmount = parseFloat(data.investedAmount.replace(/,/g, ''));
    const currentValue = data.currentValue
      ? parseFloat(data.currentValue.replace(/,/g, ''))
      : investedAmount;

    await upsertInvestment({
      id: investment?.id,
      type: data.type,
      name: data.name,
      institution: data.institution || undefined,
      investedAmount,
      currentValue,
      units: data.units ? parseFloat(data.units) : undefined,
      annualRate: data.annualRate ? parseFloat(data.annualRate) : undefined,
      startDate: data.startDate ? new Date(data.startDate) : undefined,
      maturityDate: data.maturityDate ? new Date(data.maturityDate) : undefined,
      note: data.note || undefined,
    });

    onSave();
  };

  return (
    <div className="fixed inset-0 bg-black/50 z-50 flex items-end justify-center">
      <div className="bg-white dark:bg-gray-800 rounded-t-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto">
        <div className="sticky top-0 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 p-4 flex items-center justify-between">
          <h2 className="text-lg font-semibold text-gray-900 dark:text-white">
            {investment ? 'Edit Investment' : 'Add Investment'}
          </h2>
          <button
            onClick={onClose}
            className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700"
          >
            <X className="w-5 h-5 text-gray-500" />
          </button>
        </div>

        <form onSubmit={handleSubmit(onSubmit)} className="p-4 space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Asset Type
            </label>
            <select
              {...register('type')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            >
              {Object.entries(AssetTypeLabels).map(([key, label]) => (
                <option key={key} value={key}>
                  {label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Name
            </label>
            <input
              type="text"
              {...register('name')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              placeholder="e.g., HDFC Mid-Cap Fund"
            />
            {errors.name && (
              <p className="text-red-500 text-xs mt-1">{errors.name.message}</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Institution (optional)
            </label>
            <input
              type="text"
              {...register('institution')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              placeholder="e.g., HDFC Mutual Fund"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Invested Amount
              </label>
              <input
                type="text"
                inputMode="decimal"
                {...register('investedAmount')}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
                placeholder="0"
              />
              {errors.investedAmount && (
                <p className="text-red-500 text-xs mt-1">{errors.investedAmount.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Current Value
              </label>
              <input
                type="text"
                inputMode="decimal"
                {...register('currentValue')}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
                placeholder="Same as invested"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Units (optional)
              </label>
              <input
                type="text"
                inputMode="decimal"
                {...register('units')}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
                placeholder="0"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Annual Rate % (optional)
              </label>
              <input
                type="text"
                inputMode="decimal"
                {...register('annualRate')}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
                placeholder="0"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Start Date (optional)
              </label>
              <input
                type="date"
                {...register('startDate')}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Maturity Date (optional)
              </label>
              <input
                type="date"
                {...register('maturityDate')}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Note (optional)
            </label>
            <textarea
              {...register('note')}
              rows={2}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white resize-none"
              placeholder="Add a note..."
            />
          </div>

          <button
            type="submit"
            className="w-full py-3 bg-primary text-white font-medium rounded-lg hover:bg-primary-dark transition-colors"
          >
            {investment ? 'Update Investment' : 'Add Investment'}
          </button>
        </form>
      </div>
    </div>
  );
}

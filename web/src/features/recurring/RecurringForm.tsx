import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import type { RecurringRule } from '../../types';
import { TxnType, Frequency } from '../../types';
import { FrequencyLabels, TxnTypeLabels, describeFrequency } from '../../lib/enum-labels';
import { formatMoney } from '../../lib/formatters';
import { upsertRecurringRule, processRule } from '../../db/recurring-repository';
import { useCategories } from '../../db/expense-repository';
import Modal from '../../components/ui/Modal';
import { Calendar } from 'lucide-react';
import { format } from 'date-fns';

const schema = z.object({
  type: z.nativeEnum(TxnType),
  title: z.string().min(1, 'Title is required'),
  amount: z.string().refine((val) => {
    const num = parseFloat(val.replace(/,/g, ''));
    return !isNaN(num) && num > 0;
  }, 'Amount must be greater than 0'),
  interval: z.string().refine((val) => {
    const num = parseInt(val);
    return !isNaN(num) && num >= 1;
  }, 'Interval must be at least 1'),
  frequency: z.string(),
  categoryId: z.string().optional(),
  nextDueDate: z.string(),
  endDate: z.string().optional(),
  note: z.string().optional(),
});

type FormData = z.infer<typeof schema>;

interface RecurringFormProps {
  rule?: RecurringRule;
  onClose: () => void;
  onSave: () => void;
}

export default function RecurringForm({ rule, onClose, onSave }: RecurringFormProps) {
  const categories = useCategories();
  const [selectedType, setSelectedType] = useState<TxnType>(
    rule?.type ?? TxnType.Expense
  );

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      type: rule?.type ?? TxnType.Expense,
      title: rule?.title ?? '',
      amount: rule?.amount?.toString() ?? '',
      interval: rule?.interval?.toString() ?? '1',
      frequency: (rule?.frequency ?? Frequency.Monthly).toString(),
      categoryId: rule?.categoryId?.toString() ?? '',
      nextDueDate: format(rule?.nextDueDate ?? new Date(), 'yyyy-MM-dd'),
      endDate: rule?.endDate ? format(rule.endDate, 'yyyy-MM-dd') : '',
      note: rule?.note ?? '',
    },
  });

  const filteredCategories = categories.filter(
    (c) => c.type === selectedType || c.name === 'Others'
  );

  const interval = parseInt(watch('interval') || '1');
  const frequency = Number(watch('frequency')) as Frequency;
  const amount = parseFloat(watch('amount')?.replace(/,/g, '') || '0');
  const type = Number(watch('type')) as TxnType;

  const description = `${type === TxnType.Expense ? 'Expense' : 'Income'} of ${formatMoney(amount)}. ${describeFrequency(interval, frequency)}. Posts automatically on each due date.`;

  const onSubmit = async (data: FormData) => {
    const ruleData = {
      title: data.title,
      amount: parseFloat(data.amount.replace(/,/g, '')),
      categoryId: data.categoryId ? parseInt(data.categoryId) : undefined,
      type: Number(data.type) as TxnType,
      frequency: Number(data.frequency) as Frequency,
      interval: parseInt(data.interval),
      nextDueDate: new Date(data.nextDueDate),
      endDate: data.endDate ? new Date(data.endDate) : undefined,
      active: true,
      note: data.note || undefined,
    };

    if (rule?.id) {
      await upsertRecurringRule({ ...ruleData, id: rule.id });
    } else {
      const newRule = await upsertRecurringRule(ruleData);
      await processRule({ ...ruleData, id: newRule, createdAt: new Date() } as RecurringRule);
    }

    onSave();
  };

  return (
    <Modal
      isOpen
      onClose={onClose}
      title={rule ? 'Edit Recurring' : 'Add Recurring'}
    >
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div className="flex gap-2 bg-gray-100 dark:bg-gray-700 rounded-lg p-1">
          {[TxnType.Expense, TxnType.Income].map((txnType) => (
            <button
              key={txnType}
              type="button"
              onClick={() => {
                setSelectedType(txnType);
                setValue('type', txnType);
              }}
              className={`flex-1 py-2 text-sm font-medium rounded-md transition-colors ${
                selectedType === txnType
                  ? txnType === TxnType.Expense
                    ? 'bg-red-500 text-white'
                    : 'bg-green-500 text-white'
                  : 'text-gray-600 dark:text-gray-400'
              }`}
            >
              {TxnTypeLabels[txnType]}
            </button>
          ))}
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Title
          </label>
          <input
            type="text"
            {...register('title')}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            placeholder="e.g., Salary, Rent"
          />
          {errors.title && (
            <p className="text-red-500 text-xs mt-1">{errors.title.message}</p>
          )}
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Amount
          </label>
          <input
            type="text"
            inputMode="decimal"
            {...register('amount')}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            placeholder="0.00"
          />
          {errors.amount && (
            <p className="text-red-500 text-xs mt-1">{errors.amount.message}</p>
          )}
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Every
            </label>
            <input
              type="text"
              inputMode="numeric"
              {...register('interval')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
              placeholder="1"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Frequency
            </label>
            <select
              {...register('frequency')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            >
              {Object.entries(FrequencyLabels).map(([key, label]) => (
                <option key={key} value={key}>
                  {label}
                </option>
              ))}
            </select>
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Category (optional)
          </label>
          <div className="flex flex-wrap gap-2">
            <button
              type="button"
              onClick={() => setValue('categoryId', '')}
              className={`px-3 py-1.5 text-xs font-medium rounded-full transition-colors ${
                !watch('categoryId')
                  ? 'bg-primary text-white'
                  : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600'
              }`}
            >
              None
            </button>
            {filteredCategories.map((cat) => (
              <button
                key={cat.id}
                type="button"
                onClick={() => setValue('categoryId', cat.id?.toString() ?? '')}
                className={`px-3 py-1.5 text-xs font-medium rounded-full transition-colors ${
                  watch('categoryId') === cat.id?.toString()
                    ? 'bg-primary text-white'
                    : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600'
                }`}
              >
                {cat.name}
              </button>
            ))}
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Start / Next Due Date
          </label>
          <div className="relative">
            <input
              type="date"
              {...register('nextDueDate')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
            <Calendar className="absolute right-3 top-2.5 w-4 h-4 text-gray-400 dark:text-gray-500 pointer-events-none" />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            End Date (optional)
          </label>
          <div className="relative">
            <input
              type="date"
              {...register('endDate')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            />
            <Calendar className="absolute right-3 top-2.5 w-4 h-4 text-gray-400 dark:text-gray-500 pointer-events-none" />
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

        <div className="bg-primary/10 rounded-lg p-3">
          <div className="text-sm text-gray-700 dark:text-gray-300">{description}</div>
        </div>

        <button
          type="submit"
          className="w-full py-3 bg-primary text-white font-medium rounded-lg hover:bg-primary-dark transition-colors"
        >
          {rule ? 'Update Recurring' : 'Add Recurring'}
        </button>
      </form>
    </Modal>
  );
}

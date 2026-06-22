import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import type { Transaction } from '../../types';
import { TxnType, TxnSource, Frequency } from '../../types';
import { useCategoriesByType, upsertTransaction } from '../../db/expense-repository';
import { upsertRecurringRule } from '../../db/recurring-repository';
import { FrequencyLabels } from '../../lib/enum-labels';
import CategoryIcon from '../../components/ui/CategoryIcon';
import Modal from '../../components/ui/Modal';
import { Calendar } from 'lucide-react';
import { format } from 'date-fns';

const schema = z.object({
  type: z.nativeEnum(TxnType),
  amount: z.string().refine((val) => {
    const num = parseFloat(val.replace(/,/g, ''));
    return !isNaN(num) && num > 0;
  }, 'Amount must be greater than 0'),
  title: z.string().min(1, 'Title is required'),
  categoryId: z.string().optional(),
  date: z.string(),
  note: z.string().optional(),
  frequency: z.string().optional(),
});

type FormData = z.infer<typeof schema>;

interface ExpenseFormProps {
  transaction?: Transaction;
  onClose: () => void;
  onSave: () => void;
}

export default function ExpenseForm({ transaction, onClose, onSave }: ExpenseFormProps) {
  const [selectedType, setSelectedType] = useState<TxnType>(
    transaction?.type ?? TxnType.Expense
  );
  const filteredCategories = useCategoriesByType(selectedType);

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    defaultValues: {
      type: transaction?.type ?? TxnType.Expense,
      amount: transaction?.amount?.toString() ?? '',
      title: transaction?.title ?? '',
      categoryId: transaction?.categoryId?.toString() ?? '',
      date: format(transaction?.date ?? new Date(), 'yyyy-MM-dd'),
      note: transaction?.note ?? '',
      frequency: '',
    },
  });

  const onSubmit = async (data: FormData) => {
    const txnData = {
      amount: parseFloat(data.amount.replace(/,/g, '')),
      title: data.title,
      categoryId: data.categoryId ? parseInt(data.categoryId) : undefined,
      date: new Date(data.date),
      type: data.type,
      source: TxnSource.Manual,
      note: data.note || undefined,
      createdAt: new Date(),
    };

    if (transaction?.id) {
      await upsertTransaction({ ...txnData, id: transaction.id });
    } else {
      await upsertTransaction(txnData);

      if (data.frequency) {
        await upsertRecurringRule({
          title: data.title,
          amount: txnData.amount,
          categoryId: txnData.categoryId,
          type: data.type,
          frequency: Number(data.frequency) as Frequency,
          interval: 1,
          nextDueDate: new Date(data.date),
          active: true,
        });
      }
    }

    onSave();
  };

  return (
    <Modal
      isOpen
      onClose={onClose}
      title={transaction ? 'Edit Transaction' : 'Add Transaction'}
    >
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
        <div className="flex gap-2 bg-gray-100 dark:bg-gray-700 rounded-lg p-1">
          {[TxnType.Expense, TxnType.Income].map((type) => (
            <button
              key={type}
              type="button"
              onClick={() => {
                setSelectedType(type);
                setValue('type', type);
              }}
              className={`flex-1 py-2 text-sm font-medium rounded-md transition-colors ${
                selectedType === type
                  ? type === TxnType.Expense
                    ? 'bg-red-500 text-white'
                    : 'bg-green-500 text-white'
                  : 'text-gray-600 dark:text-gray-400'
              }`}
            >
              {type === TxnType.Expense ? 'Expense' : 'Income'}
            </button>
          ))}
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

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Title
          </label>
          <input
            type="text"
            {...register('title')}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            placeholder="e.g., Lunch at cafe"
          />
          {errors.title && (
            <p className="text-red-500 text-xs mt-1">{errors.title.message}</p>
          )}
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
            Category
          </label>
          <div className="flex flex-wrap gap-2">
            {filteredCategories.map((cat) => {
              const catColor = `#${cat.color.toString(16).slice(-6).padStart(6, '0')}`;
              const isSelected = watch('categoryId') === cat.id?.toString();
              return (
                <button
                  key={cat.id}
                  type="button"
                  onClick={() => setValue('categoryId', cat.id?.toString() ?? '')}
                  className={`flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium rounded-full transition-colors ${
                    isSelected
                      ? 'bg-primary text-white'
                      : 'bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600'
                  }`}
                >
                  <CategoryIcon
                    name={cat.name}
                    color={isSelected ? '#ffffff' : catColor}
                    size={14}
                  />
                  {cat.name}
                </button>
              );
            })}
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Date
          </label>
          <div className="relative">
            <input
              type="date"
              {...register('date')}
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

        {!transaction && (
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Repeat (optional)
            </label>
            <select
              {...register('frequency')}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent dark:bg-gray-700 dark:text-white"
            >
              <option value="">No repeat</option>
              {Object.entries(FrequencyLabels).map(([key, label]) => (
                <option key={key} value={key}>
                  {label}
                </option>
              ))}
            </select>
          </div>
        )}

        <button
          type="submit"
          className="w-full py-3 bg-primary text-white font-medium rounded-lg hover:bg-primary-dark transition-colors"
        >
          {transaction ? 'Update' : 'Add Transaction'}
        </button>
      </form>
    </Modal>
  );
}

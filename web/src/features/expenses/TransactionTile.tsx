import type { TransactionWithCategory } from '../../types';
import { TxnType, TxnSource } from '../../types';
import { formatMoney } from '../../lib/formatters';
import { useSettingsStore } from '../../stores/settings-store';
import CategoryIcon from '../../components/ui/CategoryIcon';
import { Trash2, HelpCircle } from 'lucide-react';
import { clsx } from 'clsx';

interface TransactionTileProps {
  transaction: TransactionWithCategory;
  onClick?: () => void;
  onDelete?: () => void;
}

export default function TransactionTile({ transaction, onClick, onDelete }: TransactionTileProps) {
  const isExpense = transaction.type === TxnType.Expense;
  const { autoLabel, emiLabel } = useSettingsStore();

  const sourceLabel =
    transaction.source === TxnSource.EMI
      ? emiLabel
      : transaction.source === TxnSource.Recurring
      ? autoLabel
      : null;

  const sourceColor =
    transaction.source === TxnSource.EMI
      ? 'bg-orange-100 text-orange-700 dark:bg-orange-900/30 dark:text-orange-400'
      : transaction.source === TxnSource.Recurring
      ? 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400'
      : null;

  const catColor = transaction.category
    ? `#${transaction.category.color.toString(16).slice(-6).padStart(6, '0')}`
    : '#9E9E9E';
  const catName = transaction.category?.name || 'Uncategorized';

  return (
    <div
      className="group flex items-center gap-3 px-3 py-2.5 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors cursor-pointer"
      onClick={onClick}
    >
      {/* Category Icon */}
      <div
        className="w-9 h-9 rounded-lg flex items-center justify-center shrink-0"
        style={{ backgroundColor: `${catColor}18` }}
      >
        {transaction.category ? (
          <CategoryIcon name={catName} color={catColor} size={18} />
        ) : (
          <HelpCircle size={18} color={catColor} />
        )}
      </div>

      {/* Main Info */}
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-1.5">
          <span className="text-sm font-medium text-gray-900 dark:text-white truncate max-w-[140px]">
            {transaction.title}
          </span>
          {sourceLabel && (
            <span
              className={clsx(
                'px-1.5 py-0.5 text-[9px] font-semibold rounded shrink-0',
                sourceColor
              )}
            >
              {sourceLabel}
            </span>
          )}
        </div>
        <div className="flex items-center gap-1.5 mt-0.5">
          <span className="text-[11px] text-gray-400 dark:text-gray-500">
            {catName}
          </span>
          {transaction.note && (
            <>
              <span className="text-gray-300 dark:text-gray-600">·</span>
              <span className="text-[11px] text-gray-400 dark:text-gray-500 truncate max-w-[100px]">
                {transaction.note}
              </span>
            </>
          )}
        </div>
      </div>

      {/* Amount */}
      <div className="text-right shrink-0">
        <div
          className={clsx(
            'text-sm font-semibold',
            isExpense
              ? 'text-red-600 dark:text-red-400'
              : 'text-green-600 dark:text-green-400'
          )}
        >
          {isExpense ? '-' : '+'}{formatMoney(transaction.amount)}
        </div>
      </div>

      {/* Delete */}
      {onDelete && (
        <button
          onClick={(e) => {
            e.stopPropagation();
            onDelete();
          }}
          className="shrink-0 p-1.5 rounded-lg text-gray-400 dark:text-gray-500 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 sm:opacity-0 sm:group-hover:opacity-100 transition-all"
        >
          <Trash2 className="w-3.5 h-3.5" />
        </button>
      )}
    </div>
  );
}

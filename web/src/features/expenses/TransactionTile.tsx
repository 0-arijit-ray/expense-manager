import type { TransactionWithCategory } from '../../types';
import { TxnType } from '../../types';
import { formatMoney, relativeDay } from '../../lib/formatters';
import SourceBadge from './SourceBadge';
import { Trash2 } from 'lucide-react';
import { clsx } from 'clsx';

interface TransactionTileProps {
  transaction: TransactionWithCategory;
  onClick?: () => void;
  onDelete?: () => void;
}

export default function TransactionTile({ transaction, onClick, onDelete }: TransactionTileProps) {
  const isExpense = transaction.type === TxnType.Expense;

  return (
    <div
      className="group flex items-center gap-4 p-4 hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors"
    >
      <div
        className="w-12 h-12 rounded-xl flex items-center justify-center text-white text-sm font-semibold shadow-sm shrink-0 cursor-pointer"
        style={{
          backgroundColor: transaction.category
            ? `#${transaction.category.color.toString(16).slice(-6).padStart(6, '0')}`
            : '#9E9E9E',
        }}
        onClick={onClick}
      >
        {transaction.category?.name?.charAt(0) || '?'}
      </div>

      <div className="flex-1 min-w-0 cursor-pointer" onClick={onClick}>
        <div className="flex items-center gap-2">
          <span className="text-sm font-medium text-gray-900 dark:text-white truncate">
            {transaction.title}
          </span>
          <SourceBadge source={transaction.source} />
        </div>
        <div className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">
          {transaction.category?.name || 'Uncategorized'}
        </div>
      </div>

      <div className="text-right shrink-0">
        <div
          className={clsx(
            'text-sm font-semibold',
            isExpense
              ? 'text-red-600 dark:text-red-400'
              : 'text-green-600 dark:text-green-400'
          )}
        >
          {isExpense ? '-' : '+'} {formatMoney(transaction.amount)}
        </div>
        <div className="text-xs text-gray-400 dark:text-gray-500 mt-0.5">
          {relativeDay(new Date(transaction.date))}
        </div>
      </div>

      {onDelete && (
        <button
          onClick={(e) => {
            e.stopPropagation();
            onDelete();
          }}
          className="shrink-0 p-2 rounded-lg text-gray-400 dark:text-gray-500 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 opacity-0 group-hover:opacity-100 transition-all"
        >
          <Trash2 className="w-4 h-4" />
        </button>
      )}
    </div>
  );
}

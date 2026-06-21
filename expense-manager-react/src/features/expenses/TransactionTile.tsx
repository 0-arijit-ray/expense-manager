import type { TransactionWithCategory } from '../../types';
import { TxnType } from '../../types';
import { formatMoney, relativeDay } from '../../lib/formatters';
import SourceBadge from './SourceBadge';
import { clsx } from 'clsx';

interface TransactionTileProps {
  transaction: TransactionWithCategory;
  onClick?: () => void;
}

export default function TransactionTile({ transaction, onClick }: TransactionTileProps) {
  const isExpense = transaction.type === TxnType.Expense;

  return (
    <div
      className="flex items-center gap-3 p-3 bg-white dark:bg-gray-800 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-750 transition-colors cursor-pointer"
      onClick={onClick}
    >
      <div
        className="w-10 h-10 rounded-full flex items-center justify-center text-white text-sm font-medium"
        style={{
          backgroundColor: transaction.category
            ? `#${transaction.category.color.toString(16).slice(-6).padStart(6, '0')}`
            : '#9E9E9E',
        }}
      >
        {transaction.category?.name?.charAt(0) || '?'}
      </div>

      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className="text-sm font-medium text-gray-900 dark:text-white truncate">
            {transaction.title}
          </span>
          <SourceBadge source={transaction.source} />
        </div>
        <div className="text-xs text-gray-500 dark:text-gray-400">
          {transaction.category?.name || 'Uncategorized'}
        </div>
      </div>

      <div className="text-right">
        <div
          className={clsx(
            'text-sm font-semibold',
            isExpense ? 'text-red-600 dark:text-red-400' : 'text-green-600 dark:text-green-400'
          )}
        >
          {isExpense ? '-' : '+'} {formatMoney(transaction.amount)}
        </div>
        <div className="text-xs text-gray-400">
          {relativeDay(new Date(transaction.date))}
        </div>
      </div>
    </div>
  );
}

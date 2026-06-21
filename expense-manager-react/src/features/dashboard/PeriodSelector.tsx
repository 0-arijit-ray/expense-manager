import { usePeriodStore } from '../../stores/period-store';
import { rangeFor, title, Period } from '../../lib/date-range';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { clsx } from 'clsx';

export default function PeriodSelector() {
  const { period, anchor, setPeriod, next, prev } = usePeriodStore();
  const range = rangeFor(period, anchor);
  const periodTitle = title(period, range);

  return (
    <div className="flex flex-col gap-3">
      <div className="flex justify-center gap-1 bg-gray-100 dark:bg-gray-800 rounded-lg p-1">
        {Object.values(Period).map((p) => (
          <button
            key={p}
            onClick={() => setPeriod(p)}
            className={clsx(
              'px-4 py-2 text-sm font-medium rounded-md transition-colors',
              period === p
                ? 'bg-white dark:bg-gray-700 text-primary dark:text-primary-light shadow-sm'
                : 'text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200'
            )}
          >
            {p.charAt(0).toUpperCase() + p.slice(1)}
          </button>
        ))}
      </div>

      <div className="flex items-center justify-between">
        <button
          onClick={prev}
          className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        >
          <ChevronLeft className="w-5 h-5 text-gray-600 dark:text-gray-400" />
        </button>
        <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
          {periodTitle}
        </span>
        <button
          onClick={next}
          className="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors"
        >
          <ChevronRight className="w-5 h-5 text-gray-600 dark:text-gray-400" />
        </button>
      </div>
    </div>
  );
}

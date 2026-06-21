import { usePeriodStore } from '../../stores/period-store';
import { rangeFor, title, Period } from '../../lib/date-range';
import { ChevronLeft, ChevronRight, Calendar } from 'lucide-react';
import { clsx } from 'clsx';

const periodLabels: Record<Period, string> = {
  [Period.Weekly]: 'Week',
  [Period.Monthly]: 'Month',
  [Period.Yearly]: 'Year',
};

export default function PeriodSelector() {
  const { period, anchor, setPeriod, next, prev } = usePeriodStore();
  const range = rangeFor(period, anchor);
  const periodTitle = title(period, range);

  const isCurrentPeriod = (() => {
    const now = new Date();
    return (
      range.start <= now &&
      range.end >= now
    );
  })();

  return (
    <div className="flex items-center gap-3">
      {/* Period Tabs */}
      <div className="flex bg-gray-100 dark:bg-gray-800 rounded-xl p-1 shrink-0">
        {Object.values(Period).map((p) => (
          <button
            key={p}
            onClick={() => setPeriod(p)}
            className={clsx(
              'relative px-3.5 py-1.5 text-xs font-medium rounded-lg transition-all duration-200',
              period === p
                ? 'bg-white dark:bg-gray-700 text-gray-900 dark:text-white shadow-sm'
                : 'text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300'
            )}
          >
            {periodLabels[p]}
          </button>
        ))}
      </div>

      {/* Date Navigation */}
      <div className="flex items-center gap-1 min-w-0 flex-1">
        <button
          onClick={prev}
          className="p-1.5 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors shrink-0"
        >
          <ChevronLeft className="w-4 h-4 text-gray-500 dark:text-gray-400" />
        </button>

        <div className="flex-1 min-w-0 text-center">
          <span className="text-sm font-medium text-gray-800 dark:text-gray-200 truncate block">
            {periodTitle}
          </span>
        </div>

        <button
          onClick={next}
          className="p-1.5 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors shrink-0"
        >
          <ChevronRight className="w-4 h-4 text-gray-500 dark:text-gray-400" />
        </button>
      </div>

      {/* Today Badge */}
      {!isCurrentPeriod && (
        <button
          onClick={() => usePeriodStore.setState({ anchor: new Date() })}
          className="flex items-center gap-1 px-2.5 py-1.5 text-xs font-medium text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors shrink-0"
        >
          <Calendar className="w-3 h-3" />
          Today
        </button>
      )}
    </div>
  );
}

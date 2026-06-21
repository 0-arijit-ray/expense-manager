import { TxnSource } from '../../types';
import { TxnSourceLabels } from '../../lib/enum-labels';
import { clsx } from 'clsx';

interface SourceBadgeProps {
  source: TxnSource;
}

export default function SourceBadge({ source }: SourceBadgeProps) {
  if (source === TxnSource.Manual) return null;

  return (
    <span
      className={clsx(
        'px-1.5 py-0.5 text-[10px] font-medium rounded',
        source === TxnSource.EMI
          ? 'bg-orange-100 text-orange-700 dark:bg-orange-900/30 dark:text-orange-400'
          : 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400'
      )}
    >
      {TxnSourceLabels[source]}
    </span>
  );
}

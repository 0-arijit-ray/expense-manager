import type { ReactNode } from 'react';
import { clsx } from 'clsx';

interface BadgeProps {
  children: ReactNode;
  variant?: 'default' | 'success' | 'warning' | 'danger' | 'info';
  size?: 'sm' | 'md';
}

export default function Badge({
  children,
  variant = 'default',
  size = 'sm',
}: BadgeProps) {
  return (
    <span
      className={clsx(
        'inline-flex items-center font-medium rounded-full',
        {
          'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400':
            variant === 'default',
          'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400':
            variant === 'success',
          'bg-amber-100 dark:bg-amber-900/30 text-amber-700 dark:text-amber-400':
            variant === 'warning',
          'bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400':
            variant === 'danger',
          'bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400':
            variant === 'info',
        },
        {
          'px-2 py-0.5 text-xs': size === 'sm',
          'px-3 py-1 text-sm': size === 'md',
        }
      )}
    >
      {children}
    </span>
  );
}

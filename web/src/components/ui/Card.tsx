import type { HTMLAttributes } from 'react';
import { forwardRef } from 'react';
import { clsx } from 'clsx';

interface CardProps extends HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'hover' | 'gradient' | 'glass';
  padding?: 'none' | 'sm' | 'md' | 'lg';
}

const Card = forwardRef<HTMLDivElement, CardProps>(
  ({ className, variant = 'default', padding = 'md', children, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={clsx(
          'rounded-2xl transition-all duration-200',
          {
            'bg-white dark:bg-gray-800 shadow-sm': variant === 'default',
            'bg-white dark:bg-gray-800 shadow-sm hover:shadow-md hover:-translate-y-0.5 cursor-pointer':
              variant === 'hover',
            'bg-gradient-to-br from-primary to-primary-dark text-white':
              variant === 'gradient',
            'bg-white/80 dark:bg-gray-800/80 backdrop-blur-lg shadow-lg':
              variant === 'glass',
          },
          {
            'p-0': padding === 'none',
            'p-3': padding === 'sm',
            'p-4': padding === 'md',
            'p-6': padding === 'lg',
          },
          className
        )}
        {...props}
      >
        {children}
      </div>
    );
  }
);

Card.displayName = 'Card';

export default Card;

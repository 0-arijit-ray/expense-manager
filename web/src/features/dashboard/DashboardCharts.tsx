import { useRef, useEffect, useState } from 'react';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';
import { Bar, Doughnut } from 'react-chartjs-2';
import type { SeriesPoint, CategorySlice } from '../../types';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend
);

function useDarkMode() {
  const [dark, setDark] = useState(() =>
    document.documentElement.classList.contains('dark')
  );

  useEffect(() => {
    const observer = new MutationObserver(() => {
      setDark(document.documentElement.classList.contains('dark'));
    });
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['class'],
    });
    return () => observer.disconnect();
  }, []);

  return dark;
}

interface IncomeExpenseBarChartProps {
  data: SeriesPoint[];
}

export function IncomeExpenseBarChart({ data }: IncomeExpenseBarChartProps) {
  const chartRef = useRef<ChartJS<'bar'>>(null);
  const isDark = useDarkMode();

  const tickColor = isDark ? '#9CA3AF' : '#9CA3AF';
  const gridColor = isDark ? 'rgba(156, 163, 175, 0.2)' : 'rgba(156, 163, 175, 0.1)';

  const chartData = {
    labels: data.map((d) => d.label),
    datasets: [
      {
        label: 'Expense',
        data: data.map((d) => d.expense),
        backgroundColor: 'rgba(239, 68, 68, 0.8)',
        borderRadius: 4,
      },
      {
        label: 'Income',
        data: data.map((d) => d.income),
        backgroundColor: 'rgba(30, 111, 92, 0.8)',
        borderRadius: 4,
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: false,
      },
      tooltip: {
        mode: 'index' as const,
        intersect: false,
      },
    },
    scales: {
      x: {
        grid: {
          display: false,
        },
        ticks: {
          color: tickColor,
          font: {
            size: window.innerWidth < 640 ? 9 : 11,
          },
          maxRotation: window.innerWidth < 640 ? 45 : 0,
        },
      },
      y: {
        grid: {
          color: gridColor,
        },
        ticks: {
          color: tickColor,
          font: {
            size: window.innerWidth < 640 ? 9 : 11,
          },
          callback: (value: number | string) => {
            const num = typeof value === 'string' ? parseFloat(value) : value;
            if (num >= 100000) return `${(num / 100000).toFixed(1)}L`;
            if (num >= 1000) return `${(num / 1000).toFixed(0)}K`;
            return num.toString();
          },
        },
      },
    },
  };

  return (
    <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
      <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-4">
        Cash Flow
      </h3>
      <div className="h-48 sm:h-56 md:h-64">
        <Bar ref={chartRef} data={chartData} options={options} />
      </div>
      <div className="flex justify-center gap-4 sm:gap-6 mt-4">
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full bg-red-500" />
          <span className="text-xs text-gray-500 dark:text-gray-400">Expense</span>
        </div>
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full bg-primary" />
          <span className="text-xs text-gray-500 dark:text-gray-400">Income</span>
        </div>
      </div>
    </div>
  );
}

interface CategoryDonutProps {
  data: CategorySlice[];
}

export function CategoryDonut({ data }: CategoryDonutProps) {
  const chartRef = useRef<ChartJS<'doughnut'>>(null);

  const colors = [
    '#EF4444', '#F97316', '#EAB308', '#22C55E', '#14B8A6',
    '#3B82F6', '#8B5CF6', '#EC4899', '#6366F1', '#78716C',
  ];

  const chartData = {
    labels: data.map((d) => d.category?.name || 'Uncategorized'),
    datasets: [
      {
        data: data.map((d) => d.total),
        backgroundColor: data.map((_, i) => colors[i % colors.length]),
        borderWidth: 0,
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    cutout: '65%',
    plugins: {
      legend: {
        display: false,
      },
      tooltip: {
        callbacks: {
          label: (context: any) => {
            const total = data.reduce((sum, d) => sum + d.total, 0);
            const percentage = total > 0 ? ((context.raw / total) * 100).toFixed(1) : 0;
            return `${context.label}: ${percentage}%`;
          },
        },
      },
    },
  };

  if (data.length === 0) {
    return (
      <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
        <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-4">
          Spending by Category
        </h3>
        <div className="h-48 sm:h-56 md:h-64 flex items-center justify-center text-gray-400 dark:text-gray-500 text-sm">
          No expenses yet
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white dark:bg-gray-800 rounded-2xl p-4 shadow-sm">
      <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 mb-4">
        Spending by Category
      </h3>
      <div className="h-48 sm:h-56 md:h-64">
        <Doughnut ref={chartRef} data={chartData} options={options} />
      </div>
      <div className="mt-4 grid grid-cols-2 gap-2">
        {data.slice(0, 6).map((item, i) => (
          <div key={i} className="flex items-center gap-2">
            <div
              className="w-2.5 h-2.5 rounded-full flex-shrink-0"
              style={{ backgroundColor: colors[i % colors.length] }}
            />
            <span className="text-xs text-gray-600 dark:text-gray-400 truncate">
              {item.category?.name || 'Uncategorized'}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

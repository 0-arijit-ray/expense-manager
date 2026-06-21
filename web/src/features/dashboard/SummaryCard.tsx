import { formatMoney, formatMoneyCompact } from '../../lib/formatters';
import { TrendingUp, TrendingDown, Wallet } from 'lucide-react';

interface SummaryCardProps {
  income: number;
  expense: number;
  net: number;
}

export default function SummaryCard({ income, expense, net }: SummaryCardProps) {
  return (
    <div className="bg-gradient-to-br from-primary to-primary-dark rounded-2xl p-6 text-white shadow-lg">
      <div className="flex items-center gap-2 mb-4">
        <Wallet className="w-5 h-5 opacity-80" />
        <span className="text-sm font-medium opacity-80">Net Balance</span>
      </div>

      <div className="text-3xl font-bold mb-6">
        {formatMoneyCompact(net)}
      </div>

      <div className="flex gap-4">
        <div className="flex-1 bg-white/10 rounded-xl p-3">
          <div className="flex items-center gap-2 mb-1">
            <TrendingUp className="w-4 h-4 text-green-300" />
            <span className="text-xs opacity-80">Income</span>
          </div>
          <div className="text-lg font-semibold">{formatMoney(income)}</div>
        </div>

        <div className="flex-1 bg-white/10 rounded-xl p-3">
          <div className="flex items-center gap-2 mb-1">
            <TrendingDown className="w-4 h-4 text-red-300" />
            <span className="text-xs opacity-80">Expense</span>
          </div>
          <div className="text-lg font-semibold">{formatMoney(expense)}</div>
        </div>
      </div>
    </div>
  );
}

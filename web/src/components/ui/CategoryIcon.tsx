import type { LucideIcon } from 'lucide-react';
import {
  UtensilsCrossed,
  ShoppingCart,
  Bus,
  ShoppingBag,
  Receipt,
  Film,
  Heart,
  Home,
  Landmark,
  TrendingUp,
  DollarSign,
  ArrowLeftRight,
  FolderOpen,
} from 'lucide-react';

const CATEGORY_ICONS: Record<string, LucideIcon> = {
  'Food & Dining': UtensilsCrossed,
  'Groceries': ShoppingCart,
  'Transport': Bus,
  'Shopping': ShoppingBag,
  'Bills & Utilities': Receipt,
  'Entertainment': Film,
  'Health': Heart,
  'Rent': Home,
  'EMI & Loans': Landmark,
  'Investments': TrendingUp,
  'Salary': DollarSign,
  'Transfer': ArrowLeftRight,
  'Others': FolderOpen,
};

interface CategoryIconProps {
  name: string;
  color?: string;
  size?: number;
  className?: string;
}

export function getCategoryIcon(name: string): LucideIcon {
  return CATEGORY_ICONS[name] ?? FolderOpen;
}

export default function CategoryIcon({
  name,
  color,
  size = 16,
  className = '',
}: CategoryIconProps) {
  const Icon = getCategoryIcon(name);
  return <Icon size={size} color={color} className={className} />;
}

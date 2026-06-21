import { format, isToday, isYesterday, isTomorrow } from 'date-fns';

let currencySymbol = '₹';
let locale = 'en-IN';

export function setCurrency(symbol: string, newLocale: string) {
  currencySymbol = symbol;
  locale = newLocale;
}

export function getCurrencySymbol() {
  return currencySymbol;
}

export function getLocale() {
  return locale;
}

export function formatMoney(num: number): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: getCurrencyCode(currencySymbol),
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(num);
}

export function formatMoneyPrecise(num: number): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: getCurrencyCode(currencySymbol),
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(num);
}

export function formatMoneyCompact(num: number): string {
  const absNum = Math.abs(num);
  const sign = num < 0 ? '-' : '';

  if (absNum >= 10000000) {
    return `${sign}₹${(absNum / 10000000).toFixed(1)}Cr`;
  }
  if (absNum >= 100000) {
    return `${sign}₹${(absNum / 100000).toFixed(1)}L`;
  }
  if (absNum >= 1000) {
    return `${sign}₹${(absNum / 1000).toFixed(1)}K`;
  }
  return `${sign}₹${absNum}`;
}

export function formatMoneySigned(num: number, isExpense: boolean): string {
  const sign = isExpense ? '-' : '+';
  return `${sign} ${formatMoney(Math.abs(num))}`;
}

function getCurrencyCode(symbol: string): string {
  const codes: Record<string, string> = {
    '₹': 'INR',
    '$': 'USD',
    '€': 'EUR',
    '£': 'GBP',
    '¥': 'JPY',
  };
  return codes[symbol] || 'INR';
}

export function formatDate(date: Date): string {
  return format(date, 'MMM d, yyyy');
}

export function formatShortDate(date: Date): string {
  return format(date, 'MMM d');
}

export function formatDay(date: Date): string {
  return format(date, 'd');
}

export function formatShortDay(date: Date): string {
  return format(date, 'EEE');
}

export function formatMonth(date: Date): string {
  return format(date, 'MMMM');
}

export function formatShortMonth(date: Date): string {
  return format(date, 'MMM');
}

export function formatWeekday(date: Date): string {
  return format(date, 'EEEE');
}

export function formatFullDate(date: Date): string {
  return format(date, 'EEEE, MMMM d, yyyy');
}

export function relativeDay(date: Date): string {
  if (isToday(date)) return 'Today';
  if (isYesterday(date)) return 'Yesterday';
  if (isTomorrow(date)) return 'Tomorrow';
  return format(date, 'MMM d');
}

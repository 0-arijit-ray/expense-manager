import { startOfWeek, endOfWeek, startOfMonth, endOfMonth, startOfYear, endOfYear, addWeeks, addMonths, addYears, subWeeks, subMonths, subYears, format } from 'date-fns';

export enum Period {
  Weekly = 'weekly',
  Monthly = 'monthly',
  Yearly = 'yearly',
}

export interface DateRange {
  start: Date;
  end: Date;
}

export function rangeFor(period: Period, anchor: Date): DateRange {
  switch (period) {
    case Period.Weekly:
      return {
        start: startOfWeek(anchor, { weekStartsOn: 1 }),
        end: endOfWeek(anchor, { weekStartsOn: 1 }),
      };
    case Period.Monthly:
      return {
        start: startOfMonth(anchor),
        end: endOfMonth(anchor),
      };
    case Period.Yearly:
      return {
        start: startOfYear(anchor),
        end: endOfYear(anchor),
      };
  }
}

export function shift(period: Period, anchor: Date, delta: number): Date {
  switch (period) {
    case Period.Weekly:
      return delta > 0 ? addWeeks(anchor, delta) : subWeeks(anchor, -delta);
    case Period.Monthly:
      return delta > 0 ? addMonths(anchor, delta) : subMonths(anchor, -delta);
    case Period.Yearly:
      return delta > 0 ? addYears(anchor, delta) : subYears(anchor, -delta);
  }
}

export function title(period: Period, range: DateRange): string {
  switch (period) {
    case Period.Weekly:
      return `${format(range.start, 'MMM d')} – ${format(range.end, 'MMM d, yyyy')}`;
    case Period.Monthly:
      return format(range.start, 'MMMM yyyy');
    case Period.Yearly:
      return format(range.start, 'yyyy');
  }
}

export function getPeriodUnits(period: Period, range: DateRange): string[] {
  switch (period) {
    case Period.Weekly:
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    case Period.Monthly: {
      const weeks: string[] = [];
      const start = range.start;
      const end = range.end;
      let current = start;
      let weekNum = 1;
      while (current <= end) {
        weeks.push(`W${weekNum}`);
        weekNum++;
        current = addWeeks(current, 1);
      }
      return weeks;
    }
    case Period.Yearly:
      return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  }
}

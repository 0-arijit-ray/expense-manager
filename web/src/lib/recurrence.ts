import { Frequency } from '../types';
import { addDays, addWeeks, addMonths, addYears, isBefore } from 'date-fns';

export function nextOccurrence(from: Date, frequency: Frequency, interval: number): Date {
  switch (frequency) {
    case Frequency.Daily:
      return addDays(from, interval);
    case Frequency.Weekly:
      return addWeeks(from, interval);
    case Frequency.Monthly:
      return addMonths(from, interval);
    case Frequency.Yearly:
      return addYears(from, interval);
  }
}

export function occurrencesUntil(
  start: Date,
  until: Date,
  frequency: Frequency,
  interval: number,
  maxCount: number = 800
): Date[] {
  const dates: Date[] = [];
  let current = start;
  let count = 0;

  while (isBefore(current, until) && count < maxCount) {
    current = nextOccurrence(current, frequency, interval);
    if (isBefore(current, until) || current.getTime() === until.getTime()) {
      dates.push(current);
    }
    count++;
  }

  return dates;
}

import { db } from './database';
import type { RecurringRule, RecurringWithCategory } from '../types';
import { TxnSource } from '../types';
import { nextOccurrence } from '../lib/recurrence';
import { useLiveQuery } from 'dexie-react-hooks';
import { isBefore, startOfDay } from 'date-fns';

export function useRecurringRules() {
  return useLiveQuery(async () => {
    const rules = await db.recurringRules.orderBy('nextDueDate').toArray();
    const categories = await db.categories.toArray();
    const catMap = new Map(categories.map((c) => [c.id, c]));

    return rules.map((r) => ({
      ...r,
      category: r.categoryId ? catMap.get(r.categoryId) : undefined,
    })) as RecurringWithCategory[];
  }, []) ?? [];
}

export async function upsertRecurringRule(rule: Omit<RecurringRule, 'id' | 'createdAt'> & { id?: number }): Promise<number> {
  if (rule.id) {
    await db.recurringRules.update(rule.id, rule);
    return rule.id;
  }
  return db.recurringRules.add({ ...rule, createdAt: new Date() } as RecurringRule);
}

export async function deleteRecurringRule(id: number): Promise<void> {
  await db.recurringRules.delete(id);
}

export async function setActive(id: number, active: boolean): Promise<void> {
  await db.recurringRules.update(id, { active });
}

export async function markAsPaid(rule: RecurringRule): Promise<void> {
  const now = new Date();
  const dueDate = new Date(rule.nextDueDate);

  // Create transaction for this due date
  await db.transactions.add({
    amount: rule.amount,
    title: rule.title,
    categoryId: rule.categoryId,
    date: dueDate,
    type: rule.type,
    source: TxnSource.Recurring,
    recurringId: rule.id,
    note: rule.note,
    createdAt: now,
  });

  // Advance to next occurrence
  const nextDue = nextOccurrence(dueDate, rule.frequency, rule.interval);

  const updates: Partial<RecurringRule> = {
    nextDueDate: nextDue,
    lastPostedDate: dueDate,
  };

  // If end date reached, deactivate
  if (rule.endDate && nextDue > rule.endDate) {
    updates.active = false;
  }

  await db.recurringRules.update(rule.id!, updates);
}

export async function processRule(rule: RecurringRule, now: Date = new Date()): Promise<number> {
  if (!rule.active) return 0;

  let count = 0;
  let currentDueDate = new Date(rule.nextDueDate);
  const maxIterations = 800;

  while (isBefore(currentDueDate, startOfDay(now)) && count < maxIterations) {
    if (rule.endDate && isBefore(rule.endDate, currentDueDate)) {
      await db.recurringRules.update(rule.id!, { active: false });
      break;
    }

    await db.transactions.add({
      amount: rule.amount,
      title: rule.title,
      categoryId: rule.categoryId,
      date: currentDueDate,
      type: rule.type,
      source: TxnSource.Recurring,
      recurringId: rule.id,
      createdAt: new Date(),
    });

    const nextDue = nextOccurrence(currentDueDate, rule.frequency, rule.interval);

    await db.recurringRules.update(rule.id!, {
      nextDueDate: nextDue,
      lastPostedDate: currentDueDate,
    });

    currentDueDate = nextDue;
    count++;
  }

  return count;
}

export async function processAllRecurring(now: Date = new Date()): Promise<number> {
  const activeRules = await db.recurringRules
    .where('active')
    .equals(1)
    .toArray();

  let total = 0;
  for (const rule of activeRules) {
    total += await processRule(rule, now);
  }
  return total;
}

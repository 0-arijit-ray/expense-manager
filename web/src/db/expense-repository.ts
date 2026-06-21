import { db } from './database';
import type {
  Category,
  Transaction,
  TransactionWithCategory,
} from '../types';
import { TxnType } from '../types';
import { useLiveQuery } from 'dexie-react-hooks';

export function useCategories() {
  return useLiveQuery(() => db.categories.orderBy('name').toArray(), []) ?? [];
}

export function useCategoriesByType(type: TxnType) {
  return useLiveQuery(() => db.categories.where('type').equals(type).toArray(), [type]) ?? [];
}

export async function addCategory(category: Omit<Category, 'id'>): Promise<number> {
  return db.categories.add(category as Category);
}

export function useTransactions(options?: { from?: Date; to?: Date; limit?: number }) {
  return useLiveQuery(async () => {
    let txns: Transaction[];

    if (options?.from && options?.to) {
      txns = await db.transactions
        .where('date')
        .between(options.from, options.to, true, true)
        .reverse()
        .toArray();
    } else {
      txns = await db.transactions.orderBy('date').reverse().toArray();
    }

    if (options?.limit) {
      txns = txns.slice(0, options.limit);
    }

    const categories = await db.categories.toArray();
    const catMap = new Map(categories.map((c: Category) => [c.id, c]));

    return txns.map((t: Transaction) => ({
      ...t,
      category: t.categoryId ? catMap.get(t.categoryId) : undefined,
    })) as TransactionWithCategory[];
  }, [options?.from?.getTime(), options?.to?.getTime(), options?.limit]) ?? [];
}

export async function upsertTransaction(txn: Omit<Transaction, 'id'> & { id?: number }): Promise<number> {
  if (txn.id) {
    await db.transactions.update(txn.id, txn);
    return txn.id;
  }
  return db.transactions.add(txn as Transaction);
}

export async function deleteTransaction(id: number): Promise<void> {
  await db.transactions.delete(id);
}

export function useNet(from: Date, to: Date) {
  return useLiveQuery(async () => {
    const txns = await db.transactions
      .where('date')
      .between(from, to, true, true)
      .toArray();

    return txns.reduce((sum: number, t: Transaction) => {
      return sum + (t.type === TxnType.Income ? t.amount : -t.amount);
    }, 0);
  }, [from.getTime(), to.getTime()]) ?? 0;
}

export async function sumByType(from: Date, to: Date, type: TxnType): Promise<number> {
  const txns = await db.transactions
    .where('date')
    .between(from, to, true, true)
    .toArray();

  return txns
    .filter((t: Transaction) => t.type === type)
    .reduce((sum: number, t: Transaction) => sum + t.amount, 0);
}

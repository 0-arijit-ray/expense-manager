import { db } from './database';
import type { Investment, PortfolioSummary } from '../types';
import { useLiveQuery } from 'dexie-react-hooks';

export function useInvestments() {
  return useLiveQuery(() => db.investments.orderBy('currentValue').reverse().toArray(), []) ?? [];
}

export async function allInvestments(): Promise<Investment[]> {
  return db.investments.orderBy('currentValue').reverse().toArray();
}

export async function upsertInvestment(inv: Omit<Investment, 'id' | 'updatedAt'> & { id?: number }): Promise<number> {
  if (inv.id) {
    await db.investments.update(inv.id, { ...inv, updatedAt: new Date() });
    return inv.id;
  }
  return db.investments.add({ ...inv, updatedAt: new Date() } as Investment);
}

export async function deleteInvestment(id: number): Promise<void> {
  await db.investments.delete(id);
}

export async function updateInvestmentValue(id: number, currentValue: number): Promise<void> {
  await db.investments.update(id, { currentValue, updatedAt: new Date() });
}

export function usePortfolioSummary(): PortfolioSummary {
  const investments = useInvestments();

  const summary: PortfolioSummary = {
    invested: 0,
    current: 0,
    gain: 0,
    gainPct: 0,
    byType: new Map(),
  };

  for (const inv of investments) {
    summary.invested += inv.investedAmount;
    summary.current += inv.currentValue;

    const existing = summary.byType.get(inv.type);
    if (existing) {
      existing.invested += inv.investedAmount;
      existing.current += inv.currentValue;
    } else {
      summary.byType.set(inv.type, {
        invested: inv.investedAmount,
        current: inv.currentValue,
      });
    }
  }

  summary.gain = summary.current - summary.invested;
  summary.gainPct = summary.invested > 0 ? (summary.gain / summary.invested) * 100 : 0;

  return summary;
}

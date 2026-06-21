import { db } from './database';
import type {
  Loan,
  EmiSchedule,
  LoanSummary,
} from '../types';
import { TxnType, TxnSource } from '../types';
import { emi as calculateEmi, schedule as generateSchedule } from '../lib/finance-math';
import { useLiveQuery } from 'dexie-react-hooks';
import { isBefore, startOfDay } from 'date-fns';

export function useLoans() {
  return useLiveQuery(() => db.loans.orderBy('closed').toArray(), []) ?? [];
}

export async function getLoan(id: number): Promise<Loan | undefined> {
  return db.loans.get(id);
}

export function useLoanSchedule(loanId: number) {
  return useLiveQuery(
    () => db.emiSchedules.where('loanId').equals(loanId).sortBy('installmentNo'),
    [loanId]
  ) ?? [];
}

export async function createLoan(loan: Omit<Loan, 'id' | 'emiAmount' | 'createdAt'>): Promise<number> {
  const emiAmount = calculateEmi({
    principal: loan.principal,
    annualRatePct: loan.annualRate,
    tenureMonths: loan.tenureMonths,
  });

  const loanId = await db.loans.add({
    ...loan,
    emiAmount,
    createdAt: new Date(),
  } as Loan);

  const scheduleRows = generateSchedule({
    principal: loan.principal,
    annualRatePct: loan.annualRate,
    tenureMonths: loan.tenureMonths,
    startDate: loan.startDate,
    dueDay: loan.dueDay,
  });

  const emiRecords: EmiSchedule[] = scheduleRows.map((row) => ({
    loanId,
    installmentNo: row.installmentNo,
    dueDate: row.dueDate,
    emiAmount: row.emi,
    principalComponent: row.principal,
    interestComponent: row.interest,
    balance: row.balance,
    paid: false,
  }));

  await db.emiSchedules.bulkAdd(emiRecords);
  return loanId;
}

export async function deleteLoan(id: number): Promise<void> {
  await db.emiSchedules.where('loanId').equals(id).delete();
  await db.loans.delete(id);
}

export async function setClosed(id: number, closed: boolean): Promise<void> {
  await db.loans.update(id, { closed });
}

export async function markEmiPaid(
  emi: EmiSchedule,
  loan: Loan,
  paidDate: Date = new Date()
): Promise<void> {
  let transactionId: number | undefined;

  if (loan.autoPostExpense) {
    const categories = await db.categories.toArray();
    const emiCategory = categories.find((c) => c.name === 'EMI & Loans');

    if (emiCategory) {
      transactionId = await db.transactions.add({
        amount: emi.emiAmount,
        title: `${loan.name} EMI #${emi.installmentNo}`,
        categoryId: emiCategory.id,
        date: paidDate,
        type: TxnType.Expense,
        source: TxnSource.EMI,
        emiId: emi.id,
        createdAt: new Date(),
      });
    }
  }

  await db.emiSchedules.update(emi.id!, {
    paid: true,
    paidDate,
    transactionId,
  });
}

export async function autoProcessDueEmis(now: Date = new Date()): Promise<number> {
  const loans = await db.loans.where('closed').equals(0).toArray();
  let count = 0;

  for (const loan of loans) {
    if (!loan.autoDebit) continue;

    const unpaidEmis = await db.emiSchedules
      .where('loanId')
      .equals(loan.id!)
      .and((emi: EmiSchedule) => !emi.paid && isBefore(emi.dueDate, startOfDay(now)))
      .toArray();

    for (const emi of unpaidEmis) {
      await markEmiPaid(emi, loan, now);
      count++;
    }
  }

  return count;
}

export async function markEmiUnpaid(emi: EmiSchedule): Promise<void> {
  if (emi.transactionId) {
    await db.transactions.delete(emi.transactionId);
  }

  await db.emiSchedules.update(emi.id!, {
    paid: false,
    paidDate: undefined,
    transactionId: undefined,
  });
}

export async function getLoanSummaries(): Promise<LoanSummary[]> {
  const loans = await db.loans.toArray();
  const summaries: LoanSummary[] = [];

  for (const loan of loans) {
    const schedule = await db.emiSchedules
      .where('loanId')
      .equals(loan.id!)
      .toArray();

    const paidCount = schedule.filter((s: EmiSchedule) => s.paid).length;
    const totalCount = schedule.length;
    const outstanding = schedule
      .filter((s: EmiSchedule) => !s.paid)
      .reduce((sum: number, s: EmiSchedule) => sum + s.emiAmount, 0);

    const nextDue = schedule
      .filter((s: EmiSchedule) => !s.paid)
      .sort((a: EmiSchedule, b: EmiSchedule) => a.dueDate.getTime() - b.dueDate.getTime())[0];

    summaries.push({
      loan,
      outstanding,
      paidCount,
      totalCount,
      nextDue,
      progress: totalCount > 0 ? paidCount / totalCount : 0,
    });
  }

  return summaries;
}

export function useLoanSummaries() {
  return useLiveQuery(async () => {
    const loans = await db.loans.toArray();
    const summaries: LoanSummary[] = [];

    for (const loan of loans) {
      const schedule = await db.emiSchedules
        .where('loanId')
        .equals(loan.id!)
        .toArray();

      const paidCount = schedule.filter((s: EmiSchedule) => s.paid).length;
      const totalCount = schedule.length;
      const outstanding = schedule
        .filter((s: EmiSchedule) => !s.paid)
        .reduce((sum: number, s: EmiSchedule) => sum + s.emiAmount, 0);

      const nextDue = schedule
        .filter((s: EmiSchedule) => !s.paid)
        .sort((a: EmiSchedule, b: EmiSchedule) => a.dueDate.getTime() - b.dueDate.getTime())[0];

      summaries.push({
        loan,
        outstanding,
        paidCount,
        totalCount,
        nextDue,
        progress: totalCount > 0 ? paidCount / totalCount : 0,
      });
    }

    return summaries;
  }, []) ?? [];
}

export async function getUpcomingEmis(days: number = 60) {
  const loans = await db.loans.where('closed').equals(0).toArray();
  const now = new Date();
  const cutoff = new Date(now.getTime() + days * 24 * 60 * 60 * 1000);

  const upcoming: { emi: EmiSchedule; loan: Loan }[] = [];

  for (const loan of loans) {
    const unpaidEmis = await db.emiSchedules
      .where('loanId')
      .equals(loan.id!)
      .and((emi: EmiSchedule) => !emi.paid && emi.dueDate >= now && emi.dueDate <= cutoff)
      .toArray();

    for (const emi of unpaidEmis) {
      upcoming.push({ emi, loan });
    }
  }

  return upcoming.sort((a, b) => a.emi.dueDate.getTime() - b.emi.dueDate.getTime());
}

export function useUpcomingEmis(days: number = 60) {
  return useLiveQuery(async () => {
    return getUpcomingEmis(days);
  }, [days]) ?? [];
}

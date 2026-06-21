import type { AmortizationRow } from '../types';
import { addMonths, setDate } from 'date-fns';

export function emi({
  principal,
  annualRatePct,
  tenureMonths,
}: {
  principal: number;
  annualRatePct: number;
  tenureMonths: number;
}): number {
  if (tenureMonths <= 0) return 0;
  if (annualRatePct <= 0) return principal / tenureMonths;

  const r = annualRatePct / 12 / 100;
  const n = tenureMonths;
  const factor = Math.pow(1 + r, n);
  const amount = principal * r * factor / (factor - 1);
  return Math.round(amount * 100) / 100;
}

export function totalInterest({
  principal,
  annualRatePct,
  tenureMonths,
}: {
  principal: number;
  annualRatePct: number;
  tenureMonths: number;
}): number {
  const monthlyEmi = emi({ principal, annualRatePct, tenureMonths });
  return monthlyEmi * tenureMonths - principal;
}

export function schedule({
  principal,
  annualRatePct,
  tenureMonths,
  startDate,
  dueDay = 5,
}: {
  principal: number;
  annualRatePct: number;
  tenureMonths: number;
  startDate: Date;
  dueDay?: number;
}): AmortizationRow[] {
  const rows: AmortizationRow[] = [];
  const monthlyEmi = emi({ principal, annualRatePct, tenureMonths });
  const r = annualRatePct / 12 / 100;
  let balance = principal;

  for (let i = 1; i <= tenureMonths; i++) {
    const interest = Math.round(balance * r * 100) / 100;
    const principalPart = Math.round((monthlyEmi - interest) * 100) / 100;
    balance = Math.round((balance - principalPart) * 100) / 100;

    const dueDate = addMonths(startDate, i);
    const finalDueDate = setDate(dueDate, Math.min(dueDay, 28));

    rows.push({
      installmentNo: i,
      dueDate: finalDueDate,
      emi: monthlyEmi,
      principal: principalPart,
      interest,
      balance: Math.max(0, balance),
    });
  }

  return rows;
}

export function sipFutureValue({
  monthly,
  annualRatePct,
  months,
}: {
  monthly: number;
  annualRatePct: number;
  months: number;
}): number {
  if (months <= 0) return 0;
  if (annualRatePct <= 0) return monthly * months;

  const r = annualRatePct / 12 / 100;
  const factor = Math.pow(1 + r, months);
  return Math.round(monthly * ((factor - 1) / r) * (1 + r) * 100) / 100;
}

export function compoundMaturity({
  principal,
  annualRatePct,
  years,
}: {
  principal: number;
  annualRatePct: number;
  years: number;
}): number {
  if (years <= 0) return principal;
  if (annualRatePct <= 0) return principal;

  const r = annualRatePct / 100;
  return Math.round(principal * Math.pow(1 + r, years) * 100) / 100;
}

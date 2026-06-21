import {
  TxnType,
  TxnSource,
  Frequency,
  LoanType,
  AssetType,
} from '../types';

export const TxnTypeLabels: Record<TxnType, string> = {
  [TxnType.Expense]: 'Expense',
  [TxnType.Income]: 'Income',
};

export const TxnSourceLabels: Record<TxnSource, string> = {
  [TxnSource.Manual]: 'Manual',
  [TxnSource.EMI]: 'EMI',
  [TxnSource.Recurring]: 'Auto',
};

export const FrequencyLabels: Record<Frequency, string> = {
  [Frequency.Daily]: 'Daily',
  [Frequency.Weekly]: 'Weekly',
  [Frequency.Monthly]: 'Monthly',
  [Frequency.Yearly]: 'Yearly',
};

export const FrequencyUnitLabels: Record<Frequency, string> = {
  [Frequency.Daily]: 'day',
  [Frequency.Weekly]: 'week',
  [Frequency.Monthly]: 'month',
  [Frequency.Yearly]: 'year',
};

export function describeFrequency(interval: number, frequency: Frequency): string {
  if (interval === 1) {
    return FrequencyLabels[frequency];
  }
  return `Every ${interval} ${FrequencyUnitLabels[frequency]}s`;
}

export const LoanTypeLabels: Record<LoanType, string> = {
  [LoanType.Home]: 'Home Loan',
  [LoanType.Car]: 'Car Loan',
  [LoanType.Personal]: 'Personal Loan',
  [LoanType.Education]: 'Education Loan',
  [LoanType.Gold]: 'Gold Loan',
  [LoanType.Business]: 'Business Loan',
  [LoanType.Other]: 'Other Loan',
};

export const AssetTypeLabels: Record<AssetType, string> = {
  [AssetType.FD]: 'Fixed Deposit',
  [AssetType.MutualFund]: 'Mutual Fund',
  [AssetType.Equity]: 'Equity',
  [AssetType.Gold]: 'Gold',
  [AssetType.Cash]: 'Cash',
  [AssetType.Bank]: 'Bank Account',
  [AssetType.RealEstate]: 'Real Estate',
  [AssetType.PPF]: 'PPF',
  [AssetType.Crypto]: 'Crypto',
  [AssetType.Other]: 'Other',
};

export function isMarketLinked(type: AssetType): boolean {
  return [AssetType.Equity, AssetType.MutualFund, AssetType.Gold, AssetType.Crypto].includes(type);
}

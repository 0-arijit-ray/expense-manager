export enum TxnType {
  Expense = 0,
  Income = 1,
}

export enum TxnSource {
  Manual = 0,
  EMI = 1,
  Recurring = 2,
}

export enum Frequency {
  Daily = 0,
  Weekly = 1,
  Monthly = 2,
  Yearly = 3,
}

export enum LoanType {
  Home = 0,
  Car = 1,
  Personal = 2,
  Education = 3,
  Gold = 4,
  Business = 5,
  Other = 6,
}

export enum AssetType {
  FD = 0,
  MutualFund = 1,
  Equity = 2,
  Gold = 3,
  Cash = 4,
  Bank = 5,
  RealEstate = 6,
  PPF = 7,
  Crypto = 8,
  Other = 9,
}

export interface Category {
  id?: number;
  name: string;
  iconCodepoint: number;
  color: number;
  type: TxnType;
  keywords: string;
  isDefault: boolean;
}

export interface Transaction {
  id?: number;
  amount: number;
  title: string;
  note?: string;
  categoryId?: number;
  date: Date;
  type: TxnType;
  source: TxnSource;
  emiId?: number;
  recurringId?: number;
  createdAt: Date;
}

export interface TransactionWithCategory extends Transaction {
  category?: Category;
}

export interface Loan {
  id?: number;
  name: string;
  type: LoanType;
  lender?: string;
  principal: number;
  annualRate: number;
  tenureMonths: number;
  startDate: Date;
  emiAmount: number;
  dueDay: number;
  autoPostExpense: boolean;
  autoDebit: boolean;
  alertsEnabled: boolean;
  alertLeadDays: number;
  closed: boolean;
  createdAt: Date;
}

export interface EmiSchedule {
  id?: number;
  loanId: number;
  installmentNo: number;
  dueDate: Date;
  emiAmount: number;
  principalComponent: number;
  interestComponent: number;
  balance: number;
  paid: boolean;
  paidDate?: Date;
  transactionId?: number;
}

export interface Investment {
  id?: number;
  name: string;
  type: AssetType;
  institution?: string;
  investedAmount: number;
  currentValue: number;
  units?: number;
  annualRate?: number;
  startDate?: Date;
  maturityDate?: Date;
  note?: string;
  updatedAt: Date;
}

export interface RecurringRule {
  id?: number;
  title: string;
  amount: number;
  categoryId?: number;
  type: TxnType;
  frequency: Frequency;
  interval: number;
  nextDueDate: Date;
  endDate?: Date;
  lastPostedDate?: Date;
  active: boolean;
  note?: string;
  createdAt: Date;
}

export interface RecurringWithCategory extends RecurringRule {
  category?: Category;
}

export interface LoanSummary {
  loan: Loan;
  outstanding: number;
  paidCount: number;
  totalCount: number;
  nextDue?: EmiSchedule;
  progress: number;
}

export interface PortfolioSummary {
  invested: number;
  current: number;
  gain: number;
  gainPct: number;
  byType: Map<AssetType, { invested: number; current: number }>;
}

export interface NetWorthData {
  assets: number;
  liabilities: number;
  assetBreakdown: Map<AssetType, number>;
  withLoans: number;
  withoutLoans: number;
}

export interface DashboardData {
  income: number;
  expense: number;
  net: number;
  series: SeriesPoint[];
  byCategory: CategorySlice[];
  txnCount: number;
}

export interface SeriesPoint {
  label: string;
  expense: number;
  income: number;
}

export interface CategorySlice {
  category?: Category;
  total: number;
}

export interface AmortizationRow {
  installmentNo: number;
  dueDate: Date;
  emi: number;
  principal: number;
  interest: number;
  balance: number;
}

export interface AppSettings {
  themeMode: 'system' | 'light' | 'dark';
  currencySymbol: string;
  locale: string;
  ratesEndpoint: string;
}

export interface RateInfo {
  label: string;
  rate: number;
  unit: string;
}

export interface RatesSnapshot {
  rates: RateInfo[];
  isLive: boolean;
}

import Dexie, { type Table } from 'dexie';
import type {
  Category,
  Transaction,
  Loan,
  EmiSchedule,
  Investment,
  RecurringRule,
} from '../types';
import { TxnType } from '../types';

export class ExpenseDatabase extends Dexie {
  categories!: Table<Category, number>;
  transactions!: Table<Transaction, number>;
  loans!: Table<Loan, number>;
  emiSchedules!: Table<EmiSchedule, number>;
  investments!: Table<Investment, number>;
  recurringRules!: Table<RecurringRule, number>;

  constructor() {
    super('expense_manager');
    this.version(1).stores({
      categories: '++id, name, type',
      transactions: '++id, date, categoryId, emiId, recurringId, type, source',
      loans: '++id, type, closed',
      emiSchedules: '++id, loanId, [loanId+paid], dueDate',
      investments: '++id, type, currentValue',
      recurringRules: '++id, active, nextDueDate, [active+nextDueDate]',
    });
  }
}

export const db = new ExpenseDatabase();

export async function seedDefaultCategories() {
  const existing = await db.categories.toArray();
  const existingNames = new Set(existing.map((c) => c.name));

  const defaults: Category[] = [
    { name: 'Food & Dining', iconCodepoint: 0xe571, color: 0xffe57373, type: TxnType.Expense, keywords: 'swiggy,zomato,restaurant,cafe,food,dominos,kfc,mcdonald', isDefault: true },
    { name: 'Groceries', iconCodepoint: 0xe56c, color: 0xff81c784, type: TxnType.Expense, keywords: 'bigbasket,grocery,dmart,reliance fresh,supermarket,blinkit,zepto', isDefault: true },
    { name: 'Transport', iconCodepoint: 0xe531, color: 0xff64b5f6, type: TxnType.Expense, keywords: 'uber,ola,fuel,petrol,diesel,metro,irctc,rapido,fastag', isDefault: true },
    { name: 'Shopping', iconCodepoint: 0xe533, color: 0xffff8a65, type: TxnType.Expense, keywords: 'amazon,flipkart,myntra,ajio,shopping,nykaa', isDefault: true },
    { name: 'Bills & Utilities', iconCodepoint: 0xe0b1, color: 0xffffd54f, type: TxnType.Expense, keywords: 'electricity,water,gas,broadband,recharge,airtel,jio,bill', isDefault: true },
    { name: 'Entertainment', iconCodepoint: 0xe02c, color: 0xffba68c8, type: TxnType.Expense, keywords: 'netflix,prime,hotstar,spotify,bookmyshow,movie', isDefault: true },
    { name: 'Health', iconCodepoint: 0xe548, color: 0xff4dd0e1, type: TxnType.Expense, keywords: 'pharmacy,hospital,apollo,medical,doctor,1mg,pharmeasy', isDefault: true },
    { name: 'Rent', iconCodepoint: 0xe559, color: 0xffa1887f, type: TxnType.Expense, keywords: 'rent,landlord,maintenance', isDefault: true },
    { name: 'EMI & Loans', iconCodepoint: 0xe53f, color: 0xffef5350, type: TxnType.Expense, keywords: 'emi,loan,nbfc', isDefault: true },
    { name: 'Investments', iconCodepoint: 0xe227, color: 0xff66bb6a, type: TxnType.Expense, keywords: 'sip,mutual fund,zerodha,groww,investment,nps', isDefault: true },
    { name: 'Salary', iconCodepoint: 0xe8e5, color: 0xff42a5f5, type: TxnType.Income, keywords: 'salary,credited,paycheck,wages', isDefault: true },
    { name: 'Freelance', iconCodepoint: 0xe058, color: 0xff66bb6a, type: TxnType.Income, keywords: 'freelance,contract,gig,project', isDefault: true },
    { name: 'Interest & Dividends', iconCodepoint: 0xe227, color: 0xff26c6da, type: TxnType.Income, keywords: 'interest,dividend,fds,rd,returns', isDefault: true },
    { name: 'Rental Income', iconCodepoint: 0xe559, color: 0xff8d6e63, type: TxnType.Income, keywords: 'rent,rental,tenant,lease', isDefault: true },
    { name: 'Business Income', iconCodepoint: 0xe7fb, color: 0xff5c6bc0, type: TxnType.Income, keywords: 'business,profit,sales,revenue', isDefault: true },
    { name: 'Gift & Bonus', iconCodepoint: 0xe158, color: 0xffec407a, type: TxnType.Income, keywords: 'gift,bonus,incentive,reward,cashback', isDefault: true },
    { name: 'Refund', iconCodepoint: 0xe5c7, color: 0xffab47bc, type: TxnType.Income, keywords: 'refund,reimburse,cashback,return', isDefault: true },
    { name: 'Transfer', iconCodepoint: 0xe8e9, color: 0xff78909c, type: TxnType.Expense, keywords: 'upi,imps,neft,transfer', isDefault: true },
    { name: 'Others', iconCodepoint: 0xe58d, color: 0xff9e9e9e, type: TxnType.Expense, keywords: '', isDefault: true },
  ];

  const toInsert = defaults.filter((d) => !existingNames.has(d.name));
  if (toInsert.length > 0) {
    await db.categories.bulkAdd(toInsert);
  }
}

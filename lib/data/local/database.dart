import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart' show Icons, IconData;

import 'enums.dart';

part 'database.g.dart';

/// Spending / income categories. Seeded with sensible defaults on first run.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// Material icon codepoint so we can render a glyph.
  IntColumn get iconCodepoint => integer()();

  /// ARGB color value.
  IntColumn get color => integer()();
  IntColumn get type => intEnum<TxnType>().withDefault(const Constant(0))();

  /// Comma separated keywords used to auto-match imported transactions.
  TextColumn get keywords => text().withDefault(const Constant(''))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}

/// Every money movement: manual entries, EMI debits and recurring postings.
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  TextColumn get note => text().nullable()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get date => dateTime()();
  IntColumn get type => intEnum<TxnType>().withDefault(const Constant(0))();
  IntColumn get source => intEnum<TxnSource>().withDefault(const Constant(0))();

  /// When source is emi, links back to the schedule row that created it.
  IntColumn get emiId => integer().nullable()();

  /// When source is recurring, links back to the rule that generated it.
  IntColumn get recurringId => integer().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// A loan / liability that generates an EMI schedule.
class Loans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get type => intEnum<LoanType>()();
  TextColumn get lender => text().nullable()();

  /// Original sanctioned principal.
  RealColumn get principal => real()();

  /// Annual interest rate in percent (e.g. 8.5).
  RealColumn get annualRate => real()();
  IntColumn get tenureMonths => integer()();
  DateTimeColumn get startDate => dateTime()();

  /// Computed EMI amount (stored so it survives rate-table changes).
  RealColumn get emiAmount => real()();

  /// Day of month the EMI is debited (1-28 usually).
  IntColumn get dueDay => integer().withDefault(const Constant(5))();
  BoolColumn get autoPostExpense => boolean().withDefault(const Constant(true))();

  /// When true, EMIs are automatically marked paid once their due date passes.
  BoolColumn get autoDebit => boolean().withDefault(const Constant(false))();
  BoolColumn get alertsEnabled => boolean().withDefault(const Constant(true))();

  /// How many days before due date to fire a reminder.
  IntColumn get alertLeadDays => integer().withDefault(const Constant(2))();
  BoolColumn get closed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// One row per EMI installment in a loan's amortization schedule.
class EmiSchedules extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get loanId =>
      integer().references(Loans, #id, onDelete: KeyAction.cascade)();
  IntColumn get installmentNo => integer()();
  DateTimeColumn get dueDate => dateTime()();
  RealColumn get emiAmount => real()();
  RealColumn get principalComponent => real()();
  RealColumn get interestComponent => real()();

  /// Outstanding balance after this installment.
  RealColumn get balance => real()();
  BoolColumn get paid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get paidDate => dateTime().nullable()();

  /// Links to the transaction row created when the EMI is marked paid.
  IntColumn get transactionId => integer().nullable()();
}

/// Investments and other assets used by the portfolio + net-worth views.
class Investments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get type => intEnum<AssetType>()();
  TextColumn get institution => text().nullable()();
  RealColumn get investedAmount => real()();

  /// Latest valuation. For fixed instruments equals invested + accrued.
  RealColumn get currentValue => real()();

  /// Optional quantity for market-linked holdings (units / grams / shares).
  RealColumn get units => real().nullable()();

  /// Annual rate / expected return in percent.
  RealColumn get annualRate => real().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get maturityDate => dateTime().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// A user-defined recurring income/expense (salary, rent, subscriptions, SIPs).
class RecurringRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 120)();
  RealColumn get amount => real()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id, onDelete: KeyAction.setNull)();
  IntColumn get type => intEnum<TxnType>().withDefault(const Constant(0))();
  IntColumn get frequency => intEnum<Frequency>()();

  /// Every N units of [frequency] (e.g. every 2 weeks).
  IntColumn get interval => integer().withDefault(const Constant(1))();

  /// Next date a transaction should be posted for this rule.
  DateTimeColumn get nextDueDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get lastPostedDate => dateTime().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Categories,
    Transactions,
    Loans,
    EmiSchedules,
    Investments,
    RecurringRules,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _open());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedCategories();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(recurringRules);
            await m.addColumn(loans, loans.autoDebit);
            await m.addColumn(transactions, transactions.recurringId);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _seedCategories() async {
    for (final c in _defaultCategories) {
      await into(categories).insert(c);
    }
  }
}

QueryExecutor _open() => driftDatabase(
      name: 'expense_manager',
      // Web: load the WASM sqlite3 build + drift worker shipped in web/.
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );

/// Seed list. Codepoints reference Material Icons rounded glyphs.
final List<CategoriesCompanion> _defaultCategories = [
  _cat('Food & Dining', Icons.restaurant, 0xFFEF5350, 'swiggy,zomato,restaurant,cafe,food,dominos,kfc,mcdonald'),
  _cat('Groceries', Icons.local_grocery_store, 0xFF66BB6A, 'bigbasket,grocery,dmart,reliance fresh,supermarket,blinkit,zepto'),
  _cat('Transport', Icons.directions_bus, 0xFF42A5F5, 'uber,ola,fuel,petrol,diesel,metro,irctc,rapido,fastag'),
  _cat('Shopping', Icons.shopping_bag, 0xFFAB47BC, 'amazon,flipkart,myntra,ajio,shopping,nykaa'),
  _cat('Bills & Utilities', Icons.receipt_long, 0xFFFFA726, 'electricity,water,gas,broadband,recharge,airtel,jio,bill'),
  _cat('Entertainment', Icons.movie, 0xFFEC407A, 'netflix,prime,hotstar,spotify,bookmyshow,movie'),
  _cat('Health', Icons.local_hospital, 0xFF26A69A, 'pharmacy,hospital,apollo,medical,doctor,1mg,pharmeasy'),
  _cat('Rent', Icons.home, 0xFF8D6E63, 'rent,landlord,maintenance'),
  _cat('EMI & Loans', Icons.account_balance, 0xFF5C6BC0, 'emi,loan,nbfc'),
  _cat('Investments', Icons.trending_up, 0xFF26C6DA, 'sip,mutual fund,zerodha,groww,investment,nps'),
  _cat('Salary', Icons.payments, 0xFF42A5F5, 'salary,credited,paycheck,wages', type: TxnType.income),
  _cat('Freelance', Icons.work_outline, 0xFF66BB6A, 'freelance,contract,gig,project', type: TxnType.income),
  _cat('Interest & Dividends', Icons.trending_up, 0xFF26C6DA, 'interest,dividend,fds,rd,returns', type: TxnType.income),
  _cat('Rental Income', Icons.home_outlined, 0xFF8D6E63, 'rent,rental,tenant,lease', type: TxnType.income),
  _cat('Business Income', Icons.business_center, 0xFF5C6BC0, 'business,profit,sales,revenue', type: TxnType.income),
  _cat('Gift & Bonus', Icons.card_giftcard, 0xFFEC407A, 'gift,bonus,incentive,reward,cashback', type: TxnType.income),
  _cat('Refund', Icons.replay, 0xFFAB47BC, 'refund,reimburse,cashback,return', type: TxnType.income),
  _cat('Transfer', Icons.swap_horiz, 0xFF78909C, 'upi,imps,neft,transfer'),
  _cat('Others', Icons.category, 0xFFBDBDBD, ''),
];

CategoriesCompanion _cat(
  String name,
  IconData icon,
  int color,
  String keywords, {
  TxnType type = TxnType.expense,
}) {
  return CategoriesCompanion.insert(
    name: name,
    iconCodepoint: icon.codePoint,
    color: color,
    keywords: Value(keywords),
    type: Value(type),
    isDefault: const Value(true),
  );
}

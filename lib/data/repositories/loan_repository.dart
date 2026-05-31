import 'package:drift/drift.dart';

import '../../core/finance_math.dart';
import '../local/database.dart';
import '../local/enums.dart';

/// Loan plus rolled-up progress figures.
class LoanSummary {
  final Loan loan;
  final double outstanding;
  final int paidCount;
  final int totalCount;
  final EmiSchedule? nextDue;

  const LoanSummary({
    required this.loan,
    required this.outstanding,
    required this.paidCount,
    required this.totalCount,
    required this.nextDue,
  });

  double get progress => totalCount == 0 ? 0 : paidCount / totalCount;
}

class LoanRepository {
  LoanRepository(this._db);
  final AppDatabase _db;

  Stream<List<Loan>> watchLoans() {
    return (_db.select(_db.loans)
          ..orderBy([(l) => OrderingTerm(expression: l.closed)]))
        .watch();
  }

  Future<Loan> getLoan(int id) =>
      (_db.select(_db.loans)..where((l) => l.id.equals(id))).getSingle();

  Stream<List<EmiSchedule>> watchSchedule(int loanId) {
    return (_db.select(_db.emiSchedules)
          ..where((e) => e.loanId.equals(loanId))
          ..orderBy([(e) => OrderingTerm(expression: e.installmentNo)]))
        .watch();
  }

  /// Creates a loan and its full amortization schedule atomically.
  Future<int> createLoan({
    required String name,
    required LoanType type,
    String? lender,
    required double principal,
    required double annualRate,
    required int tenureMonths,
    required DateTime startDate,
    required int dueDay,
    required bool autoPostExpense,
    required bool autoDebit,
    required bool alertsEnabled,
    required int alertLeadDays,
  }) async {
    final emi = FinanceMath.emi(
      principal: principal,
      annualRatePct: annualRate,
      tenureMonths: tenureMonths,
    );
    return _db.transaction(() async {
      final loanId = await _db.into(_db.loans).insert(LoansCompanion.insert(
            name: name,
            type: type,
            lender: Value(lender),
            principal: principal,
            annualRate: annualRate,
            tenureMonths: tenureMonths,
            startDate: startDate,
            emiAmount: emi,
            dueDay: Value(dueDay),
            autoPostExpense: Value(autoPostExpense),
            autoDebit: Value(autoDebit),
            alertsEnabled: Value(alertsEnabled),
            alertLeadDays: Value(alertLeadDays),
          ));
      final rows = FinanceMath.schedule(
        principal: principal,
        annualRatePct: annualRate,
        tenureMonths: tenureMonths,
        startDate: startDate,
        dueDay: dueDay,
      );
      await _db.batch((b) {
        b.insertAll(
          _db.emiSchedules,
          rows.map((r) => EmiSchedulesCompanion.insert(
                loanId: loanId,
                installmentNo: r.installmentNo,
                dueDate: r.dueDate,
                emiAmount: r.emi,
                principalComponent: r.principal,
                interestComponent: r.interest,
                balance: r.balance,
              )),
        );
      });
      return loanId;
    });
  }

  Future<void> deleteLoan(int id) async {
    await (_db.delete(_db.loans)..where((l) => l.id.equals(id))).go();
  }

  Future<void> setClosed(int id, bool closed) async {
    await (_db.update(_db.loans)..where((l) => l.id.equals(id)))
        .write(LoansCompanion(closed: Value(closed)));
  }

  /// Marks an EMI paid and (optionally) posts a matching expense transaction.
  Future<void> markEmiPaid(EmiSchedule emi, Loan loan,
      {DateTime? paidDate}) async {
    await _db.transaction(() async {
      int? txnId;
      if (loan.autoPostExpense) {
        final emiCat = await (_db.select(_db.categories)
              ..where((c) => c.name.equals('EMI & Loans')))
            .getSingleOrNull();
        txnId = await _db.into(_db.transactions).insert(
              TransactionsCompanion.insert(
                amount: emi.emiAmount,
                title: '${loan.name} EMI #${emi.installmentNo}',
                date: paidDate ?? DateTime.now(),
                categoryId: Value(emiCat?.id),
                type: const Value(TxnType.expense),
                source: const Value(TxnSource.emi),
                emiId: Value(emi.id),
              ),
            );
      }
      await (_db.update(_db.emiSchedules)..where((e) => e.id.equals(emi.id)))
          .write(EmiSchedulesCompanion(
        paid: const Value(true),
        paidDate: Value(paidDate ?? DateTime.now()),
        transactionId: Value(txnId),
      ));
    });
  }

  /// Auto-marks paid every past-due, unpaid EMI on loans that opted into
  /// auto-debit. Returns the number of EMIs processed.
  Future<int> autoProcessDueEmis(DateTime now) async {
    final today = DateTime(now.year, now.month, now.day);
    final loans = await (_db.select(_db.loans)
          ..where((l) => l.autoDebit.equals(true) & l.closed.equals(false)))
        .get();
    var processed = 0;
    for (final loan in loans) {
      final due = await (_db.select(_db.emiSchedules)
            ..where((e) =>
                e.loanId.equals(loan.id) &
                e.paid.equals(false) &
                e.dueDate.isSmallerOrEqualValue(
                    DateTime(today.year, today.month, today.day, 23, 59)))
            ..orderBy([(e) => OrderingTerm.asc(e.installmentNo)]))
          .get();
      for (final emi in due) {
        await markEmiPaid(emi, loan, paidDate: emi.dueDate);
        processed++;
      }
    }
    return processed;
  }

  Future<void> markEmiUnpaid(EmiSchedule emi) async {
    await _db.transaction(() async {
      if (emi.transactionId != null) {
        await (_db.delete(_db.transactions)
              ..where((t) => t.id.equals(emi.transactionId!)))
            .go();
      }
      await (_db.update(_db.emiSchedules)..where((e) => e.id.equals(emi.id)))
          .write(const EmiSchedulesCompanion(
        paid: Value(false),
        paidDate: Value(null),
        transactionId: Value(null),
      ));
    });
  }

  Future<List<LoanSummary>> summaries() async {
    final loans = await _db.select(_db.loans).get();
    final result = <LoanSummary>[];
    for (final loan in loans) {
      final schedule = await (_db.select(_db.emiSchedules)
            ..where((e) => e.loanId.equals(loan.id))
            ..orderBy([(e) => OrderingTerm(expression: e.installmentNo)]))
          .get();
      final paid = schedule.where((e) => e.paid).toList();
      final unpaid = schedule.where((e) => !e.paid).toList();
      result.add(LoanSummary(
        loan: loan,
        outstanding: _outstandingBalance(schedule),
        paidCount: paid.length,
        totalCount: schedule.length,
        nextDue: unpaid.isNotEmpty ? unpaid.first : null,
      ));
    }
    return result;
  }

  /// Outstanding = balance after the last paid installment (or full principal).
  double _outstandingBalance(List<EmiSchedule> schedule) {
    final unpaid = schedule.where((e) => !e.paid).toList();
    if (unpaid.isEmpty) return 0;
    // Balance before paying the next unpaid installment.
    return unpaid.first.balance + unpaid.first.principalComponent;
  }

  /// All upcoming unpaid EMIs across loans within [days].
  Future<List<({EmiSchedule emi, Loan loan})>> upcoming({int days = 45}) async {
    final until = DateTime.now().add(Duration(days: days));
    final rows = await (_db.select(_db.emiSchedules).join([
      innerJoin(_db.loans, _db.loans.id.equalsExp(_db.emiSchedules.loanId)),
    ])
          ..where(_db.emiSchedules.paid.equals(false) &
              _db.emiSchedules.dueDate.isSmallerOrEqualValue(until) &
              _db.loans.closed.equals(false))
          ..orderBy([OrderingTerm.asc(_db.emiSchedules.dueDate)]))
        .get();
    return rows
        .map((r) => (
              emi: r.readTable(_db.emiSchedules),
              loan: r.readTable(_db.loans),
            ))
        .toList();
  }
}

import 'dart:math' as math;

/// A single computed installment in an amortization schedule.
class AmortizationRow {
  final int installmentNo;
  final DateTime dueDate;
  final double emi;
  final double principal;
  final double interest;
  final double balance;

  const AmortizationRow({
    required this.installmentNo,
    required this.dueDate,
    required this.emi,
    required this.principal,
    required this.interest,
    required this.balance,
  });
}

class FinanceMath {
  /// Standard reducing-balance EMI.
  /// EMI = P * r * (1+r)^n / ((1+r)^n - 1), r = monthly rate.
  static double emi({
    required double principal,
    required double annualRatePct,
    required int tenureMonths,
  }) {
    if (tenureMonths <= 0) return 0;
    final r = annualRatePct / 12 / 100;
    if (r == 0) return principal / tenureMonths;
    final pow = math.pow(1 + r, tenureMonths);
    return principal * r * pow / (pow - 1);
  }

  /// Total interest paid over the full tenure.
  static double totalInterest({
    required double principal,
    required double annualRatePct,
    required int tenureMonths,
  }) {
    final e = emi(
      principal: principal,
      annualRatePct: annualRatePct,
      tenureMonths: tenureMonths,
    );
    return (e * tenureMonths) - principal;
  }

  /// Builds a full reducing-balance schedule with due dates anchored to [dueDay].
  static List<AmortizationRow> schedule({
    required double principal,
    required double annualRatePct,
    required int tenureMonths,
    required DateTime startDate,
    required int dueDay,
  }) {
    final rows = <AmortizationRow>[];
    final r = annualRatePct / 12 / 100;
    final e = emi(
      principal: principal,
      annualRatePct: annualRatePct,
      tenureMonths: tenureMonths,
    );
    var balance = principal;
    for (var i = 1; i <= tenureMonths; i++) {
      final interest = balance * r;
      var principalPart = e - interest;
      // Last installment: clear any rounding residue.
      if (i == tenureMonths || principalPart > balance) {
        principalPart = balance;
      }
      balance = math.max(0, balance - principalPart);
      rows.add(AmortizationRow(
        installmentNo: i,
        dueDate: _dueDateFor(startDate, i, dueDay),
        emi: i == tenureMonths ? principalPart + interest : e,
        principal: principalPart,
        interest: interest,
        balance: balance,
      ));
    }
    return rows;
  }

  static DateTime _dueDateFor(DateTime start, int monthOffset, int dueDay) {
    final base = DateTime(start.year, start.month + monthOffset, 1);
    final lastDay = DateTime(base.year, base.month + 1, 0).day;
    return DateTime(base.year, base.month, math.min(dueDay, lastDay));
  }

  /// Future value of a recurring SIP (annuity due not assumed; ordinary).
  static double sipFutureValue({
    required double monthly,
    required double annualRatePct,
    required int months,
  }) {
    final r = annualRatePct / 12 / 100;
    if (r == 0) return monthly * months;
    return monthly * ((math.pow(1 + r, months) - 1) / r) * (1 + r);
  }

  /// Maturity of a lump-sum at compound interest (annual compounding).
  static double compoundMaturity({
    required double principal,
    required double annualRatePct,
    required double years,
  }) {
    return principal * math.pow(1 + annualRatePct / 100, years);
  }
}

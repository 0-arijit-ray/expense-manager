import 'package:expense_manager/core/finance_math.dart';
import 'package:expense_manager/core/recurrence.dart';
import 'package:expense_manager/data/local/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FinanceMath', () {
    test('EMI matches standard reducing-balance formula', () {
      // 10L @ 8.5% for 240 months ≈ 8678/month.
      final emi = FinanceMath.emi(
        principal: 1000000,
        annualRatePct: 8.5,
        tenureMonths: 240,
      );
      expect(emi, closeTo(8678, 5));
    });

    test('zero interest splits principal evenly', () {
      final emi = FinanceMath.emi(
        principal: 12000,
        annualRatePct: 0,
        tenureMonths: 12,
      );
      expect(emi, closeTo(1000, 0.01));
    });

    test('schedule clears balance to zero on the final installment', () {
      final rows = FinanceMath.schedule(
        principal: 500000,
        annualRatePct: 9,
        tenureMonths: 36,
        startDate: DateTime(2025, 1, 1),
        dueDay: 5,
      );
      expect(rows, hasLength(36));
      expect(rows.last.balance, closeTo(0, 0.5));
    });
  });

  group('Recurrence', () {
    test('monthly advances by one month keeping the day', () {
      final next = Recurrence.next(DateTime(2026, 1, 15), Frequency.monthly, 1);
      expect(next, DateTime(2026, 2, 15));
    });

    test('monthly clamps to month length', () {
      final next = Recurrence.next(DateTime(2026, 1, 31), Frequency.monthly, 1);
      expect(next, DateTime(2026, 2, 28));
    });

    test('weekly with interval', () {
      final next = Recurrence.next(DateTime(2026, 1, 1), Frequency.weekly, 2);
      expect(next, DateTime(2026, 1, 15));
    });

    test('occurrencesUntil yields each due date inclusively', () {
      final list = Recurrence.occurrencesUntil(
        DateTime(2026, 1, 1),
        DateTime(2026, 3, 1),
        Frequency.monthly,
        1,
      );
      expect(list, hasLength(3)); // Jan 1, Feb 1, Mar 1
    });
  });
}

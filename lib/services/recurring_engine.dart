import '../data/repositories/loan_repository.dart';
import '../data/repositories/recurring_repository.dart';

/// Catches up automated postings: recurring income/expense rules and
/// auto-debit loan EMIs. Idempotent and safe to call on every app launch.
class RecurringEngine {
  RecurringEngine(this._recurring, this._loans);
  final RecurringRepository _recurring;
  final LoanRepository _loans;

  /// Returns the number of transactions/EMIs posted.
  Future<int> run({DateTime? now}) async {
    final ts = now ?? DateTime.now();
    final rules = await _recurring.processAll(ts);
    final emis = await _loans.autoProcessDueEmis(ts);
    return rules + emis;
  }
}

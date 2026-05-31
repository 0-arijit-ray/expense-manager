import 'package:drift/drift.dart';

import '../../core/recurrence.dart';
import '../local/database.dart';
import '../local/enums.dart';

/// A recurring rule joined with its category.
class RecurringWithCategory {
  final RecurringRule rule;
  final Category? category;
  const RecurringWithCategory(this.rule, this.category);
}

class RecurringRepository {
  RecurringRepository(this._db);
  final AppDatabase _db;

  Stream<List<RecurringWithCategory>> watchRules() {
    final query = _db.select(_db.recurringRules).join([
      leftOuterJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.recurringRules.categoryId),
      ),
    ])
      ..orderBy([OrderingTerm.asc(_db.recurringRules.nextDueDate)]);
    return query.watch().map((rows) => rows
        .map((r) => RecurringWithCategory(
              r.readTable(_db.recurringRules),
              r.readTableOrNull(_db.categories),
            ))
        .toList());
  }

  Future<int> upsert(RecurringRulesCompanion rule) =>
      _db.into(_db.recurringRules).insertOnConflictUpdate(rule);

  Future<void> delete(int id) =>
      (_db.delete(_db.recurringRules)..where((r) => r.id.equals(id))).go();

  Future<void> setActive(int id, bool active) {
    return (_db.update(_db.recurringRules)..where((r) => r.id.equals(id)))
        .write(RecurringRulesCompanion(active: Value(active)));
  }

  /// Posts any transactions a single rule owes up to [now] and advances its
  /// next due date. Returns the number of transactions created.
  Future<int> processRule(RecurringRule rule, DateTime now) async {
    if (!rule.active) return 0;
    final today = DateTime(now.year, now.month, now.day);
    var due = rule.nextDueDate;
    var posted = 0;

    return _db.transaction(() async {
      while (!DateTime(due.year, due.month, due.day).isAfter(today)) {
        if (rule.endDate != null && due.isAfter(rule.endDate!)) break;
        if (posted > 800) break; // safety valve

        final ruleId = rule.id;
        await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
              amount: rule.amount,
              title: rule.title,
              date: due,
              categoryId: Value(rule.categoryId),
              type: Value(rule.type),
              source: const Value(TxnSource.recurring),
              recurringId: Value(ruleId),
              note: Value(rule.note),
            ));
        posted++;
        final advanced = Recurrence.next(due, rule.frequency, rule.interval);
        await (_db.update(_db.recurringRules)..where((r) => r.id.equals(ruleId)))
            .write(RecurringRulesCompanion(
          nextDueDate: Value(advanced),
          lastPostedDate: Value(due),
        ));
        due = advanced;
        if (rule.endDate != null && advanced.isAfter(rule.endDate!)) {
          await (_db.update(_db.recurringRules)
                ..where((r) => r.id.equals(ruleId)))
              .write(const RecurringRulesCompanion(active: Value(false)));
          break;
        }
      }
      return posted;
    });
  }

  /// Processes all active rules. Returns total transactions created.
  Future<int> processAll(DateTime now) async {
    final rules = await (_db.select(_db.recurringRules)
          ..where((r) => r.active.equals(true)))
        .get();
    var total = 0;
    for (final rule in rules) {
      total += await processRule(rule, now);
    }
    return total;
  }
}

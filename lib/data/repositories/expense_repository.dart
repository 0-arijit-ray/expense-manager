import 'package:drift/drift.dart';

import '../local/database.dart';
import '../local/enums.dart';

/// A transaction joined with its (optional) category.
class TransactionWithCategory {
  final Transaction txn;
  final Category? category;
  const TransactionWithCategory(this.txn, this.category);
}

/// Aggregated total for a category over a period.
class CategoryTotal {
  final Category? category;
  final double total;
  const CategoryTotal(this.category, this.total);
}

class ExpenseRepository {
  ExpenseRepository(this._db);
  final AppDatabase _db;

  // ---- Categories -------------------------------------------------------
  Stream<List<Category>> watchCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .watch();
  }

  Future<List<Category>> allCategories() => _db.select(_db.categories).get();

  Future<int> addCategory(CategoriesCompanion c) =>
      _db.into(_db.categories).insert(c);

  // ---- Transactions -----------------------------------------------------
  Stream<List<TransactionWithCategory>> watchTransactions({
    DateTime? from,
    DateTime? to,
    int limit = 500,
  }) {
    final query = _db.select(_db.transactions).join([
      leftOuterJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.transactions.categoryId),
      ),
    ]);
    if (from != null) {
      query.where(_db.transactions.date.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where(_db.transactions.date.isSmallerThanValue(to));
    }
    query
      ..orderBy([OrderingTerm.desc(_db.transactions.date)])
      ..limit(limit);
    return query.watch().map((rows) {
      return rows
          .map((r) => TransactionWithCategory(
                r.readTable(_db.transactions),
                r.readTableOrNull(_db.categories),
              ))
          .toList();
    });
  }

  Future<int> upsertTransaction(TransactionsCompanion txn) {
    return _db.into(_db.transactions).insertOnConflictUpdate(txn);
  }

  Future<void> deleteTransaction(int id) {
    return (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  // ---- Aggregations -----------------------------------------------------
  /// Net total (income positive, expense negative) within range.
  Stream<double> watchNet(DateTime from, DateTime to) {
    return watchTransactions(from: from, to: to).map((rows) {
      var net = 0.0;
      for (final r in rows) {
        net += r.txn.type == TxnType.income ? r.txn.amount : -r.txn.amount;
      }
      return net;
    });
  }

  /// Sum of a single type within range.
  Future<double> sumByType(DateTime from, DateTime to, TxnType type) async {
    final amount = _db.transactions.amount.sum();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([amount])
      ..where(_db.transactions.date.isBiggerOrEqualValue(from) &
          _db.transactions.date.isSmallerThanValue(to) &
          _db.transactions.type.equalsValue(type));
    final row = await query.getSingle();
    return row.read(amount) ?? 0;
  }
}

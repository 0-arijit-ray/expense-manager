import 'package:drift/drift.dart';

import '../local/database.dart';

class InvestmentRepository {
  InvestmentRepository(this._db);
  final AppDatabase _db;

  Stream<List<Investment>> watchInvestments() {
    return (_db.select(_db.investments)
          ..orderBy([(i) => OrderingTerm.desc(i.currentValue)]))
        .watch();
  }

  Future<List<Investment>> all() => _db.select(_db.investments).get();

  Future<int> upsert(InvestmentsCompanion inv) =>
      _db.into(_db.investments).insertOnConflictUpdate(inv);

  Future<void> delete(int id) =>
      (_db.delete(_db.investments)..where((i) => i.id.equals(id))).go();

  Future<void> updateValue(int id, double currentValue) {
    return (_db.update(_db.investments)..where((i) => i.id.equals(id))).write(
      InvestmentsCompanion(
        currentValue: Value(currentValue),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

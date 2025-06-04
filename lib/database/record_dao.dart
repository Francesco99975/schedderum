import 'package:drift/drift.dart';
import 'database.dart';

part 'record_dao.g.dart';

@DriftAccessor(tables: [Records])
class RecordDao extends DatabaseAccessor<AppDatabase> with _$RecordDaoMixin {
  RecordDao(super.db);

  Future<List<Record>> getAllRecords() => select(records).get();
  Future<List<Record>> getRecordsInRange(DateTime from, DateTime to) {
    return (select(records)
          ..where((r) => r.start.isBiggerOrEqualValue(from))
          ..where((r) => r.end.isSmallerOrEqualValue(to)))
        .get();
  }

  Stream<List<Record>> watchRecordsByEmployee(String employeeId) =>
      (select(records)..where((r) => r.employeeId.equals(employeeId))).watch();
  Future<void> insertRecord(Record record) => into(records).insert(record);
  Future<void> updateRecord(Record record) => update(records).replace(record);
  Future<void> deleteRecord(String id) =>
      (delete(records)..where((r) => r.id.equals(id))).go();
}

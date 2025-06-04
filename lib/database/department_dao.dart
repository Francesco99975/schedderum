import 'package:drift/drift.dart';
import 'database.dart';

part 'department_dao.g.dart';

@DriftAccessor(tables: [Departments])
class DepartmentDao extends DatabaseAccessor<AppDatabase>
    with _$DepartmentDaoMixin {
  DepartmentDao(super.db);

  Future<List<Department>> getAllDepartments() => select(departments).get();
  Stream<List<Department>> watchAllDepartments() => select(departments).watch();
  Future<void> insertDepartment(Department department) =>
      into(departments).insert(department);
  Future<void> updateDepartment(Department department) =>
      update(departments).replace(department);
  Future<void> deleteDepartment(String id) =>
      (delete(departments)..where((tbl) => tbl.id.equals(id))).go();
}

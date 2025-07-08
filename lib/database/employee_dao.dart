import 'package:drift/drift.dart';
import 'database.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [Employees, Records])
class EmployeeDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  Future<List<Employee>> getAllEmployees() => select(employees).get();
  Future<List<Employee>> getEmployeesByDepartment(String departmentId) {
    return (select(employees)
      ..where((e) => e.departmentId.equals(departmentId))).get();
  }

  Stream<List<Employee>> watchEmployeesByDepartment(String departmentId) =>
      (select(employees)
        ..where((e) => e.departmentId.equals(departmentId))).watch();
  Future<void> insertEmployee(Employee employee) =>
      into(employees).insert(employee);
  Future<void> updateEmployee(Employee employee) =>
      update(employees).replace(employee);
  Future<void> deleteEmployee(String id) {
    (delete(employees)..where((e) => e.id.equals(id))).go();
    (delete(records)..where((r) => r.employeeId.equals(id))).go();
    return Future.value(null);
  }
}

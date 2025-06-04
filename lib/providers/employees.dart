import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';
import 'package:schedderum/extensions/database.dart';
import 'package:schedderum/database/database.dart';
import 'package:schedderum/models/employee.dart' as model;
import 'package:schedderum/models/record.dart' as model;
import 'database.dart';

part 'employees.g.dart';

@riverpod
class Employees extends _$Employees {
  @override
  Future<Either<Failure, List<model.Employee>>> build() => _fetchEmployees();

  Future<Either<Failure, List<model.Employee>>> _fetchEmployees() async {
    try {
      final db = ref.read(databaseProvider);
      final empDao = db.employeeDao;
      final recDao = db.recordDao;

      final rawEmps = await empDao.getAllEmployees();
      final rawRecs = await recDao.getAllRecords();

      final groupedRecs = <String, List<model.Record>>{};
      for (final r in rawRecs) {
        final recordModel = r.toModel();
        groupedRecs.putIfAbsent(r.employeeId, () => []).add(recordModel);
      }

      final result =
          rawEmps.map((e) => e.toModel(groupedRecs[e.id] ?? [])).toList();

      return Right(result);
    } catch (e) {
      return Left(Failure(message: "Failed to load employees: $e"));
    }
  }

  Future<Either<Failure, Employee>> addEmployee(Employee employee) async {
    try {
      final dao = ref.read(databaseProvider).employeeDao;
      await dao.insertEmployee(employee);
      final updated = await _fetchEmployees();
      state = AsyncValue.data(updated);
      return Right(employee);
    } catch (e) {
      return Left(Failure(message: "Insert failed: $e"));
    }
  }

  Future<Either<Failure, Employee>> updateEmployee(Employee employee) async {
    try {
      final dao = ref.read(databaseProvider).employeeDao;
      await dao.updateEmployee(employee);
      final updated = await _fetchEmployees();
      state = AsyncValue.data(updated);
      return Right(employee);
    } catch (e) {
      return Left(Failure(message: "Update failed: $e"));
    }
  }

  Future<Either<Failure, String>> removeEmployee(Employee employee) async {
    try {
      final dao = ref.read(databaseProvider).employeeDao;
      await dao.deleteEmployee(employee.id);
      final updated = await _fetchEmployees();
      state = AsyncValue.data(updated);
      return Right(employee.id);
    } catch (e) {
      return Left(Failure(message: "Delete failed: $e"));
    }
  }

  Future<Either<Failure, List<model.Employee>>> employeesByDepartment(
    String departmentId,
  ) async {
    try {
      final db = ref.read(databaseProvider);
      final empDao = db.employeeDao;
      final recDao = db.recordDao;

      final rawEmps = await empDao.getEmployeesByDepartment(departmentId);
      final rawRecs = await recDao.getAllRecords();

      final groupedRecs = <String, List<model.Record>>{};
      for (final r in rawRecs) {
        final recordModel = r.toModel();
        groupedRecs.putIfAbsent(r.employeeId, () => []).add(recordModel);
      }

      final result =
          rawEmps.map((e) => e.toModel(groupedRecs[e.id] ?? [])).toList();

      return Right(result);
    } catch (e) {
      return Left(Failure(message: "Query failed: $e"));
    }
  }
}

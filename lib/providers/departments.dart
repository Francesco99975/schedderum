import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/database/database.dart';
import 'package:schedderum/extensions/database.dart';
import 'package:schedderum/models/department.dart' as model;
import 'package:schedderum/models/employee.dart' as model;
import 'package:schedderum/helpers/failure.dart';
import 'package:schedderum/providers/preferences_provider.dart';
import 'package:schedderum/util/preferences_service.dart';
import 'database.dart';

part 'departments.g.dart';

@riverpod
class CurrentDepartment extends _$CurrentDepartment {
  static const _kActiveDeptKey = 'active_department_id';
  @override
  Future<Option<model.Department>> build() async {
    final instance = await ref.read(sharedPreferencesProvider.future);
    final prefs = PreferencesService(instance);
    final idResult = prefs.getString(_kActiveDeptKey);

    final depts = await ref.watch(departmentsProvider.future);
    return depts.match((l) => none(), (depts) {
      return idResult.match(
        (err) => optionOf(depts.firstOrNull),
        (storedId) => depts.where((d) => d.id == storedId).head,
      );
    });
  }

  Future<void> setCurrent(String departmentId) async {
    final instance = await ref.read(sharedPreferencesProvider.future);
    final prefs = PreferencesService(instance);
    await prefs.setString(_kActiveDeptKey, departmentId);

    final result = await ref.watch(departmentsProvider.future);

    result.match((l) => state = AsyncData(none()), (depts) {
      state = AsyncData(depts.where((d) => d.id == departmentId).head);
    });
  }
}

@riverpod
class Departments extends _$Departments {
  // Option<model.Department> _current = none();

  @override
  Future<Either<Failure, List<model.Department>>> build() async {
    final result = await _fetchDepartments();

    return result;
  }

  /// Shared logic for building full `Department` model list from DB.
  Future<Either<Failure, List<model.Department>>> _fetchDepartments() async {
    try {
      final db = ref.read(databaseProvider);

      final deptDao = db.departmentDao;
      final empDao = db.employeeDao;
      final recDao = db.recordDao;

      final rawDepts = await deptDao.getAllDepartments();
      final rawEmps = await empDao.getAllEmployees();
      final rawRecs = await recDao.getAllRecords();

      final groupedEmps = <String, List<model.Employee>>{};
      for (final e in rawEmps) {
        final records =
            rawRecs
                .where((r) => r.employeeId == e.id)
                .map((r) => r.toModel())
                .toList();

        final employeeModel = e.toModel(records);
        groupedEmps.putIfAbsent(e.departmentId, () => []).add(employeeModel);
      }

      final result =
          rawDepts.map((d) => d.toModel(groupedEmps[d.id] ?? [])).toList();

      if (result.isEmpty) {
        return Left(Failure(message: 'No departments found'));
      }

      return Right(result);
    } catch (e) {
      return Left(Failure(message: 'Failed to load departments: $e'));
    }
  }

  Future<Either<Failure, Department>> addDepartment(Department d) async {
    try {
      final dao = ref.read(databaseProvider).departmentDao;
      await dao.insertDepartment(d);
      final updated = await _fetchDepartments();
      state = AsyncValue.data(updated);
      return Right(d);
    } catch (e) {
      return Left(Failure(message: "Insert failed: $e"));
    }
  }

  Future<Either<Failure, Department>> updateDepartment(Department d) async {
    try {
      final dao = ref.read(databaseProvider).departmentDao;
      await dao.updateDepartment(d);
      final updated = await _fetchDepartments();

      state = AsyncValue.data(updated);
      return Right(d);
    } catch (e) {
      return Left(Failure(message: "Update failed: $e"));
    }
  }

  Future<Either<Failure, Department>> removeDepartment(Department d) async {
    try {
      final dao = ref.read(databaseProvider).departmentDao;
      await dao.deleteDepartment(d.id);
      final updated = await _fetchDepartments();
      state = AsyncValue.data(updated);
      return Right(d);
    } catch (e) {
      return Left(Failure(message: "Delete failed: $e"));
    }
  }
}

final dbDepartmentsProvider = FutureProvider((ref) async {
  final db = ref.watch(databaseProvider);
  return db.departmentDao.getAllDepartments();
});

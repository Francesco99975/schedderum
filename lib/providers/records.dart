import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';
import 'package:schedderum/extensions/database.dart';
import 'package:schedderum/models/display_record.dart';
import 'package:schedderum/database/database.dart' as db;
import 'package:schedderum/models/record.dart';
import 'package:schedderum/providers/settings_provider.dart';
import 'package:schedderum/util/formatters.dart';
import 'database.dart';

part 'records.g.dart';

@riverpod
class Records extends _$Records {
  @override
  Future<Either<Failure, List<DisplayRecord>>> build(
    String departmentId,
    DateTime weekStart,
    DateTime weekEnd,
  ) async => _fetchRecords(departmentId, weekStart, weekEnd);

  Future<Either<Failure, List<DisplayRecord>>> _fetchRecords(
    String departmentId,
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    try {
      final db = ref.read(databaseProvider);
      final empDao = db.employeeDao;
      final recDao = db.recordDao;

      final rawEmps = await empDao.getEmployeesByDepartment(departmentId);
      final rawRecs = await recDao.getAllRecords();

      final employeeMap = {for (final e in rawEmps) e.id: e.toModel([])};

      final displayRecords = <DisplayRecord>[];

      for (final r in rawRecs) {
        if (r.start.isBefore(weekStart) ||
            r.end.isAfter(weekEnd.add(Duration(days: 1)))) {
          continue;
        }

        final emp = employeeMap[r.employeeId];
        if (emp == null) continue;

        displayRecords.add(
          DisplayRecord(
            record: r.toModel(),
            employeeFullName: emp.getFullName(),
            employeeColor: emp.color,
            employeeId: emp.id,
          ),
        );
      }

      return Right(displayRecords);
    } catch (e) {
      return Left(Failure(message: "Failed to load records: $e"));
    }
  }

  bool _checkSameEmployeeRecordInterception(db.Record r) {
    return state.when(
      data:
          (data) => data.match(
            (failure) => false,
            (records) => records.any(
              (dr) =>
                  dr.employeeId == r.employeeId &&
                  dr.record.start.isBefore(r.end) &&
                  dr.record.end.isAfter(r.start),
            ),
          ),
      error: (_, _) => false,
      loading: () => false,
    );
  }

  Future<Either<Failure, db.Record>> addRecord(
    db.Record r,
    String departmentId,
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    try {
      if (_checkSameEmployeeRecordInterception(r)) {
        return Left(Failure(message: "Same employee record interception"));
      }

      final dao = ref.read(databaseProvider).recordDao;
      await dao.insertRecord(r);
      final updated = await _fetchRecords(departmentId, weekStart, weekEnd);
      state = AsyncValue.data(updated);
      return Right(r);
    } catch (e) {
      return Left(Failure(message: "Insert failed: $e"));
    }
  }

  Future<Either<Failure, db.Record>> updateRecord(
    db.Record r,
    String departmentId,
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    try {
      final dao = ref.read(databaseProvider).recordDao;
      await dao.updateRecord(r);
      final updated = await _fetchRecords(departmentId, weekStart, weekEnd);
      state = AsyncValue.data(updated);
      return Right(r);
    } catch (e) {
      return Left(Failure(message: "Update failed: $e"));
    }
  }

  Future<Either<Failure, db.Record>> removeRecord(
    db.Record r,
    String departmentId,
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    try {
      final dao = ref.read(databaseProvider).recordDao;
      await dao.deleteRecord(r.id);
      final updated = await _fetchRecords(departmentId, weekStart, weekEnd);
      state = AsyncValue.data(updated);
      return Right(r);
    } catch (e) {
      return Left(Failure(message: "Delete failed: $e"));
    }
  }
}

@riverpod
Option<Duration> currentDepartmentWeekHours(
  Ref ref,
  String departmentId,
  DateTime weekStart,
  DateTime weekEnd,
) {
  final result = ref.watch(recordsProvider(departmentId, weekStart, weekEnd));
  final settingsAsync = ref.watch(settingsProvider);

  return settingsAsync.maybeWhen(
    data:
        (settings) => result.maybeWhen(
          data:
              (either) => either.match((failure) => none(), (records) {
                final total = records.fold<Duration>(
                  Duration.zero,
                  (prev, r) =>
                      r.record.type == RecordType.SHIFT
                          ? prev +
                              regulatedDuration(
                                r.record.duration,
                                settings.breakFrequencyHours,
                                settings.breakDurationHours,
                              )
                          : prev,
                );
                return Some(total);
              }),
          orElse: () => none(),
        ),
    orElse: () => none(),
  );
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';
import 'package:schedderum/extensions/database.dart';
import 'package:schedderum/models/record.dart' as model;
import 'package:schedderum/database/database.dart' as db;
import 'database.dart';

part 'records.g.dart';

@riverpod
class Records extends _$Records {
  @override
  Future<Either<Failure, List<model.Record>>> build() => _fetchRecords();

  Future<Either<Failure, List<model.Record>>> _fetchRecords() async {
    try {
      final dao = ref.read(databaseProvider).recordDao;
      final records = await dao.getAllRecords();
      final result = records.map((r) => r.toModel()).toList();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: "Failed to load records: $e"));
    }
  }

  Future<Either<Failure, db.Record>> addRecord(db.Record r) async {
    try {
      final dao = ref.read(databaseProvider).recordDao;
      await dao.insertRecord(r);
      final updated = await _fetchRecords();
      state = AsyncValue.data(updated);
      return Right(r);
    } catch (e) {
      return Left(Failure(message: "Insert failed: $e"));
    }
  }

  Future<Either<Failure, db.Record>> updateRecord(db.Record r) async {
    try {
      final dao = ref.read(databaseProvider).recordDao;
      await dao.updateRecord(r);
      final updated = await _fetchRecords();
      state = AsyncValue.data(updated);
      return Right(r);
    } catch (e) {
      return Left(Failure(message: "Update failed: $e"));
    }
  }

  Future<Either<Failure, db.Record>> removeRecord(db.Record r) async {
    try {
      final dao = ref.read(databaseProvider).recordDao;
      await dao.deleteRecord(r.id);
      final updated = await _fetchRecords();
      state = AsyncValue.data(updated);
      return Right(r);
    } catch (e) {
      return Left(Failure(message: "Delete failed: $e"));
    }
  }

  Future<Either<Failure, List<model.Record>>> getRecordsInRange(
    DateTime from,
    DateTime to,
  ) async {
    try {
      final dao = ref.read(databaseProvider).recordDao;
      final result = await dao.getRecordsInRange(from, to);
      return Right(result.map((r) => r.toModel()).toList());
    } catch (e) {
      return Left(Failure(message: "Get in range failed: $e"));
    }
  }
}

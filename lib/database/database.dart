import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'department_dao.dart';
import 'employee_dao.dart';
import 'record_dao.dart';

part 'database.g.dart';

class Departments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Employees extends Table {
  TextColumn get id => text()();
  TextColumn get firstname => text()();
  TextColumn get middlename => text()();
  TextColumn get lastname => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  IntColumn get priority => integer()();
  BoolColumn get isManager => boolean()();
  IntColumn get color => integer()();
  TextColumn get departmentId => text().references(Departments, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

class Records extends Table {
  TextColumn get id => text()();
  DateTimeColumn get start => dateTime()();
  DateTimeColumn get end => dateTime()();
  TextColumn get type => text()(); // Store enum as string
  TextColumn get employeeId => text().references(Employees, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [Departments, Employees, Records],
  daos: [DepartmentDao, EmployeeDao, RecordDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}

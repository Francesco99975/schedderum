import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' as universal;

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
    final Directory dbFolder;

    if (universal.Platform.isAndroid || universal.Platform.isIOS) {
      dbFolder = await getApplicationDocumentsDirectory();
    } else if (universal.Platform.isMacOS) {
      dbFolder = await getLibraryDirectory();
    } else if (universal.Platform.isLinux || universal.Platform.isWindows) {
      final home =
          universal.Platform.environment['HOME'] ??
          universal.Platform.environment['USERPROFILE'];

      if (home == null) {
        throw UnsupportedError(
          'No HOME or USERPROFILE environment variable found',
        );
      }

      dbFolder = Directory(p.join(home, '.schedderum'));
      await dbFolder.create(recursive: true);
    } else {
      throw UnsupportedError(
        "Unsupported platform: ${universal.Platform.operatingSystem}",
      );
    }

    final file = File(p.join(dbFolder.path, 'schedderum.db'));
    debugPrint('Database located at: ${file.path}');
    return NativeDatabase(file);
  });
}

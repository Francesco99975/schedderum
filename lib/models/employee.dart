import 'package:fpdart/fpdart.dart';
import 'package:schedderum/extensions/strings.dart';
import 'package:schedderum/database/database.dart' as db;
import 'package:schedderum/models/record.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'employee.freezed.dart';
part 'employee.g.dart'; // for JSON serialization

@freezed
@JsonSerializable()
class Employee with _$Employee {
  const Employee({
    required this.id,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.priority,
    required this.isManager,
    required this.color,
    required this.records,
  });

  @override
  final String id;
  @override
  final String firstname;
  @override
  final String middlename;
  @override
  final String lastname;
  @override
  final String email;
  @override
  final String phone;
  @override
  final int priority;
  @override
  final bool isManager;
  @override
  final int color;
  @override
  final List<Record> records;

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, Object?> toJson() => _$EmployeeToJson(this);

  String getFullName() {
    if (middlename.isEmpty) {
      return '${firstname.capitalize()} ${lastname.capitalize()}';
    }
    return '${firstname.capitalize()} ${middlename[0].toUpperCase()}. ${lastname.capitalize()}';
  }

  Duration getRangedDuration(DateTime from, DateTime to) {
    Duration duration = Duration();
    for (var record in records) {
      if (record.start.isAfter(from) && record.end.isBefore(to)) {
        duration += record.end.difference(record.start);
      }
    }
    return duration;
  }

  String weekStatus(DateTime from, DateTime to) {
    final weekRecords =
        records
            .where((r) => r.start.isAfter(from) && r.end.isBefore(to))
            .toList();

    final weekShifts =
        weekRecords.filter((r) => r.type == RecordType.SHIFT).length;

    if (weekRecords.any((r) => r.type == RecordType.VACATION)) {
      return 'On Vacation';
    } else if (weekShifts > 0) {
      return 'Working $weekShifts shifts';
    } else {
      return 'Not Working';
    }
  }

  db.Employee toDbModel(String deptId) {
    return db.Employee(
      id: id,
      firstname: firstname,
      middlename: middlename,
      lastname: lastname,
      email: email,
      phone: phone,
      priority: priority,
      isManager: isManager,
      color: color,
      departmentId: deptId,
    );
  }
}

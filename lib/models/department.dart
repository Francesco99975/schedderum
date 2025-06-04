import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedderum/database/database.dart' as db;
import 'package:schedderum/models/employee.dart';
part 'department.freezed.dart';
part 'department.g.dart'; // for JSON serialization

@freezed
@JsonSerializable()
class Department with _$Department {
  const Department({
    required this.id,
    required this.name,
    required this.employees,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final List<Employee> employees;

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, Object?> toJson() => _$DepartmentToJson(this);

  Duration getRangedDuration(DateTime from, DateTime to) {
    Duration duration = Duration();
    for (var employee in employees) {
      for (var record in employee.records) {
        if (record.start.isAfter(from) && record.end.isBefore(to)) {
          duration += record.end.difference(record.start);
        }
      }
    }
    return duration;
  }

  db.Department toDbModel() {
    return db.Department(id: id, name: name);
  }
}

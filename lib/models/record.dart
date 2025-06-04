import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedderum/database/database.dart' as db;
part 'record.freezed.dart';
part 'record.g.dart'; // for JSON serialization

// ignore: constant_identifier_names
enum RecordType { SHIFT, SICK, UNAVAILABLE, VACATION }

@freezed
@JsonSerializable()
class Record with _$Record {
  const Record({
    required this.id,
    required this.start,
    required this.end,
    required this.type,
  });

  @override
  final String id;
  @override
  final DateTime start;
  @override
  final DateTime end;
  @override
  final RecordType type;

  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  Map<String, Object?> toJson() => _$RecordToJson(this);

  // create a function to get the duration of the record
  Duration get duration => end.difference(start);

  db.Record toDbModel(String empId) => db.Record(
    id: id,
    start: start,
    end: end,
    type: type.toString(),
    employeeId: empId,
  );
}

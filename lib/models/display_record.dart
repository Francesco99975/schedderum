import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedderum/models/record.dart';

part 'display_record.freezed.dart';
part 'display_record.g.dart';

@freezed
@JsonSerializable()
class DisplayRecord with _$DisplayRecord {
  const DisplayRecord({
    required this.record,
    required this.employeeFullName,
    required this.employeeColor,
    required this.employeeId,
  });

  @override
  final Record record;
  @override
  final String employeeFullName;
  @override
  final int employeeColor;
  @override
  final String employeeId;

  factory DisplayRecord.fromJson(Map<String, dynamic> json) =>
      _$DisplayRecordFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayRecordToJson(this);
}

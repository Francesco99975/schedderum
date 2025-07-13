// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayRecord _$DisplayRecordFromJson(Map<String, dynamic> json) =>
    DisplayRecord(
      record: Record.fromJson(json['record'] as Map<String, dynamic>),
      employeeFullName: json['employeeFullName'] as String,
      employeeColor: (json['employeeColor'] as num).toInt(),
      employeeId: json['employeeId'] as String,
    );

Map<String, dynamic> _$DisplayRecordToJson(DisplayRecord instance) =>
    <String, dynamic>{
      'record': instance.record,
      'employeeFullName': instance.employeeFullName,
      'employeeColor': instance.employeeColor,
      'employeeId': instance.employeeId,
    };

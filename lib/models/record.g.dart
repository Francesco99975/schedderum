// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Record _$RecordFromJson(Map<String, dynamic> json) => Record(
  id: json['id'] as String,
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  type: $enumDecode(_$RecordTypeEnumMap, json['type']),
);

Map<String, dynamic> _$RecordToJson(Record instance) => <String, dynamic>{
  'id': instance.id,
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'type': _$RecordTypeEnumMap[instance.type]!,
};

const _$RecordTypeEnumMap = {
  RecordType.SHIFT: 'SHIFT',
  RecordType.SICK: 'SICK',
  RecordType.UNAVAILABLE: 'UNAVAILABLE',
  RecordType.VACATION: 'VACATION',
  RecordType.TIME_OFF: 'TIME_OFF',
};

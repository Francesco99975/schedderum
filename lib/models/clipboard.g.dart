// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clipboard _$ClipboardFromJson(Map<String, dynamic> json) => Clipboard(
  maybeMemoDisplayRecord: Option<DisplayRecord>.fromJson(
    json['maybeMemoDisplayRecord'],
    (value) => DisplayRecord.fromJson(value as Map<String, dynamic>),
  ),
  maybeMemoStart: Option<DateTime>.fromJson(
    json['maybeMemoStart'],
    (value) => DateTime.parse(value as String),
  ),
  maybeMemoEnd: Option<DateTime>.fromJson(
    json['maybeMemoEnd'],
    (value) => DateTime.parse(value as String),
  ),
);

Map<String, dynamic> _$ClipboardToJson(Clipboard instance) => <String, dynamic>{
  'maybeMemoDisplayRecord': instance.maybeMemoDisplayRecord.toJson(
    (value) => value,
  ),
  'maybeMemoStart': instance.maybeMemoStart.toJson(
    (value) => value.toIso8601String(),
  ),
  'maybeMemoEnd': instance.maybeMemoEnd.toJson(
    (value) => value.toIso8601String(),
  ),
};

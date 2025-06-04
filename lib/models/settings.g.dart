// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  darkMode: json['darkMode'] as bool,
  useMilitaryTime: json['useMilitaryTime'] as bool,
  breakFrequencyHours: (json['breakFrequencyHours'] as num).toDouble(),
  breakDurationHours: (json['breakDurationHours'] as num).toDouble(),
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'darkMode': instance.darkMode,
  'useMilitaryTime': instance.useMilitaryTime,
  'breakFrequencyHours': instance.breakFrequencyHours,
  'breakDurationHours': instance.breakDurationHours,
};

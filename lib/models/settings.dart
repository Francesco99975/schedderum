import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
@JsonSerializable()
class Settings with _$Settings {
  const Settings({
    required this.darkMode,
    required this.useMilitaryTime,
    required this.breakFrequencyHours,
    required this.breakDurationHours,
  });

  @override
  final bool darkMode;
  @override
  final bool useMilitaryTime;
  @override
  final double breakFrequencyHours;
  @override
  final double breakDurationHours;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, Object?> toJson() => _$SettingsToJson(this);
}

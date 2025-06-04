// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settings {

 bool get darkMode; bool get useMilitaryTime; double get breakFrequencyHours; double get breakDurationHours;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.darkMode, darkMode) || other.darkMode == darkMode)&&(identical(other.useMilitaryTime, useMilitaryTime) || other.useMilitaryTime == useMilitaryTime)&&(identical(other.breakFrequencyHours, breakFrequencyHours) || other.breakFrequencyHours == breakFrequencyHours)&&(identical(other.breakDurationHours, breakDurationHours) || other.breakDurationHours == breakDurationHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,darkMode,useMilitaryTime,breakFrequencyHours,breakDurationHours);

@override
String toString() {
  return 'Settings(darkMode: $darkMode, useMilitaryTime: $useMilitaryTime, breakFrequencyHours: $breakFrequencyHours, breakDurationHours: $breakDurationHours)';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 bool darkMode, bool useMilitaryTime, double breakFrequencyHours, double breakDurationHours
});




}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? darkMode = null,Object? useMilitaryTime = null,Object? breakFrequencyHours = null,Object? breakDurationHours = null,}) {
  return _then(Settings(
darkMode: null == darkMode ? _self.darkMode : darkMode // ignore: cast_nullable_to_non_nullable
as bool,useMilitaryTime: null == useMilitaryTime ? _self.useMilitaryTime : useMilitaryTime // ignore: cast_nullable_to_non_nullable
as bool,breakFrequencyHours: null == breakFrequencyHours ? _self.breakFrequencyHours : breakFrequencyHours // ignore: cast_nullable_to_non_nullable
as double,breakDurationHours: null == breakDurationHours ? _self.breakDurationHours : breakDurationHours // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


// dart format on

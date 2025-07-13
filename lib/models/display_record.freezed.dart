// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'display_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DisplayRecord {

 Record get record; String get employeeFullName; int get employeeColor; String get employeeId;
/// Create a copy of DisplayRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisplayRecordCopyWith<DisplayRecord> get copyWith => _$DisplayRecordCopyWithImpl<DisplayRecord>(this as DisplayRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisplayRecord&&(identical(other.record, record) || other.record == record)&&(identical(other.employeeFullName, employeeFullName) || other.employeeFullName == employeeFullName)&&(identical(other.employeeColor, employeeColor) || other.employeeColor == employeeColor)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,record,employeeFullName,employeeColor,employeeId);

@override
String toString() {
  return 'DisplayRecord(record: $record, employeeFullName: $employeeFullName, employeeColor: $employeeColor, employeeId: $employeeId)';
}


}

/// @nodoc
abstract mixin class $DisplayRecordCopyWith<$Res>  {
  factory $DisplayRecordCopyWith(DisplayRecord value, $Res Function(DisplayRecord) _then) = _$DisplayRecordCopyWithImpl;
@useResult
$Res call({
 Record record, String employeeFullName, int employeeColor, String employeeId
});




}
/// @nodoc
class _$DisplayRecordCopyWithImpl<$Res>
    implements $DisplayRecordCopyWith<$Res> {
  _$DisplayRecordCopyWithImpl(this._self, this._then);

  final DisplayRecord _self;
  final $Res Function(DisplayRecord) _then;

/// Create a copy of DisplayRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? record = null,Object? employeeFullName = null,Object? employeeColor = null,Object? employeeId = null,}) {
  return _then(DisplayRecord(
record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as Record,employeeFullName: null == employeeFullName ? _self.employeeFullName : employeeFullName // ignore: cast_nullable_to_non_nullable
as String,employeeColor: null == employeeColor ? _self.employeeColor : employeeColor // ignore: cast_nullable_to_non_nullable
as int,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DisplayRecord].
extension DisplayRecordPatterns on DisplayRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on

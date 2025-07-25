// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clipboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Clipboard {

 Option<DisplayRecord> get maybeMemoDisplayRecord; Option<DateTime> get maybeMemoStart; Option<DateTime> get maybeMemoEnd;
/// Create a copy of Clipboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipboardCopyWith<Clipboard> get copyWith => _$ClipboardCopyWithImpl<Clipboard>(this as Clipboard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Clipboard&&(identical(other.maybeMemoDisplayRecord, maybeMemoDisplayRecord) || other.maybeMemoDisplayRecord == maybeMemoDisplayRecord)&&(identical(other.maybeMemoStart, maybeMemoStart) || other.maybeMemoStart == maybeMemoStart)&&(identical(other.maybeMemoEnd, maybeMemoEnd) || other.maybeMemoEnd == maybeMemoEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maybeMemoDisplayRecord,maybeMemoStart,maybeMemoEnd);

@override
String toString() {
  return 'Clipboard(maybeMemoDisplayRecord: $maybeMemoDisplayRecord, maybeMemoStart: $maybeMemoStart, maybeMemoEnd: $maybeMemoEnd)';
}


}

/// @nodoc
abstract mixin class $ClipboardCopyWith<$Res>  {
  factory $ClipboardCopyWith(Clipboard value, $Res Function(Clipboard) _then) = _$ClipboardCopyWithImpl;
@useResult
$Res call({
 Option<DisplayRecord> maybeMemoDisplayRecord, Option<DateTime> maybeMemoStart, Option<DateTime> maybeMemoEnd
});




}
/// @nodoc
class _$ClipboardCopyWithImpl<$Res>
    implements $ClipboardCopyWith<$Res> {
  _$ClipboardCopyWithImpl(this._self, this._then);

  final Clipboard _self;
  final $Res Function(Clipboard) _then;

/// Create a copy of Clipboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maybeMemoDisplayRecord = null,Object? maybeMemoStart = null,Object? maybeMemoEnd = null,}) {
  return _then(Clipboard(
maybeMemoDisplayRecord: null == maybeMemoDisplayRecord ? _self.maybeMemoDisplayRecord : maybeMemoDisplayRecord // ignore: cast_nullable_to_non_nullable
as Option<DisplayRecord>,maybeMemoStart: null == maybeMemoStart ? _self.maybeMemoStart : maybeMemoStart // ignore: cast_nullable_to_non_nullable
as Option<DateTime>,maybeMemoEnd: null == maybeMemoEnd ? _self.maybeMemoEnd : maybeMemoEnd // ignore: cast_nullable_to_non_nullable
as Option<DateTime>,
  ));
}

}


/// Adds pattern-matching-related methods to [Clipboard].
extension ClipboardPatterns on Clipboard {
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

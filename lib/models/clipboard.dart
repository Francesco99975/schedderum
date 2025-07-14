import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedderum/models/display_record.dart';

part 'clipboard.freezed.dart';
part 'clipboard.g.dart';

@freezed
@JsonSerializable()
class Clipboard with _$Clipboard {
  const Clipboard({
    required this.maybeMemoDisplayRecord,
    required this.maybeMemoStart,
    required this.maybeMemoEnd,
  });

  @override
  final Option<DisplayRecord> maybeMemoDisplayRecord;
  @override
  final Option<DateTime> maybeMemoStart;
  @override
  final Option<DateTime> maybeMemoEnd;

  factory Clipboard.fromJson(Map<String, dynamic> json) =>
      _$ClipboardFromJson(json);

  Map<String, Object?> toJson() => _$ClipboardToJson(this);
}

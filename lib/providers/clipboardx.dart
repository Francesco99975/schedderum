import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:schedderum/models/clipboard.dart';
import 'package:schedderum/models/display_record.dart';

part 'clipboardx.g.dart';

@Riverpod(keepAlive: true)
class Clipboardx extends _$Clipboardx {
  @override
  Clipboard build() => const Clipboard(
    maybeMemoDisplayRecord: None(),
    maybeMemoStart: None(),
    maybeMemoEnd: None(),
  );

  void copyDisplayRecord(DisplayRecord displayRecord) {
    state = state.copyWith(maybeMemoDisplayRecord: Some(displayRecord));
  }

  void copyShift(DateTime start, DateTime end) {
    state = state.copyWith(
      maybeMemoStart: Some(start),
      maybeMemoEnd: Some(end),
    );
  }
}

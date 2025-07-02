import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:schedderum/providers/preferences_provider.dart';

part 'week_context_provider.g.dart';

const _kCurrentWeekKey = 'current_week_start';

DateTime startOfWeek(DateTime date) {
  final base = date.subtract(Duration(days: date.weekday - DateTime.monday));
  return DateTime(base.year, base.month, base.day); // zeroed time
}

DateTime endOfWeek(DateTime date) {
  final base = startOfWeek(date).add(const Duration(days: 6));
  return DateTime(base.year, base.month, base.day); // zeroed time
}

@riverpod
class WeekContext extends _$WeekContext {
  @override
  FutureOr<DateTime> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final saved = prefs.getString(_kCurrentWeekKey);

    if (saved != null) {
      final parsed = DateTime.tryParse(saved);
      if (parsed != null) return startOfWeek(parsed);
    }

    return startOfWeek(DateTime.now());
  }

  Future<void> _persist(DateTime weekStart) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_kCurrentWeekKey, weekStart.toIso8601String());
  }

  Future<void> setWeek(DateTime anyDayInWeek) async {
    final newStart = startOfWeek(anyDayInWeek);
    if (state.valueOrNull == newStart) return;
    state = AsyncValue.data(newStart);
    await _persist(newStart);
  }

  Future<void> resetToCurrentWeek() async {
    await setWeek(DateTime.now());
  }

  Future<void> nextWeek() async {
    final current = await future;
    await setWeek(current.add(const Duration(days: 7)));
  }

  Future<void> previousWeek() async {
    final current = await future;
    await setWeek(current.subtract(const Duration(days: 7)));
  }

  bool get isCurrentWeek {
    final current = startOfWeek(DateTime.now());
    return state.valueOrNull == current;
  }
}

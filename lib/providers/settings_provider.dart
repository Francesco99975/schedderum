import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/settings.dart';
import 'package:schedderum/util/formatters.dart' as formatters;
import 'package:schedderum/util/settings_notifier.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);

final activeDateFormatterProvider = Provider((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.when(
    data:
        (settings) =>
            settings.useMilitaryTime
                ? formatters.militaryTimeFormatter
                : formatters.timeFormatter,
    error: (error, stack) => formatters.timeFormatter,
    loading: () => formatters.timeFormatter,
  );
});

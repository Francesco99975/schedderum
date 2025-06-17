import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/settings.dart';
import 'package:schedderum/util/settings_notifier.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);

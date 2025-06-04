import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/settings.dart';
import 'package:schedderum/providers/preferences_provider.dart';
import 'package:schedderum/util/settings_notifier.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((
  ref,
) {
  final prefs = ref.watch(preferencesServiceProvider);
  final notifier = SettingsNotifier(prefs);
  notifier.load(); // Load async settings after construction
  return notifier;
});

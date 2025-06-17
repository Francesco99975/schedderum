import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/settings.dart';
import 'package:schedderum/providers/preferences_provider.dart';
import 'package:schedderum/providers/theme_provider.dart';
import 'package:schedderum/util/preferences_service.dart';

class SettingsNotifier extends AsyncNotifier<Settings> {
  static const _kKey = 'app_settings';
  late final PreferencesService _prefs;

  // No constructor parameters; dependencies are fetched via ref
  SettingsNotifier();

  @override
  Future<Settings> build() async {
    // Fetch SharedPreferences asynchronously and initialize _prefs
    final sharedPrefs = await ref.read(sharedPreferencesProvider.future);
    _prefs = PreferencesService(sharedPrefs);

    // Load settings from storage
    final jsonStr = _prefs.getString(_kKey);

    return jsonStr.match(
      (l) {
        return _loadDefaults();
      },
      (jsonStr) {
        try {
          final map = Map<String, dynamic>.from(jsonDecode(jsonStr));
          return Settings.fromJson(map);
        } catch (e) {
          // Fallback to defaults if loading fails
          return _loadDefaults();
        }
      },
    );
  }

  // Static method for default settings
  static Settings _loadDefaults() => const Settings(
    darkMode: true,
    useMilitaryTime: false,
    breakFrequencyHours: 6.0,
    breakDurationHours: 0.5,
  );

  // Save settings, taking the new Settings object as a parameter
  Future<void> _save(Settings settings) async {
    final encoded = jsonEncode(settings.toJson());
    await _prefs.setString(_kKey, encoded);
  }

  Future<void> toggleDarkMode(bool value) async {
    final currentSettings = state.value ?? _loadDefaults();
    final newSettings = currentSettings.copyWith(darkMode: value);
    ref.read(themexProvider.notifier).toggle();
    state = AsyncData(newSettings);
    await _save(newSettings);
  }

  Future<void> setMilitaryTime(bool value) async {
    final currentSettings = state.value ?? _loadDefaults();
    final newSettings = currentSettings.copyWith(useMilitaryTime: value);
    state = AsyncData(newSettings);
    await _save(newSettings);
  }

  Future<void> setBreakFrequency(double hours) async {
    final currentSettings = state.value ?? _loadDefaults();
    final newSettings = currentSettings.copyWith(breakFrequencyHours: hours);
    state = AsyncData(newSettings);
    await _save(newSettings);
  }

  Future<void> setBreakDuration(double hours) async {
    final currentSettings = state.value ?? _loadDefaults();
    final newSettings = currentSettings.copyWith(breakDurationHours: hours);
    state = AsyncData(newSettings);
    await _save(newSettings);
  }
}

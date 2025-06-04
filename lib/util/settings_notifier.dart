import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedderum/models/settings.dart';
import 'package:schedderum/util/preferences_service.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  static const _kKey = 'app_settings';
  final PreferencesService _prefs;

  SettingsNotifier(this._prefs) : super(_loadDefaults());

  static Settings _loadDefaults() => const Settings(
    darkMode: true,
    useMilitaryTime: false,
    breakFrequencyHours: 6.0,
    breakDurationHours: 0.5,
  );

  Future<void> load() async {
    final jsonStr = _prefs.getString(_kKey);
    jsonStr.match(
      (_) => {}, // Use default
      (jsonString) {
        try {
          final map = Map<String, dynamic>.from(
            jsonDecode(jsonString) as Map<String, dynamic>,
          );
          state = Settings.fromJson(map);
        } catch (_) {}
      },
    );
  }

  Future<void> _save() async {
    final encoded = jsonEncode(state.toJson());
    await _prefs.setString(_kKey, encoded);
  }

  Future<void> toggleDarkMode(bool value) async {
    state = state.copyWith(darkMode: value);
    await _save();
  }

  Future<void> setMilitaryTime(bool value) async {
    state = state.copyWith(useMilitaryTime: value);
    await _save();
  }

  Future<void> setBreakFrequency(double hours) async {
    state = state.copyWith(breakFrequencyHours: hours);
    await _save();
  }

  Future<void> setBreakDuration(double hours) async {
    state = state.copyWith(breakDurationHours: hours);
    await _save();
  }
}

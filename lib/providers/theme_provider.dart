import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:schedderum/models/app_theme.dart';
import 'package:schedderum/providers/settings_provider.dart';

part 'theme_provider.g.dart';

@riverpod
class Themex extends _$Themex {
  @override
  AppTheme build() {
    final settings = ref.watch(settingsProvider);

    return settings.when(
      data: (settings) {
        debugPrint('Dark mode: ${settings.darkMode}');
        if (settings.darkMode) {
          return AppTheme(current: AppTheme.dark, isDark: true);
        } else {
          return AppTheme(current: AppTheme.light, isDark: false);
        }
      },
      error: (error, stack) => AppTheme(current: AppTheme.dark, isDark: false),
      loading: () {
        debugPrint('Theme loading');
        return AppTheme(current: AppTheme.dark, isDark: false);
      },
    );
  }

  void toggle() {
    if (state.isDark) {
      state = AppTheme(current: AppTheme.light, isDark: false);
    } else {
      state = AppTheme(current: AppTheme.dark, isDark: true);
    }
  }
}

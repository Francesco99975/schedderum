import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:schedderum/models/app_theme.dart';

part 'theme_provider.g.dart';

@riverpod
class Themex extends _$Themex {
  @override
  AppTheme build() {
    return AppTheme(current: AppTheme.dark, isDark: true);
  }

  void toggle() {
    if (state.isDark) {
      state = AppTheme(current: AppTheme.light, isDark: false);
    } else {
      state = AppTheme(current: AppTheme.dark, isDark: true);
    }
  }
}

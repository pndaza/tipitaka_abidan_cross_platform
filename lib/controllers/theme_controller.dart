import 'package:flutter/material.dart';

import '../data/shared_pref_client.dart';

class ThemeController {
  late final ValueNotifier<ThemeMode> _themeMode =
      ValueNotifier(ThemeMode.values[SharedPreferenceClient.themeModeIndex]);
  ValueNotifier<ThemeMode> get themeMode => _themeMode;

  void toggle() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }
    _persist(_themeMode.value);
  }

  void onChangedThemeMode(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    _persist(_themeMode.value);
  }

  void _persist(ThemeMode themeMode) {
    SharedPreferenceClient.themeModeIndex = themeMode.index;
  }
}

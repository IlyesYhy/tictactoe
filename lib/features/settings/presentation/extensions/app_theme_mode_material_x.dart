import 'package:flutter/material.dart';

import '../../domain/entities/app_theme_mode.dart';

extension AppThemeModeMaterialX on AppThemeMode {
  ThemeMode toThemeMode() {
    return switch (this) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }
}

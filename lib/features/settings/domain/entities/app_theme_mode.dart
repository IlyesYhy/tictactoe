/// Theme mode preferences the user can pick.
enum AppThemeMode {
  light,
  dark,
  system;

  static AppThemeMode? fromName(String name) {
    return switch (name) {
      'light' => AppThemeMode.light,
      'dark' => AppThemeMode.dark,
      'system' => AppThemeMode.system,
      _ => null,
    };
  }
}

import '../entities/app_language.dart';
import '../entities/app_theme_mode.dart';

/// Persistent storage contract for user preferences.
abstract interface class SettingsRepository {
  Future<AppLanguage?> getLanguage();
  Future<AppThemeMode?> getThemeMode();
  Future<bool?> getHapticFeedback();

  Future<void> saveLanguage(AppLanguage language);
  Future<void> saveThemeMode(AppThemeMode themeMode);
  Future<void> saveHapticFeedback(bool enabled);
}

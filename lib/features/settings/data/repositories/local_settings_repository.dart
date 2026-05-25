import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_theme_mode.dart';
import '../../domain/repositories/settings_repository.dart';

final class LocalSettingsRepository implements SettingsRepository {
  const LocalSettingsRepository(this._preferences);

  final SharedPreferences _preferences;

  static const _languageKey = 'settings.language';
  static const _themeModeKey = 'settings.theme_mode';

  @override
  Future<AppLanguage?> getLanguage() async {
    final code = _preferences.getString(_languageKey);
    return code == null ? null : AppLanguage.fromCode(code);
  }

  @override
  Future<AppThemeMode?> getThemeMode() async {
    final name = _preferences.getString(_themeModeKey);
    return name == null ? null : AppThemeMode.fromName(name);
  }

  @override
  Future<void> saveLanguage(AppLanguage language) async {
    await _preferences.setString(_languageKey, language.code);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) async {
    await _preferences.setString(_themeModeKey, themeMode.name);
  }
}

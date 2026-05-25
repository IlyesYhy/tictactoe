import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/settings_providers.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/app_theme_mode.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

final class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return ref.read(initialSettingsProvider);
  }

  Future<void> selectLanguage(AppLanguage language) async {
    if (state.language == language) return;

    state = state.copyWith(language: language);
    await ref.read(settingsRepositoryProvider).saveLanguage(language);
  }

  Future<void> selectThemeMode(AppThemeMode themeMode) async {
    if (state.themeMode == themeMode) return;

    state = state.copyWith(themeMode: themeMode);
    await ref.read(settingsRepositoryProvider).saveThemeMode(themeMode);
  }
}

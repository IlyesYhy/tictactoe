import 'package:flutter_riverpod/misc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/di/shared_preferences_provider.dart';
import '../../features/settings/data/repositories/local_settings_repository.dart';
import '../../features/settings/di/settings_providers.dart';
import '../../features/settings/domain/entities/app_language.dart';
import '../../features/settings/domain/entities/app_settings.dart';
import '../../features/settings/domain/entities/app_theme_mode.dart';
import '../../features/stats/data/repositories/local_stats_repository.dart';
import '../../features/stats/di/stats_providers.dart';

Future<List<Override>> buildAppOverrides() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  final settingsRepository = LocalSettingsRepository(sharedPreferences);
  final initialSettings = AppSettings(
    language: (await settingsRepository.getLanguage()) ?? AppLanguage.en,
    themeMode: (await settingsRepository.getThemeMode()) ?? AppThemeMode.system,
    isHapticFeedbackEnabled:
        (await settingsRepository.getHapticFeedback()) ?? true,
  );

  final statsRepository = LocalStatsRepository(sharedPreferences);
  final initialMatchHistory = await statsRepository.getMatchHistory();

  final packageInfo = await PackageInfo.fromPlatform();

  return [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    initialSettingsProvider.overrideWithValue(initialSettings),
    initialMatchHistoryProvider.overrideWithValue(initialMatchHistory),
    packageInfoProvider.overrideWithValue(packageInfo),
  ];
}

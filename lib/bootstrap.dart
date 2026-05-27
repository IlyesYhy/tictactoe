import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/di/shared_preferences_provider.dart';
import 'features/settings/data/repositories/local_settings_repository.dart';
import 'features/settings/di/settings_providers.dart';
import 'features/settings/domain/entities/app_language.dart';
import 'features/settings/domain/entities/app_settings.dart';
import 'features/settings/domain/entities/app_theme_mode.dart';
import 'features/stats/data/repositories/local_stats_repository.dart';
import 'features/stats/di/stats_providers.dart';

Future<void> bootstrap() {
  return runZonedGuarded(
        () async {
          WidgetsFlutterBinding.ensureInitialized();

          FlutterError.onError = (details) {
            FlutterError.presentError(details);
          };

          final sharedPreferences = await SharedPreferences.getInstance();

          final settingsRepository = LocalSettingsRepository(sharedPreferences);
          final initialSettings = AppSettings(
            language:
                (await settingsRepository.getLanguage()) ?? AppLanguage.en,
            themeMode:
                (await settingsRepository.getThemeMode()) ??
                AppThemeMode.system,
            isHapticFeedbackEnabled:
                (await settingsRepository.getHapticFeedback()) ?? true,
          );

          final statsRepository = LocalStatsRepository(sharedPreferences);
          final initialMatchHistory = await statsRepository.getMatchHistory();

          final packageInfo = await PackageInfo.fromPlatform();

          runApp(
            ProviderScope(
              overrides: [
                sharedPreferencesProvider.overrideWithValue(sharedPreferences),
                initialSettingsProvider.overrideWithValue(initialSettings),
                initialMatchHistoryProvider.overrideWithValue(
                  initialMatchHistory,
                ),
                packageInfoProvider.overrideWithValue(packageInfo),
              ],
              child: const App(),
            ),
          );
        },
        (error, stackTrace) {
          // In production, errors could be reported to an error tracking service
          // such as Sentry or Firebase Crashlytics.
          debugPrint(error.toString());
        },
      ) ??
      Future<void>.value();
}

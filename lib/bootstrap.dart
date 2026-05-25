import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'features/settings/data/repositories/local_settings_repository.dart';
import 'features/settings/di/settings_providers.dart';
import 'features/settings/domain/entities/app_language.dart';
import 'features/settings/domain/entities/app_settings.dart';
import 'features/settings/domain/entities/app_theme_mode.dart';

Future<void> bootstrap() {
  return runZonedGuarded(
        () async {
          WidgetsFlutterBinding.ensureInitialized();

          FlutterError.onError = (details) {
            FlutterError.presentError(details);
          };

          final sharedPreferences = await SharedPreferences.getInstance();
          final repository = LocalSettingsRepository(sharedPreferences);

          final initialSettings = AppSettings(
            language: (await repository.getLanguage()) ?? AppLanguage.en,
            themeMode: (await repository.getThemeMode()) ?? AppThemeMode.system,
            isHapticFeedbackEnabled:
                (await repository.getHapticFeedback()) ?? true,
          );

          runApp(
            ProviderScope(
              overrides: [
                sharedPreferencesProvider.overrideWithValue(sharedPreferences),
                initialSettingsProvider.overrideWithValue(initialSettings),
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

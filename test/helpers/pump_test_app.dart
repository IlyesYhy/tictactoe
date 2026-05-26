import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/features/settings/di/settings_providers.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_settings.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

extension PumpTestApp on WidgetTester {
  Future<void> pumpTestApp(
    Widget child, {
    Locale locale = const Locale('en'),
    bool wrapWithScaffold = true,
    AppSettings initialSettings = const AppSettings(
      language: AppLanguage.en,
      themeMode: AppThemeMode.system,
    ),
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: [initialSettingsProvider.overrideWithValue(initialSettings)],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: wrapWithScaffold ? Scaffold(body: Center(child: child)) : child,
        ),
      ),
    );
  }
}

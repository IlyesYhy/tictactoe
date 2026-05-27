import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/app.dart';
import 'package:tictactoe/features/settings/di/settings_providers.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_settings.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/stats/di/stats_providers.dart';
import 'package:tictactoe/features/stats/domain/entities/match_history.dart';

void main() {
  Widget appUnderTest({
    AppSettings settings = const AppSettings(
      language: AppLanguage.en,
      themeMode: AppThemeMode.system,
    ),
  }) {
    return ProviderScope(
      overrides: [
        initialSettingsProvider.overrideWithValue(settings),
        initialMatchHistoryProvider.overrideWithValue(MatchHistory.empty()),
      ],
      child: const App(),
    );
  }

  group('App theme mode', () {
    testWidgets('uses dark theme when platform brightness is dark', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(appUnderTest());

      final homeContext = tester.element(find.byType(Scaffold));
      expect(Theme.of(homeContext).brightness, Brightness.dark);
    });

    testWidgets('uses light theme when platform brightness is light', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(appUnderTest());

      final homeContext = tester.element(find.byType(Scaffold));
      expect(Theme.of(homeContext).brightness, Brightness.light);
    });
  });

  group('App locale', () {
    testWidgets('uses English locale from settings', (tester) async {
      await tester.pumpWidget(
        appUnderTest(
          settings: const AppSettings(
            language: AppLanguage.en,
            themeMode: AppThemeMode.system,
          ),
        ),
      );

      expect(find.text('Play against the computer'), findsOneWidget);
    });

    testWidgets('uses French locale from settings', (tester) async {
      await tester.pumpWidget(
        appUnderTest(
          settings: const AppSettings(
            language: AppLanguage.fr,
            themeMode: AppThemeMode.system,
          ),
        ),
      );

      expect(find.text("Jouez contre l'ordinateur"), findsOneWidget);
    });
  });
}

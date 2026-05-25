import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/features/settings/di/settings_providers.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_settings.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictactoe/features/settings/presentation/controllers/settings_controller.dart';
import 'package:tictactoe/features/settings/presentation/pages/settings_page.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  Future<(ProviderContainer, _RecordingSettingsRepository)> pumpSettingsPage(
    WidgetTester tester, {
    AppSettings initial = const AppSettings(
      language: AppLanguage.en,
      themeMode: AppThemeMode.system,
    ),
    Locale locale = const Locale('en'),
  }) async {
    final repository = _RecordingSettingsRepository();
    final container = ProviderContainer(
      overrides: [
        initialSettingsProvider.overrideWithValue(initial),
        settingsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsPage(),
        ),
      ),
    );

    return (container, repository);
  }

  group('SettingsPage', () {
    testWidgets('renders title, both sections and the five radio tiles', (
      tester,
    ) async {
      await pumpSettingsPage(tester);

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);

      final englishTile = tester.widget<RadioListTile<AppLanguage>>(
        find.byKey(const Key('settings_language_en')),
      );
      expect(englishTile.value, AppLanguage.en);

      final frenchTile = tester.widget<RadioListTile<AppLanguage>>(
        find.byKey(const Key('settings_language_fr')),
      );
      expect(frenchTile.value, AppLanguage.fr);

      final lightTile = tester.widget<RadioListTile<AppThemeMode>>(
        find.byKey(const Key('settings_theme_light')),
      );
      expect(lightTile.value, AppThemeMode.light);

      final darkTile = tester.widget<RadioListTile<AppThemeMode>>(
        find.byKey(const Key('settings_theme_dark')),
      );
      expect(darkTile.value, AppThemeMode.dark);

      final systemTile = tester.widget<RadioListTile<AppThemeMode>>(
        find.byKey(const Key('settings_theme_system')),
      );
      expect(systemTile.value, AppThemeMode.system);
    });

    testWidgets('tap on French language radio updates state and persists fr', (
      tester,
    ) async {
      final (container, repository) = await pumpSettingsPage(tester);

      await tester.tap(find.byKey(const Key('settings_language_fr')));
      await tester.pumpAndSettle();

      expect(
        container.read(settingsControllerProvider).language,
        AppLanguage.fr,
      );
      expect(repository.savedLanguages, [AppLanguage.fr]);
    });

    testWidgets('tap on Dark theme radio updates state and persists dark', (
      tester,
    ) async {
      final (container, repository) = await pumpSettingsPage(tester);

      await tester.tap(find.byKey(const Key('settings_theme_dark')));
      await tester.pumpAndSettle();

      expect(
        container.read(settingsControllerProvider).themeMode,
        AppThemeMode.dark,
      );
      expect(repository.savedThemeModes, [AppThemeMode.dark]);
    });

    testWidgets('renders French labels under fr locale', (tester) async {
      await pumpSettingsPage(tester, locale: const Locale('fr'));

      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Langue'), findsOneWidget);
      expect(find.text('Thème'), findsOneWidget);
      expect(find.text('Anglais'), findsOneWidget);
      expect(find.text('Français'), findsOneWidget);
      expect(find.text('Clair'), findsOneWidget);
      expect(find.text('Sombre'), findsOneWidget);
      expect(find.text('Système'), findsOneWidget);
    });
  });
}

final class _RecordingSettingsRepository implements SettingsRepository {
  final savedLanguages = <AppLanguage>[];
  final savedThemeModes = <AppThemeMode>[];

  @override
  Future<AppLanguage?> getLanguage() async => null;

  @override
  Future<AppThemeMode?> getThemeMode() async => null;

  @override
  Future<void> saveLanguage(AppLanguage language) async {
    savedLanguages.add(language);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) async {
    savedThemeModes.add(themeMode);
  }
}

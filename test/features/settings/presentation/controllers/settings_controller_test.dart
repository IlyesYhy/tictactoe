import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/settings/di/settings_providers.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_settings.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/settings/domain/repositories/settings_repository.dart';
import 'package:tictactoe/features/settings/presentation/controllers/settings_controller.dart';

void main() {
  ProviderContainer createContainer({
    AppSettings initial = const AppSettings(
      language: AppLanguage.en,
      themeMode: AppThemeMode.system,
    ),
    _RecordingSettingsRepository? repository,
  }) {
    final repo = repository ?? _RecordingSettingsRepository();
    final container = ProviderContainer(
      overrides: [
        initialSettingsProvider.overrideWithValue(initial),
        settingsRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('SettingsController', () {
    test('build returns the initial settings', () {
      final container = createContainer(
        initial: const AppSettings(
          language: AppLanguage.fr,
          themeMode: AppThemeMode.dark,
        ),
      );

      final state = container.read(settingsControllerProvider);

      expect(state.language, AppLanguage.fr);
      expect(state.themeMode, AppThemeMode.dark);
    });

    test('selectLanguage updates state and persists', () async {
      final repository = _RecordingSettingsRepository();
      final container = createContainer(repository: repository);
      final controller = container.read(settingsControllerProvider.notifier);

      await controller.selectLanguage(AppLanguage.fr);

      expect(
        container.read(settingsControllerProvider).language,
        AppLanguage.fr,
      );
      expect(repository.savedLanguages, [AppLanguage.fr]);
    });

    test('selectLanguage is a no-op when value is unchanged', () async {
      final repository = _RecordingSettingsRepository();
      final container = createContainer(repository: repository);
      final controller = container.read(settingsControllerProvider.notifier);

      await controller.selectLanguage(AppLanguage.en);

      expect(
        container.read(settingsControllerProvider).language,
        AppLanguage.en,
      );
      expect(repository.savedLanguages, isEmpty);
    });

    test('selectThemeMode updates state and persists', () async {
      final repository = _RecordingSettingsRepository();
      final container = createContainer(repository: repository);
      final controller = container.read(settingsControllerProvider.notifier);

      await controller.selectThemeMode(AppThemeMode.dark);

      expect(
        container.read(settingsControllerProvider).themeMode,
        AppThemeMode.dark,
      );
      expect(repository.savedThemeModes, [AppThemeMode.dark]);
    });

    test('selectThemeMode is a no-op when value is unchanged', () async {
      final repository = _RecordingSettingsRepository();
      final container = createContainer(repository: repository);
      final controller = container.read(settingsControllerProvider.notifier);

      await controller.selectThemeMode(AppThemeMode.system);

      expect(
        container.read(settingsControllerProvider).themeMode,
        AppThemeMode.system,
      );
      expect(repository.savedThemeModes, isEmpty);
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

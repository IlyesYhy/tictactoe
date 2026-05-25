import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/features/settings/data/repositories/local_settings_repository.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<LocalSettingsRepository> createRepository([
    Map<String, Object> initialValues = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(initialValues);
    final preferences = await SharedPreferences.getInstance();
    return LocalSettingsRepository(preferences);
  }

  group('LocalSettingsRepository', () {
    test('returns null for both settings on a fresh install', () async {
      final repository = await createRepository();

      expect(await repository.getLanguage(), isNull);
      expect(await repository.getThemeMode(), isNull);
    });

    test('saveLanguage persists and getLanguage reads it back', () async {
      final repository = await createRepository();

      await repository.saveLanguage(AppLanguage.fr);

      expect(await repository.getLanguage(), AppLanguage.fr);
    });

    test('saveThemeMode persists and getThemeMode reads it back', () async {
      final repository = await createRepository();

      await repository.saveThemeMode(AppThemeMode.dark);

      expect(await repository.getThemeMode(), AppThemeMode.dark);
    });

    test('getLanguage returns null for an unknown persisted code', () async {
      final repository = await createRepository({'settings.language': 'de'});

      expect(await repository.getLanguage(), isNull);
    });

    test('getThemeMode returns null for an unknown persisted name', () async {
      final repository = await createRepository({
        'settings.theme_mode': 'unknown',
      });

      expect(await repository.getThemeMode(), isNull);
    });
  });
}

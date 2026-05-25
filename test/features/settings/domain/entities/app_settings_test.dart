import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_settings.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';

void main() {
  group('AppSettings', () {
    const initial = AppSettings(
      language: AppLanguage.en,
      themeMode: AppThemeMode.system,
    );

    test('copyWith updates language only', () {
      final updated = initial.copyWith(language: AppLanguage.fr);

      expect(updated.language, AppLanguage.fr);
      expect(updated.themeMode, AppThemeMode.system);
    });

    test('copyWith updates themeMode only', () {
      final updated = initial.copyWith(themeMode: AppThemeMode.dark);

      expect(updated.language, AppLanguage.en);
      expect(updated.themeMode, AppThemeMode.dark);
    });

    test('considers two states with same fields equal', () {
      const a = AppSettings(
        language: AppLanguage.fr,
        themeMode: AppThemeMode.dark,
      );
      const b = AppSettings(
        language: AppLanguage.fr,
        themeMode: AppThemeMode.dark,
      );

      expect(a, b);
    });

    test('does not consider states with different fields equal', () {
      const base = AppSettings(
        language: AppLanguage.en,
        themeMode: AppThemeMode.system,
      );
      const differentLanguage = AppSettings(
        language: AppLanguage.fr,
        themeMode: AppThemeMode.system,
      );
      const differentThemeMode = AppSettings(
        language: AppLanguage.en,
        themeMode: AppThemeMode.dark,
      );

      expect(base, isNot(differentLanguage));
      expect(base, isNot(differentThemeMode));
    });
  });
}

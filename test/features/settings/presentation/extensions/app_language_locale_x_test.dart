import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/presentation/extensions/app_language_locale_x.dart';

void main() {
  group('AppLanguageLocaleX.toLocale', () {
    test('maps en to Locale(en)', () {
      expect(AppLanguage.en.toLocale(), const Locale('en'));
    });

    test('maps fr to Locale(fr)', () {
      expect(AppLanguage.fr.toLocale(), const Locale('fr'));
    });
  });
}

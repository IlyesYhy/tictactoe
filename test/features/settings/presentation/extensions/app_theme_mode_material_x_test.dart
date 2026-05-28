import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/settings/presentation/extensions/app_theme_mode_material_x.dart';

void main() {
  group('AppThemeModeMaterialX.toThemeMode', () {
    test('maps light to ThemeMode.light', () {
      expect(AppThemeMode.light.toThemeMode(), ThemeMode.light);
    });

    test('maps dark to ThemeMode.dark', () {
      expect(AppThemeMode.dark.toThemeMode(), ThemeMode.dark);
    });

    test('maps system to ThemeMode.system', () {
      expect(AppThemeMode.system.toThemeMode(), ThemeMode.system);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:tictactoe/app/theme/app_text_theme.dart';
import 'package:tictactoe/app/theme/extensions/game_theme_extension.dart';
import 'package:tictactoe/app/theme/extensions/stats_outcome_colors.dart';
import 'package:tictactoe/app/theme/src/app_colors.dart';

abstract final class AppTheme {
  static ColorScheme _colorScheme({
    required Brightness brightness,
    required Color surface,
  }) {
    return ColorScheme.fromSeed(
      seedColor: AppColors.purple,
      brightness: brightness,
      surface: surface,
    ).copyWith(
      primary: AppColors.purple,
      onPrimary: AppColors.onPurple,
      secondary: AppColors.pink,
      onSecondary: AppColors.onPink,
    );
  }

  static ThemeData get light {
    final colorScheme = _colorScheme(
      brightness: Brightness.light,
      surface: AppColors.lightSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      extensions: const [
        GameThemeExtension(
          boardBackgroundColor: AppColors.lightBackground,
          cellBackgroundColor: AppColors.lightSurface,
          cellBorderColor: AppColors.lightCellShadow,
          cellPressedColor: AppColors.lightBackground,
          cellLightShadowColor: AppColors.lightSurface,
          cellDarkShadowColor: AppColors.lightCellShadow,
          xColor: AppColors.purple,
          oColor: AppColors.pink,
          statusBackgroundColor: AppColors.lightSurface,
          statusBorderColor: AppColors.purple,
          statusTextColor: AppColors.lightTextPrimary,
          successColor: AppColors.green,
          dangerColor: AppColors.red,
          disabledColor: AppColors.disabled,
        ),
        StatsOutcomeColors(draw: AppColors.outcomeDraw, defeat: AppColors.red),
      ],
    );
  }

  static ThemeData get dark {
    final colorScheme = _colorScheme(
      brightness: Brightness.dark,
      surface: AppColors.darkSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: AppTextTheme.textTheme.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      extensions: const [
        GameThemeExtension(
          boardBackgroundColor: AppColors.darkBackground,
          cellBackgroundColor: AppColors.darkSurface,
          cellBorderColor: AppColors.darkCellLightShadow,
          cellPressedColor: AppColors.darkCellPressed,
          cellLightShadowColor: AppColors.darkCellLightShadow,
          cellDarkShadowColor: AppColors.darkCellDarkShadow,
          xColor: AppColors.purple,
          oColor: AppColors.pink,
          statusBackgroundColor: AppColors.darkSurface,
          statusBorderColor: AppColors.purple,
          statusTextColor: AppColors.darkTextPrimary,
          successColor: AppColors.green,
          dangerColor: AppColors.red,
          disabledColor: AppColors.disabled,
        ),
        StatsOutcomeColors(draw: AppColors.outcomeDraw, defeat: AppColors.red),
      ],
    );
  }
}

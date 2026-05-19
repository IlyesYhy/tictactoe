import 'package:flutter/material.dart';
import 'package:tictactoe/app/theme/app_colors.dart';
import 'package:tictactoe/app/theme/app_text_theme.dart';

abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTextTheme.textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll<double>(0),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabled;
            }
            return AppColors.primary;
          }),
          foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

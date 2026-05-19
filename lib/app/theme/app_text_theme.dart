import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextTheme {
  static const textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.textPrimary),
  );
}

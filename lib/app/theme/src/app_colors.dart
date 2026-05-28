import 'package:flutter/material.dart';

/// [AppColors] is an internal design-system palette and should only
/// be used inside `lib/app/theme/`.
///
/// Feature widgets must consume colors through [ThemeData],
/// [ColorScheme], or dedicated [ThemeExtension]s.
///
/// Note: If the project codebase grows, this rule can be enforced
/// with a custom lint rule.
abstract final class AppColors {
  static const darkBackground = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Color(0xFF94A3B8);

  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Colors.white;
  static const lightTextPrimary = Color(0xFF0F172A);
  static const lightTextSecondary = Color(0xFF64748B);

  static const purple = Color(0xFF7C3AED);
  static const onPurple = Colors.white;
  static const pink = Color(0xFFF43F5E);
  static const onPink = Colors.white;
  static const green = Color(0xFF22C55E);
  static const red = Color(0xFFE53935);

  /// Theme-stable neutral grey for the "draw" outcome (identical light/dark).
  static const outcomeDraw = Color(0xFF94A3B8);

  static const disabled = Color(0xFFBDBDBD);

  static const lightCellShadow = Color(0xFFE2E8F0);
  static const darkCellPressed = Color(0xFF273449);
  static const darkCellLightShadow = Color(0xFF334155);
  static const darkCellDarkShadow = Color(0xFF020617);
}

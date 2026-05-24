import 'package:flutter/material.dart';

@immutable
final class GameThemeExtension extends ThemeExtension<GameThemeExtension> {
  const GameThemeExtension({
    required this.boardBackgroundColor,
    required this.cellBackgroundColor,
    required this.cellBorderColor,
    required this.cellPressedColor,
    required this.cellLightShadowColor,
    required this.cellDarkShadowColor,
    required this.xColor,
    required this.oColor,
    required this.statusBackgroundColor,
    required this.statusBorderColor,
    required this.statusTextColor,
    required this.successColor,
    required this.dangerColor,
    required this.disabledColor,
  });

  final Color boardBackgroundColor;

  final Color cellBackgroundColor;
  final Color cellBorderColor;
  final Color cellPressedColor;
  final Color cellLightShadowColor;
  final Color cellDarkShadowColor;

  final Color xColor;
  final Color oColor;

  final Color statusBackgroundColor;
  final Color statusBorderColor;
  final Color statusTextColor;

  final Color successColor;
  final Color dangerColor;
  final Color disabledColor;

  @override
  GameThemeExtension copyWith({
    Color? boardBackgroundColor,
    Color? cellBackgroundColor,
    Color? cellBorderColor,
    Color? cellPressedColor,
    Color? cellLightShadowColor,
    Color? cellDarkShadowColor,
    Color? xColor,
    Color? oColor,
    Color? statusBackgroundColor,
    Color? statusBorderColor,
    Color? statusTextColor,
    Color? successColor,
    Color? dangerColor,
    Color? disabledColor,
  }) {
    return GameThemeExtension(
      boardBackgroundColor: boardBackgroundColor ?? this.boardBackgroundColor,
      cellBackgroundColor: cellBackgroundColor ?? this.cellBackgroundColor,
      cellBorderColor: cellBorderColor ?? this.cellBorderColor,
      cellPressedColor: cellPressedColor ?? this.cellPressedColor,
      cellLightShadowColor: cellLightShadowColor ?? this.cellLightShadowColor,
      cellDarkShadowColor: cellDarkShadowColor ?? this.cellDarkShadowColor,
      xColor: xColor ?? this.xColor,
      oColor: oColor ?? this.oColor,
      statusBackgroundColor:
          statusBackgroundColor ?? this.statusBackgroundColor,
      statusBorderColor: statusBorderColor ?? this.statusBorderColor,
      statusTextColor: statusTextColor ?? this.statusTextColor,
      successColor: successColor ?? this.successColor,
      dangerColor: dangerColor ?? this.dangerColor,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }

  @override
  GameThemeExtension lerp(
    covariant ThemeExtension<GameThemeExtension>? other,
    double t,
  ) {
    if (other is! GameThemeExtension) {
      return this;
    }

    return GameThemeExtension(
      boardBackgroundColor: Color.lerp(
        boardBackgroundColor,
        other.boardBackgroundColor,
        t,
      )!,
      cellBackgroundColor: Color.lerp(
        cellBackgroundColor,
        other.cellBackgroundColor,
        t,
      )!,
      cellBorderColor: Color.lerp(cellBorderColor, other.cellBorderColor, t)!,
      cellPressedColor: Color.lerp(
        cellPressedColor,
        other.cellPressedColor,
        t,
      )!,
      cellLightShadowColor: Color.lerp(
        cellLightShadowColor,
        other.cellLightShadowColor,
        t,
      )!,
      cellDarkShadowColor: Color.lerp(
        cellDarkShadowColor,
        other.cellDarkShadowColor,
        t,
      )!,
      xColor: Color.lerp(xColor, other.xColor, t)!,
      oColor: Color.lerp(oColor, other.oColor, t)!,
      statusBackgroundColor: Color.lerp(
        statusBackgroundColor,
        other.statusBackgroundColor,
        t,
      )!,
      statusBorderColor: Color.lerp(
        statusBorderColor,
        other.statusBorderColor,
        t,
      )!,
      statusTextColor: Color.lerp(statusTextColor, other.statusTextColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t)!,
    );
  }
}

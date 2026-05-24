import 'package:flutter/material.dart';
import 'package:tictactoe/app/theme/extensions/game_theme_extension.dart';

extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  GameThemeExtension get gameTheme {
    final gameTheme = theme.extension<GameThemeExtension>();

    assert(
      gameTheme != null,
      'GameThemeExtension is missing from ThemeData.extensions.',
    );

    return gameTheme!;
  }
}

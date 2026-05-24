import 'package:flutter/material.dart';
import 'package:tictactoe/app/theme/extensions/game_theme_extension.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';

class GameCell extends StatelessWidget {
  const GameCell({
    required this.cell,
    required this.onTap,
    this.isDisabled = false,
    super.key,
  });

  static const _borderRadius = 24.0;
  static const _shadowOffset = 8.0;
  static const _shadowBlur = 18.0;
  static const _animationDuration = Duration(milliseconds: 180);

  final Cell cell;
  final VoidCallback onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final gameTheme = context.gameTheme;

    return GestureDetector(
      onTap: isDisabled || !cell.isEmpty ? null : onTap,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: gameTheme.cellBackgroundColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: gameTheme.cellDarkShadowColor,
              offset: const Offset(_shadowOffset, _shadowOffset),
              blurRadius: _shadowBlur,
            ),
            BoxShadow(
              color: gameTheme.cellLightShadowColor,
              offset: const Offset(-_shadowOffset, -_shadowOffset),
              blurRadius: _shadowBlur,
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: _animationDuration,
            child: cell.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    cell.symbol,
                    key: ValueKey(cell),
                    style: context.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cell.colorFrom(gameTheme),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

extension _CellUiX on Cell {
  String get symbol {
    return switch (this) {
      Cell.empty => '',
      Cell.x => 'X',
      Cell.o => 'O',
    };
  }

  Color colorFrom(GameThemeExtension gameTheme) {
    return switch (this) {
      Cell.empty => Colors.transparent,
      Cell.x => gameTheme.xColor,
      Cell.o => gameTheme.oColor,
    };
  }
}

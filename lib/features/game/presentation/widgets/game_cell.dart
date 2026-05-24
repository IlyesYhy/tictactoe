import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictactoe/app/theme/extensions/game_theme_extension.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';

class GameCell extends StatefulWidget {
  const GameCell({
    required this.cell,
    required this.onTap,
    this.isDisabled = false,
    super.key,
  });

  final Cell cell;
  final VoidCallback onTap;
  final bool isDisabled;

  @override
  State<GameCell> createState() => _GameCellState();
}

class _GameCellState extends State<GameCell> {
  static const _borderRadius = 24.0;
  static const _shadowOffset = 8.0;
  static const _shadowBlur = 18.0;
  static const _animationDuration = Duration(milliseconds: 180);
  static const _pressDuration = Duration(milliseconds: 90);
  static const _pressedScale = 0.96;

  bool _isPressed = false;

  bool get _isInteractive => !widget.isDisabled && widget.cell.isEmpty;

  void _setPressed(bool value) {
    if (!_isInteractive) return;
    setState(() => _isPressed = value);
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final gameTheme = context.gameTheme;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: _isInteractive ? _handleTap : null,
      child: AnimatedScale(
        scale: _isPressed ? _pressedScale : 1.0,
        duration: _pressDuration,
        curve: Curves.easeOut,
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
              child: widget.cell.isEmpty
                  ? const SizedBox.shrink()
                  : FractionallySizedBox(
                      key: ValueKey(widget.cell),
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          widget.cell.symbol,
                          style: context.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: widget.cell.colorFrom(gameTheme),
                          ),
                        ),
                      ),
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

import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

const _buttonHeight = 56.0;
const _borderRadius = 18.0;
const _borderWidth = 1.5;
const _disabledOpacity = 0.38;

class RestartGameButton extends StatelessWidget {
  const RestartGameButton({
    required this.onPressed,
    this.isGameOver = false,
    super.key,
  });

  static const _icon = Icon(Icons.refresh);

  final VoidCallback? onPressed;
  final bool isGameOver;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      isGameOver ? context.l10n.playAgain : context.l10n.restartGame,
    );
    final style = _buttonStyle(context);

    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: isGameOver
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: _icon,
              label: label,
              style: style,
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: _icon,
              label: label,
              style: style.merge(_outlinedStyle(context)),
            ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ButtonStyle(
      textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
      ),
    );
  }

  ButtonStyle _outlinedStyle(BuildContext context) {
    final primary = context.colorScheme.primary;

    Color resolveColor(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return primary.withValues(alpha: _disabledOpacity);
      }

      return primary;
    }

    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(resolveColor),
      side: WidgetStateProperty.resolveWith(
        (states) =>
            BorderSide(color: resolveColor(states), width: _borderWidth),
      ),
    );
  }
}

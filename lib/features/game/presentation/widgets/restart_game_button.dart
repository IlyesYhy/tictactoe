import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

const _buttonHeight = 56.0;
const _borderRadius = 18.0;
const _borderWidth = 1.5;

class RestartGameButton extends StatelessWidget {
  const RestartGameButton({required this.onPressed, super.key});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final disabledColor = context.gameTheme.disabledColor;

    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.refresh),
        label: Text(context.l10n.restartGame),
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(context.textTheme.labelLarge),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor;
            }

            return colorScheme.primary;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            final color = states.contains(WidgetState.disabled)
                ? disabledColor
                : colorScheme.primary;

            return BorderSide(color: color, width: _borderWidth);
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}

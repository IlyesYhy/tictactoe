import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

const _entryGap = 24.0;
const _iconSize = 18.0;
const _iconGap = 6.0;

class GamePlayersLegend extends StatelessWidget {
  const GamePlayersLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final gameTheme = context.gameTheme;
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendEntry(
          icon: Icons.close,
          color: gameTheme.xColor,
          label: l10n.you,
        ),
        const SizedBox(width: _entryGap),
        _LegendEntry(
          icon: Icons.radio_button_unchecked,
          color: gameTheme.oColor,
          label: l10n.cpu,
        ),
      ],
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: _iconSize),
        const SizedBox(width: _iconGap),
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}

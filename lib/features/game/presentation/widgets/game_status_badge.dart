import 'package:flutter/material.dart';
import 'package:tictactoe/app/theme/extensions/game_theme_extension.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_roles.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

class GameStatusBadge extends StatelessWidget {
  const GameStatusBadge({
    required this.result,
    required this.isCpuThinking,
    super.key,
  });

  static const _borderRadius = 32.0;
  static const _paddingH = 20.0;
  static const _paddingV = 12.0;
  static const _iconSize = 20.0;
  static const _iconGap = 8.0;
  static const _borderWidth = 2.0;
  static const _shadowBlur = 20.0;
  static const _shadowOffset = Offset(0, 10);
  static const _shadowAlpha = 0.16;
  static const _animationDuration = Duration(milliseconds: 180);

  final GameResult result;
  final bool isCpuThinking;

  @override
  Widget build(BuildContext context) {
    final gameTheme = context.gameTheme;
    final descriptor = _descriptorFor(context.l10n, gameTheme);

    return Semantics(
      liveRegion: true,
      container: true,
      label: descriptor.label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: _animationDuration,
        padding: const EdgeInsets.symmetric(
          horizontal: _paddingH,
          vertical: _paddingV,
        ),
        decoration: BoxDecoration(
          color: gameTheme.statusBackgroundColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(color: descriptor.color, width: _borderWidth),
          boxShadow: [
            BoxShadow(
              color: gameTheme.cellDarkShadowColor.withValues(
                alpha: _shadowAlpha,
              ),
              blurRadius: _shadowBlur,
              offset: _shadowOffset,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(descriptor.icon, color: descriptor.color, size: _iconSize),
            const SizedBox(width: _iconGap),
            Flexible(
              child: Text(
                descriptor.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleMedium?.copyWith(
                  color: descriptor.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _StatusDescriptor _descriptorFor(
    AppLocalizations l10n,
    GameThemeExtension gameTheme,
  ) {
    if (isCpuThinking) {
      return _StatusDescriptor(
        label: l10n.cpuThinking,
        icon: Icons.radio_button_unchecked,
        color: gameTheme.oColor,
      );
    }

    return switch (result) {
      GameWinner(player: final winner) when winner == humanPlayer =>
        _StatusDescriptor(
          label: l10n.youWon,
          icon: Icons.emoji_events,
          color: gameTheme.successColor,
        ),
      GameWinner() => _StatusDescriptor(
        label: l10n.cpuWon,
        icon: Icons.sentiment_dissatisfied,
        color: gameTheme.dangerColor,
      ),
      GameDraw() => _StatusDescriptor(
        label: l10n.draw,
        icon: Icons.handshake,
        color: gameTheme.disabledColor,
      ),
      GameInProgress() => _StatusDescriptor(
        label: l10n.yourTurn,
        icon: Icons.close,
        color: gameTheme.xColor,
      ),
    };
  }
}

class _StatusDescriptor {
  const _StatusDescriptor({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

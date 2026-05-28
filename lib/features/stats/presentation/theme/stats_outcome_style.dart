import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';

/// Visual style (color + icon) for a [MatchOutcome] across the stats UI.
///
/// Colors are sourced from the theme: victory tracks the brand primary, while
/// draw and defeat read the theme-stable `StatsOutcomeColors` extension.
class StatsOutcomeStyle {
  const StatsOutcomeStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

/// Resolves the [StatsOutcomeStyle] for [outcome] from the current theme.
StatsOutcomeStyle statsOutcomeStyleOf(
  BuildContext context,
  MatchOutcome outcome,
) {
  final colors = context.statsOutcomeColors;

  return switch (outcome) {
    MatchOutcome.humanWon => StatsOutcomeStyle(
      color: context.colorScheme.primary,
      icon: Icons.emoji_events_outlined,
    ),
    MatchOutcome.cpuWon => StatsOutcomeStyle(
      color: colors.defeat,
      icon: Icons.close_rounded,
    ),
    MatchOutcome.draw => StatsOutcomeStyle(
      color: colors.draw,
      icon: Icons.handshake_outlined,
    ),
  };
}

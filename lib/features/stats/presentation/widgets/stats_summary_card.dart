import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/presentation/theme/stats_outcome_style.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_card.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_vertical_separator.dart';

/// Card listing the three outcome counters (victories, draws, defeats).
class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({required this.stats, super.key});

  final GameStatistics stats;

  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const _dividerHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final victory = statsOutcomeStyleOf(context, MatchOutcome.humanWon);
    final draw = statsOutcomeStyleOf(context, MatchOutcome.draw);
    final defeat = statsOutcomeStyleOf(context, MatchOutcome.cpuWon);

    return StatsCard(
      child: Padding(
        padding: _padding,
        child: Row(
          children: [
            Expanded(
              child: _CounterColumn(
                icon: victory.icon,
                value: stats.victories,
                label: l10n.statsVictoryCount(stats.victories),
                color: victory.color,
              ),
            ),
            const StatsVerticalSeparator(height: _dividerHeight),
            Expanded(
              child: _CounterColumn(
                icon: draw.icon,
                value: stats.draws,
                label: l10n.statsDrawCount(stats.draws),
                color: draw.color,
              ),
            ),
            const StatsVerticalSeparator(height: _dividerHeight),
            Expanded(
              child: _CounterColumn(
                icon: defeat.icon,
                value: stats.defeats,
                label: l10n.statsDefeatCount(stats.defeats),
                color: defeat.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterColumn extends StatelessWidget {
  const _CounterColumn({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

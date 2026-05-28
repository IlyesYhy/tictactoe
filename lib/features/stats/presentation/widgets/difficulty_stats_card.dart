import 'package:flutter/material.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_card.dart';

/// Compact card summarising the per-outcome stats for a single difficulty.
class DifficultyStatsCard extends StatelessWidget {
  const DifficultyStatsCard({
    required this.difficulty,
    required this.stats,
    super.key,
  });

  final GameDifficulty difficulty;
  final GameStatistics stats;

  static const _radius = 18.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 12, vertical: 14);
  static const _sectionGap = 12.0;
  static const _separatorHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    final isEasy = difficulty == GameDifficulty.easy;
    final l10n = context.l10n;
    final color = isEasy
        ? context.colorScheme.primary
        : context.colorScheme.onSurfaceVariant;
    final label = isEasy ? l10n.difficultyEasy : l10n.difficultyHard;
    final icon = isEasy
        ? Icons.sentiment_satisfied_rounded
        : Icons.local_fire_department_rounded;

    return StatsCard(
      radius: _radius,
      child: Padding(
        padding: _padding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: _sectionGap),
            Divider(
              height: 1,
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: _sectionGap),
            Row(
              children: [
                Expanded(
                  child: _MiniOutcomeStat(
                    icon: Icons.emoji_events_outlined,
                    value: stats.victories,
                    label: l10n.statsVictories,
                    color: context.colorScheme.primary,
                  ),
                ),
                const _VerticalSeparator(height: _separatorHeight),
                Expanded(
                  child: _MiniOutcomeStat(
                    icon: Icons.remove_rounded,
                    value: stats.draws,
                    label: l10n.statsDraws,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const _VerticalSeparator(height: _separatorHeight),
                Expanded(
                  child: _MiniOutcomeStat(
                    icon: Icons.close_rounded,
                    value: stats.defeats,
                    label: l10n.statsDefeats,
                    color: context.colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniOutcomeStat extends StatelessWidget {
  const _MiniOutcomeStat({
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
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 6),
        Text(
          '$value',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _VerticalSeparator extends StatelessWidget {
  const _VerticalSeparator({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        width: 1,
        color: context.colorScheme.outlineVariant.withValues(alpha: 0.55),
      ),
    );
  }
}

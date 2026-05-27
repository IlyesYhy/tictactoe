import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';

class StatsCounterCard extends StatelessWidget {
  const StatsCounterCard({required this.stats, super.key});

  final GameStatistics stats;

  static const _radius = 18.0;
  static const _elevation = 1.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 20);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final winRatePercent = (stats.winRate * 100).round();

    return Material(
      color: context.colorScheme.surface,
      elevation: _elevation,
      shadowColor: context.colorScheme.shadow.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_radius),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: _padding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _Counter(
                    value: stats.victories,
                    label: l10n.statsVictories,
                    color: context.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: _Counter(
                    value: stats.defeats,
                    label: l10n.statsDefeats,
                    color: context.colorScheme.error,
                  ),
                ),
                Expanded(
                  child: _Counter(
                    value: stats.draws,
                    label: l10n.statsDraws,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              height: 1,
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Summary(
                  label: l10n.statsTotalMatches,
                  value: '${stats.totalMatches}',
                ),
                _Summary(label: l10n.statsWinRate, value: '$winRatePercent%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: context.textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

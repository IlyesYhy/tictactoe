import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';

class StatsChart extends StatelessWidget {
  const StatsChart({required this.stats, super.key});

  /// Callers must only render this widget when [stats.totalMatches] is at
  /// least one — the page handles the empty state separately.
  final GameStatistics stats;

  static const _radius = 18.0;
  static const _elevation = 1.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 20);
  static const _rowGap = 14.0;

  @override
  Widget build(BuildContext context) {
    assert(
      stats.totalMatches > 0,
      'StatsChart must not be rendered with an empty history.',
    );

    if (stats.totalMatches == 0) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final total = stats.totalMatches;

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
            _Bar(
              label: l10n.statsVictories,
              count: stats.victories,
              total: total,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: _rowGap),
            _Bar(
              label: l10n.statsDefeats,
              count: stats.defeats,
              total: total,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: _rowGap),
            _Bar(
              label: l10n.statsDraws,
              count: stats.draws,
              total: total,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  static const _labelWidth = 84.0;
  static const _percentWidth = 48.0;
  static const _barHeight = 14.0;
  static const _gap = 12.0;

  @override
  Widget build(BuildContext context) {
    final percent = (count / total * 100).round();

    return Row(
      children: [
        SizedBox(
          width: _labelWidth,
          child: Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: _gap),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final barWidth = count / total * maxWidth;
              return SizedBox(
                height: _barHeight,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(_barHeight),
                      ),
                    ),
                    Container(
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(_barHeight),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(width: _gap),
        SizedBox(
          width: _percentWidth,
          child: Text(
            '$percent%',
            textAlign: TextAlign.right,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

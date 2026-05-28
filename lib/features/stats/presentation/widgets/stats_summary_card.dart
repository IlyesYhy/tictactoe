import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_card.dart';

/// Card listing per-outcome counters together with their distribution bars.
class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({required this.stats, super.key});

  final GameStatistics stats;

  static const _padding = EdgeInsets.symmetric(horizontal: 18, vertical: 20);
  static const _dividerHeight = 28.0;
  static const _barGap = 14.0;
  static const _sectionGap = 18.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = stats.totalMatches;

    return StatsCard(
      child: Padding(
        padding: _padding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _CounterColumn(
                    icon: Icons.emoji_events_outlined,
                    value: stats.victories,
                    label: l10n.statsVictories,
                    color: context.colorScheme.primary,
                  ),
                ),
                const _VerticalSeparator(height: _dividerHeight),
                Expanded(
                  child: _CounterColumn(
                    icon: Icons.remove_rounded,
                    value: stats.draws,
                    label: l10n.statsDraws,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const _VerticalSeparator(height: _dividerHeight),
                Expanded(
                  child: _CounterColumn(
                    icon: Icons.close_rounded,
                    value: stats.defeats,
                    label: l10n.statsDefeats,
                    color: context.colorScheme.error,
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
            _DistributionBar(
              label: l10n.statsVictories,
              count: stats.victories,
              total: total,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: _barGap),
            _DistributionBar(
              label: l10n.statsDraws,
              count: stats.draws,
              total: total,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: _barGap),
            _DistributionBar(
              label: l10n.statsDefeats,
              count: stats.defeats,
              total: total,
              color: context.colorScheme.error,
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
          radius: 22,
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
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

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  static const _labelWidth = 86.0;
  static const _percentWidth = 44.0;
  static const _barHeight = 12.0;
  static const _gap = 12.0;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : (count / total * 100).round();

    return Row(
      children: [
        SizedBox(
          width: _labelWidth,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: _gap),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = total == 0
                  ? 0.0
                  : count / total * constraints.maxWidth;

              return Stack(
                children: [
                  Container(
                    height: _barHeight,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(_barHeight),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    width: width,
                    height: _barHeight,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(_barHeight),
                    ),
                  ),
                ],
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
              fontWeight: FontWeight.w800,
            ),
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

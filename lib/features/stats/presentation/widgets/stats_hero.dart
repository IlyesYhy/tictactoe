import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/app_assets.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';
import 'package:tictactoe/features/stats/presentation/widgets/donut_total_chart.dart';

/// Hero section at the top of the statistics page.
///
/// Pairs the player mascot with a globally centred donut chart and the
/// per-outcome legend. Rendered directly on the page background (not wrapped
/// in a card) so it reads as a header rather than a boxed section.
///
/// The donut stays centred in the full width while the mascot and legend areas
/// are clamped to the space on either side, so they can never overlap the
/// donut on narrow screens.
class StatsHero extends StatelessWidget {
  const StatsHero({required this.stats, super.key});

  final GameStatistics stats;

  static const _height = 180.0;
  static const _zoneGap = 12.0;
  static const _compactBreakpoint = 340.0;

  static const _mascotArea = 120.0;
  static const _compactMascotArea = 86.0;
  static const _mascotHeight = 150.0;
  static const _compactMascotHeight = 118.0;
  static const _mascotFallbackSize = 96.0;
  static const _compactMascotFallbackSize = 76.0;

  static const _donutSize = 110.0;
  static const _compactDonutSize = 92.0;
  static const _donutStrokeWidth = 14.0;
  static const _compactDonutStrokeWidth = 12.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mascotPath = isDark
        ? AppAssets.botDarkStats
        : AppAssets.botLightStats;

    return SizedBox(
      height: _height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isCompact = width < _compactBreakpoint;

          final donutSize = isCompact ? _compactDonutSize : _donutSize;
          final donutStrokeWidth = isCompact
              ? _compactDonutStrokeWidth
              : _donutStrokeWidth;

          final donutLeftEdge = (width - donutSize) / 2;
          final donutRightEdge = donutLeftEdge + donutSize;

          // Clamp the mascot to the space left of the donut so it can never
          // overlap it, and scale its height proportionally when squeezed.
          final desiredMascotWidth = isCompact
              ? _compactMascotArea
              : _mascotArea;
          final availableMascotWidth = math.max(0.0, donutLeftEdge - _zoneGap);
          final mascotAreaWidth = math.min(
            desiredMascotWidth,
            availableMascotWidth,
          );
          final mascotScale = desiredMascotWidth == 0
              ? 1.0
              : mascotAreaWidth / desiredMascotWidth;
          final mascotHeight =
              (isCompact ? _compactMascotHeight : _mascotHeight) * mascotScale;

          return Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: mascotAreaWidth,
                  child: _MascotArea(
                    assetPath: mascotPath,
                    height: mascotHeight,
                    isCompact: isCompact,
                  ),
                ),
              ),
              Center(
                child: DonutTotalChart(
                  stats: stats,
                  size: donutSize,
                  strokeWidth: donutStrokeWidth,
                ),
              ),
              Positioned(
                left: donutRightEdge + _zoneGap,
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _OutcomeLegend(stats: stats),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MascotArea extends StatelessWidget {
  const _MascotArea({
    required this.assetPath,
    required this.height,
    required this.isCompact,
  });

  final String assetPath;
  final double height;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: isCompact ? 6 : 16,
          top: isCompact ? 36 : 28,
          child: _Sparkle(
            color: context.colorScheme.primary.withValues(alpha: 0.28),
          ),
        ),
        Positioned(
          right: isCompact ? 2 : 12,
          bottom: isCompact ? 42 : 36,
          child: _Sparkle(
            color: context.colorScheme.secondary.withValues(alpha: 0.28),
          ),
        ),
        Image.asset(
          assetPath,
          height: height,
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.smart_toy_rounded,
              size: isCompact
                  ? StatsHero._compactMascotFallbackSize
                  : StatsHero._mascotFallbackSize,
              color: context.colorScheme.primary,
            );
          },
        ),
      ],
    );
  }
}

class _OutcomeLegend extends StatelessWidget {
  const _OutcomeLegend({required this.stats});

  final GameStatistics stats;

  static const _itemGap = 8.0;

  int _percentFor(int count) {
    final total = stats.totalMatches;
    if (total == 0) return 0;
    return (count / total * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _LegendItem(
          icon: Icons.emoji_events_outlined,
          color: context.colorScheme.primary,
          percent: _percentFor(stats.victories),
        ),
        const SizedBox(height: _itemGap),
        _LegendItem(
          icon: Icons.handshake_outlined,
          color: context.colorScheme.onSurfaceVariant,
          percent: _percentFor(stats.draws),
        ),
        const SizedBox(height: _itemGap),
        _LegendItem(
          icon: Icons.close_rounded,
          color: context.colorScheme.error,
          percent: _percentFor(stats.defeats),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.icon,
    required this.color,
    required this.percent,
  });

  final IconData icon;
  final Color color;
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 5),
        Text(
          '$percent%',
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome_rounded, color: color, size: 16);
  }
}

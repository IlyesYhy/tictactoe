import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';
import 'package:tictactoe/features/stats/presentation/widgets/donut_total_chart.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_card.dart';

/// Hero card at the top of the statistics page.
///
/// Pairs the player mascot with a donut chart summarising the match outcomes.
class StatsHeroCard extends StatelessWidget {
  const StatsHeroCard({required this.stats, super.key});

  final GameStatistics stats;

  static const _radius = 24.0;
  static const _height = 180.0;
  static const _mascotHeight = 140.0;
  static const _mascotFallbackSize = 96.0;
  static const _donutSize = 130.0;
  static const _donutStrokeWidth = 18.0;

  static const _lightMascotPath = 'assets/bot-light-stats.png';
  static const _darkMascotPath = 'assets/bot-dark-stats.png';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mascotPath = isDark ? _darkMascotPath : _lightMascotPath;

    return StatsCard(
      radius: _radius,
      child: SizedBox(
        height: _height,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 16,
                    top: 28,
                    child: _Sparkle(
                      color: context.colorScheme.primary.withValues(
                        alpha: 0.28,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 26,
                    bottom: 36,
                    child: _Sparkle(
                      color: context.colorScheme.secondary.withValues(
                        alpha: 0.28,
                      ),
                    ),
                  ),
                  Image.asset(
                    mascotPath,
                    height: _mascotHeight,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.smart_toy_rounded,
                        size: _mascotFallbackSize,
                        color: context.colorScheme.primary,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: DonutTotalChart(
                  stats: stats,
                  size: _donutSize,
                  strokeWidth: _donutStrokeWidth,
                ),
              ),
            ),
          ],
        ),
      ),
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

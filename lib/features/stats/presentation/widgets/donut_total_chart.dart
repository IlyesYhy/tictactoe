import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';

/// Donut chart that visualises the breakdown of victories, draws and defeats
/// with the total match count rendered in the centre.
class DonutTotalChart extends StatelessWidget {
  const DonutTotalChart({
    required this.stats,
    required this.size,
    required this.strokeWidth,
    super.key,
  });

  final GameStatistics stats;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _DonutChartPainter(
              victories: stats.victories,
              draws: stats.draws,
              defeats: stats.defeats,
              primaryColor: context.colorScheme.primary,
              drawColor: context.colorScheme.onSurfaceVariant,
              defeatColor: context.colorScheme.error,
              trackColor: context.colorScheme.outlineVariant.withValues(
                alpha: 0.25,
              ),
              strokeWidth: strokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${stats.totalMatches}',
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.statsMatchesLabel,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({
    required this.victories,
    required this.draws,
    required this.defeats,
    required this.primaryColor,
    required this.drawColor,
    required this.defeatColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final int victories;
  final int draws;
  final int defeats;
  final Color primaryColor;
  final Color drawColor;
  final Color defeatColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final total = victories + draws + defeats;
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    paint.color = trackColor;
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      -math.pi / 2,
      math.pi * 2,
      false,
      paint,
    );

    if (total == 0) return;

    var startAngle = -math.pi / 2;

    void drawSegment(int value, Color color) {
      if (value == 0) return;

      final sweep = math.pi * 2 * (value / total);
      paint.color = color;
      canvas.drawArc(
        rect.deflate(strokeWidth / 2),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }

    drawSegment(victories, primaryColor);
    drawSegment(draws, drawColor);
    drawSegment(defeats, defeatColor);
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return victories != oldDelegate.victories ||
        draws != oldDelegate.draws ||
        defeats != oldDelegate.defeats ||
        primaryColor != oldDelegate.primaryColor ||
        drawColor != oldDelegate.drawColor ||
        defeatColor != oldDelegate.defeatColor ||
        trackColor != oldDelegate.trackColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

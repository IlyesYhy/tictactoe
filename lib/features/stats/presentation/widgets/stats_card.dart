import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

/// Shared surface card used by the stats section.
///
/// Applies the consistent elevation, border and rounded corners shared by the
/// hero, summary and per-difficulty cards.
class StatsCard extends StatelessWidget {
  const StatsCard({required this.child, this.radius = 22, super.key});

  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surface,
      elevation: 1,
      shadowColor: context.colorScheme.shadow.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

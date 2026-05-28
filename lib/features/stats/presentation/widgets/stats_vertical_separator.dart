import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

/// Thin vertical divider used between counters inside the stats cards.
class StatsVerticalSeparator extends StatelessWidget {
  const StatsVerticalSeparator({required this.height, super.key});
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

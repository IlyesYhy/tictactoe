import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

/// Section title used between cards on the statistics page.
class StatsSectionTitle extends StatelessWidget {
  const StatsSectionTitle({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Theme-stable colors for match outcomes shown on the statistics page.
///
/// Draw and defeat are deliberately identical in light and dark so their
/// meaning reads the same in both themes. Victory is not held here: it tracks
/// `colorScheme.primary` directly.
@immutable
final class StatsOutcomeColors extends ThemeExtension<StatsOutcomeColors> {
  const StatsOutcomeColors({required this.draw, required this.defeat});

  final Color draw;
  final Color defeat;

  @override
  StatsOutcomeColors copyWith({Color? draw, Color? defeat}) {
    return StatsOutcomeColors(
      draw: draw ?? this.draw,
      defeat: defeat ?? this.defeat,
    );
  }

  @override
  StatsOutcomeColors lerp(
    covariant ThemeExtension<StatsOutcomeColors>? other,
    double t,
  ) {
    if (other is! StatsOutcomeColors) {
      return this;
    }

    return StatsOutcomeColors(
      draw: Color.lerp(draw, other.draw, t)!,
      defeat: Color.lerp(defeat, other.defeat, t)!,
    );
  }
}

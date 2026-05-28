import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/app/theme/extensions/stats_outcome_colors.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/presentation/theme/stats_outcome_style.dart';

void main() {
  Future<StatsOutcomeStyle> resolveStyle(
    WidgetTester tester, {
    required ThemeData theme,
    required MatchOutcome outcome,
  }) async {
    late StatsOutcomeStyle style;

    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Builder(
          builder: (context) {
            style = statsOutcomeStyleOf(context, outcome);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    return style;
  }

  StatsOutcomeColors readOutcomeColors(ThemeData theme) {
    final outcomeColors = theme.extension<StatsOutcomeColors>();

    expect(
      outcomeColors,
      isNotNull,
      reason: 'AppTheme must provide StatsOutcomeColors.',
    );

    return outcomeColors!;
  }

  group('statsOutcomeStyleOf', () {
    testWidgets('maps humanWon to the trophy icon and the primary color', (
      tester,
    ) async {
      final theme = AppTheme.light;

      final style = await resolveStyle(
        tester,
        theme: theme,
        outcome: MatchOutcome.humanWon,
      );

      expect(style.icon, Icons.emoji_events_outlined);
      expect(style.color, theme.colorScheme.primary);
    });

    testWidgets(
      'maps draw to the handshake icon and the extension draw color',
      (tester) async {
        final theme = AppTheme.light;
        final outcomeColors = readOutcomeColors(theme);

        final style = await resolveStyle(
          tester,
          theme: theme,
          outcome: MatchOutcome.draw,
        );

        expect(style.icon, Icons.handshake_outlined);
        expect(style.color, outcomeColors.draw);
      },
    );

    testWidgets(
      'maps cpuWon to the close icon and the extension defeat color',
      (tester) async {
        final theme = AppTheme.light;
        final outcomeColors = readOutcomeColors(theme);

        final style = await resolveStyle(
          tester,
          theme: theme,
          outcome: MatchOutcome.cpuWon,
        );

        expect(style.icon, Icons.close_rounded);
        expect(style.color, outcomeColors.defeat);
      },
    );

    testWidgets('keeps draw and defeat colors stable between light and dark', (
      tester,
    ) async {
      final lightDraw = await resolveStyle(
        tester,
        theme: AppTheme.light,
        outcome: MatchOutcome.draw,
      );
      final darkDraw = await resolveStyle(
        tester,
        theme: AppTheme.dark,
        outcome: MatchOutcome.draw,
      );
      final lightDefeat = await resolveStyle(
        tester,
        theme: AppTheme.light,
        outcome: MatchOutcome.cpuWon,
      );
      final darkDefeat = await resolveStyle(
        tester,
        theme: AppTheme.dark,
        outcome: MatchOutcome.cpuWon,
      );

      expect(lightDraw.color, darkDraw.color);
      expect(lightDefeat.color, darkDefeat.color);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/stats/di/stats_providers.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_history.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/presentation/pages/stats_page.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_chart.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_counter_card.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  Future<void> pumpStatsPage(
    WidgetTester tester, {
    required MatchHistory history,
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [initialMatchHistoryProvider.overrideWithValue(history)],
        child: MaterialApp(
          theme: AppTheme.light,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const StatsPage(),
        ),
      ),
    );
  }

  CompletedMatch buildMatch(MatchOutcome outcome) {
    return CompletedMatch(
      outcome: outcome,
      difficulty: GameDifficulty.easy,
      playedAt: DateTime(2026, 5, 27),
    );
  }

  group('StatsPage', () {
    testWidgets('renders empty state when history is empty', (tester) async {
      await pumpStatsPage(tester, history: MatchHistory.empty());

      expect(
        find.text('Play your first match to see your stats here.'),
        findsOneWidget,
      );
      expect(find.byType(StatsCounterCard), findsNothing);
      expect(find.byType(StatsChart), findsNothing);
    });

    testWidgets('renders counters and chart when history has matches', (
      tester,
    ) async {
      await pumpStatsPage(
        tester,
        history: MatchHistory([
          buildMatch(MatchOutcome.humanWon),
          buildMatch(MatchOutcome.cpuWon),
        ]),
      );

      expect(find.byType(StatsCounterCard), findsOneWidget);
      expect(find.byType(StatsChart), findsOneWidget);
    });

    testWidgets('renders the correct percentages on the chart', (tester) async {
      // 2 victories, 1 defeat, 1 draw → 50%, 25%, 25%
      await pumpStatsPage(
        tester,
        history: MatchHistory([
          buildMatch(MatchOutcome.humanWon),
          buildMatch(MatchOutcome.humanWon),
          buildMatch(MatchOutcome.cpuWon),
          buildMatch(MatchOutcome.draw),
        ]),
      );

      final chartFinder = find.byType(StatsChart);
      expect(
        find.descendant(of: chartFinder, matching: find.text('50%')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: chartFinder, matching: find.text('25%')),
        findsNWidgets(2),
      );
    });

    testWidgets('renders French copy under fr locale', (tester) async {
      await pumpStatsPage(
        tester,
        history: MatchHistory.empty(),
        locale: const Locale('fr'),
      );

      expect(find.text('Statistiques'), findsOneWidget);
      expect(
        find.text(
          'Jouez votre première partie pour voir vos statistiques ici.',
        ),
        findsOneWidget,
      );
    });
  });
}

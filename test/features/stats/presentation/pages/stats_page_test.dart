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
import 'package:tictactoe/features/stats/presentation/widgets/difficulty_stats_card.dart';
import 'package:tictactoe/features/stats/presentation/widgets/match_history_tile.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_hero.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_summary_card.dart';
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

  CompletedMatch buildMatch(
    MatchOutcome outcome, {
    GameDifficulty difficulty = GameDifficulty.easy,
  }) {
    return CompletedMatch(
      outcome: outcome,
      difficulty: difficulty,
      playedAt: DateTime(2026, 5, 27),
    );
  }

  void useTallViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('StatsPage', () {
    testWidgets('renders empty state when history is empty', (tester) async {
      await pumpStatsPage(tester, history: MatchHistory.empty());

      expect(
        find.text('Play your first match to see your stats here.'),
        findsOneWidget,
      );
      expect(find.byType(StatsHero), findsNothing);
      expect(find.byType(StatsSummaryCard), findsNothing);
      expect(find.byType(DifficultyStatsCard), findsNothing);
    });

    testWidgets(
      'renders hero, summary and difficulty sections when history has matches',
      (tester) async {
        useTallViewport(tester);

        await pumpStatsPage(
          tester,
          history: MatchHistory([
            buildMatch(MatchOutcome.humanWon),
            buildMatch(MatchOutcome.cpuWon),
          ]),
        );

        expect(find.byType(StatsHero), findsOneWidget);
        expect(find.byType(StatsSummaryCard), findsOneWidget);
        expect(find.text('Results by difficulty'), findsOneWidget);
        expect(find.byType(DifficultyStatsCard), findsNWidgets(2));
      },
    );

    testWidgets('renders the match history section when history is not empty', (
      tester,
    ) async {
      useTallViewport(tester);

      await pumpStatsPage(
        tester,
        history: MatchHistory([buildMatch(MatchOutcome.humanWon)]),
      );

      expect(find.text('History'), findsOneWidget);
      expect(find.byType(MatchHistoryTile), findsOneWidget);
    });

    testWidgets('renders match history tiles in most-recent-first order', (
      tester,
    ) async {
      useTallViewport(tester);

      final older = CompletedMatch(
        outcome: MatchOutcome.humanWon,
        difficulty: GameDifficulty.easy,
        playedAt: DateTime(2026, 5, 20),
      );
      final newer = CompletedMatch(
        outcome: MatchOutcome.cpuWon,
        difficulty: GameDifficulty.easy,
        playedAt: DateTime(2026, 5, 28),
      );

      await pumpStatsPage(tester, history: MatchHistory([older, newer]));

      final tiles = find.byType(MatchHistoryTile);

      expect(tiles, findsNWidgets(2));

      expect(
        find.descendant(of: tiles.at(0), matching: find.text('Defeat')),
        findsOneWidget,
      );

      expect(
        find.descendant(of: tiles.at(1), matching: find.text('Victory')),
        findsOneWidget,
      );
    });
    testWidgets('stacks the per-difficulty cards on narrow viewports', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await pumpStatsPage(
        tester,
        history: MatchHistory([buildMatch(MatchOutcome.humanWon)]),
      );

      expect(find.byType(DifficultyStatsCard), findsNWidgets(2));

      final cards = find.byType(DifficultyStatsCard);
      final firstTop = tester.getTopLeft(cards.first).dy;
      final secondTop = tester.getTopLeft(cards.last).dy;

      expect(firstTop, lessThan(secondTop));

      expect(tester.takeException(), isNull);
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

    testWidgets('renders the French by-difficulty section title', (
      tester,
    ) async {
      useTallViewport(tester);

      await pumpStatsPage(
        tester,
        history: MatchHistory([buildMatch(MatchOutcome.humanWon)]),
        locale: const Locale('fr'),
      );

      expect(find.text('Résultats par difficulté'), findsOneWidget);
      expect(find.text('Historique'), findsOneWidget);
    });
  });
}

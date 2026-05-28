import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_history.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';

void main() {
  CompletedMatch buildMatch(MatchOutcome outcome) {
    return CompletedMatch(
      outcome: outcome,
      difficulty: GameDifficulty.easy,
      playedAt: DateTime(2026, 1, 1),
    );
  }

  group('MatchHistory', () {
    test('empty returns no matches and empty statistics', () {
      final history = MatchHistory.empty();

      expect(history.matches, isEmpty);
      expect(history.statistics.victories, 0);
      expect(history.statistics.defeats, 0);
      expect(history.statistics.draws, 0);
    });

    test('statistics computes victories, defeats and draws', () {
      final history = MatchHistory([
        buildMatch(MatchOutcome.humanWon),
        buildMatch(MatchOutcome.humanWon),
        buildMatch(MatchOutcome.cpuWon),
        buildMatch(MatchOutcome.draw),
        buildMatch(MatchOutcome.draw),
        buildMatch(MatchOutcome.draw),
      ]);

      final stats = history.statistics;

      expect(stats.victories, 2);
      expect(stats.defeats, 1);
      expect(stats.draws, 3);
    });

    test('matches list is unmodifiable', () {
      final history = MatchHistory([buildMatch(MatchOutcome.humanWon)]);

      expect(
        () => history.matches.add(buildMatch(MatchOutcome.draw)),
        throwsUnsupportedError,
      );
    });

    test('preserves match insertion order', () {
      final firstMatch = CompletedMatch(
        outcome: MatchOutcome.humanWon,
        difficulty: GameDifficulty.easy,
        playedAt: DateTime(2026, 1, 1, 10),
      );
      final secondMatch = CompletedMatch(
        outcome: MatchOutcome.cpuWon,
        difficulty: GameDifficulty.hard,
        playedAt: DateTime(2026, 1, 1, 11),
      );

      final history = MatchHistory([firstMatch, secondMatch]);

      expect(history.matches, [firstMatch, secondMatch]);
    });

    test('statisticsForDifficulty filters matches by difficulty', () {
      CompletedMatch match(MatchOutcome outcome, GameDifficulty difficulty) {
        return CompletedMatch(
          outcome: outcome,
          difficulty: difficulty,
          playedAt: DateTime(2026, 1, 1),
        );
      }

      final history = MatchHistory([
        match(MatchOutcome.humanWon, GameDifficulty.easy),
        match(MatchOutcome.humanWon, GameDifficulty.easy),
        match(MatchOutcome.draw, GameDifficulty.easy),
        match(MatchOutcome.cpuWon, GameDifficulty.hard),
        match(MatchOutcome.cpuWon, GameDifficulty.hard),
        match(MatchOutcome.draw, GameDifficulty.hard),
      ]);

      final easyStats = history.statisticsForDifficulty(GameDifficulty.easy);
      expect(easyStats.victories, 2);
      expect(easyStats.defeats, 0);
      expect(easyStats.draws, 1);

      final hardStats = history.statisticsForDifficulty(GameDifficulty.hard);
      expect(hardStats.victories, 0);
      expect(hardStats.defeats, 2);
      expect(hardStats.draws, 1);
    });

    test('statisticsForDifficulty returns zero counters for empty history', () {
      final history = MatchHistory.empty();
      final stats = history.statisticsForDifficulty(GameDifficulty.easy);

      expect(stats.victories, 0);
      expect(stats.defeats, 0);
      expect(stats.draws, 0);
    });

    test('supports value equality for identical matches', () {
      final playedAt = DateTime(2026, 1, 1);
      final first = MatchHistory([
        CompletedMatch(
          outcome: MatchOutcome.humanWon,
          difficulty: GameDifficulty.easy,
          playedAt: playedAt,
        ),
      ]);
      final second = MatchHistory([
        CompletedMatch(
          outcome: MatchOutcome.humanWon,
          difficulty: GameDifficulty.easy,
          playedAt: playedAt,
        ),
      ]);

      expect(first, second);
    });
  });
}

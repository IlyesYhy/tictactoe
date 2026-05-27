import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/stats/data/repositories/local_stats_repository.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<LocalStatsRepository> createRepository([
    Map<String, Object> initialValues = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(initialValues);
    final preferences = await SharedPreferences.getInstance();
    return LocalStatsRepository(preferences);
  }

  group('LocalStatsRepository', () {
    test('returns an empty history on a fresh install', () async {
      final repository = await createRepository();

      final history = await repository.getMatchHistory();

      expect(history.matches, isEmpty);
    });

    test('recordMatch persists and getMatchHistory reads it back', () async {
      final repository = await createRepository();
      final match = CompletedMatch(
        outcome: MatchOutcome.humanWon,
        difficulty: GameDifficulty.easy,
        playedAt: DateTime(2026, 5, 27, 10, 30),
      );

      await repository.recordMatch(match);

      final history = await repository.getMatchHistory();
      expect(history.matches, [match]);
    });

    test('recordMatch appends matches in insertion order', () async {
      final repository = await createRepository();
      final first = CompletedMatch(
        outcome: MatchOutcome.humanWon,
        difficulty: GameDifficulty.easy,
        playedAt: DateTime(2026, 5, 27, 10),
      );
      final second = CompletedMatch(
        outcome: MatchOutcome.cpuWon,
        difficulty: GameDifficulty.hard,
        playedAt: DateTime(2026, 5, 27, 11),
      );

      await repository.recordMatch(first);
      await repository.recordMatch(second);

      final history = await repository.getMatchHistory();
      expect(history.matches, [first, second]);
    });

    test('returns an empty history when persisted JSON is invalid', () async {
      final repository = await createRepository({
        'stats.match_history': 'not-json',
      });

      final history = await repository.getMatchHistory();

      expect(history.matches, isEmpty);
    });

    test(
      'returns an empty history when persisted JSON is not a list',
      () async {
        final repository = await createRepository({
          'stats.match_history': '{"outcome":"humanWon"}',
        });

        final history = await repository.getMatchHistory();

        expect(history.matches, isEmpty);
      },
    );

    test('skips entries with an unknown outcome', () async {
      final repository = await createRepository({
        'stats.match_history':
            '[{"outcome":"unknown","difficulty":"easy","playedAt":"2026-05-27T10:00:00.000"},'
            '{"outcome":"humanWon","difficulty":"easy","playedAt":"2026-05-27T11:00:00.000"}]',
      });

      final history = await repository.getMatchHistory();

      expect(history.matches.length, 1);
      expect(history.matches.first.outcome, MatchOutcome.humanWon);
    });

    test('skips entries with an unknown difficulty', () async {
      final repository = await createRepository({
        'stats.match_history':
            '[{"outcome":"humanWon","difficulty":"unknown","playedAt":"2026-05-27T10:00:00.000"}]',
      });

      final history = await repository.getMatchHistory();

      expect(history.matches, isEmpty);
    });

    test('skips entries with an invalid playedAt', () async {
      final repository = await createRepository({
        'stats.match_history':
            '[{"outcome":"humanWon","difficulty":"easy","playedAt":"not-a-date"}]',
      });

      final history = await repository.getMatchHistory();

      expect(history.matches, isEmpty);
    });
  });
}

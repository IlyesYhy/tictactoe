import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/integrations/game_stats_recorder.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_roles.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_history.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/domain/repositories/stats_repository.dart';

void main() {
  group('GameStatsRecorder', () {
    final fixedNow = DateTime(2026, 5, 27, 12);

    ({GameStatsRecorder recorder, _RecordingStatsRepository repository})
    createRecorder() {
      final repository = _RecordingStatsRepository();
      final recorder = GameStatsRecorder(
        repository: repository,
        now: () => fixedNow,
      );
      return (recorder: recorder, repository: repository);
    }

    test('records a humanWon match when the human wins', () async {
      final (:recorder, :repository) = createRecorder();

      await recorder.recordFromGameSession(
        result: GameWinner(humanPlayer, [0, 1, 2]),
        difficulty: GameDifficulty.easy,
      );

      expect(repository.savedMatches, [
        CompletedMatch(
          outcome: MatchOutcome.humanWon,
          difficulty: GameDifficulty.easy,
          playedAt: fixedNow,
        ),
      ]);
    });

    test('records a cpuWon match when the CPU wins', () async {
      final (:recorder, :repository) = createRecorder();

      await recorder.recordFromGameSession(
        result: GameWinner(cpuPlayer, [0, 1, 2]),
        difficulty: GameDifficulty.hard,
      );

      expect(repository.savedMatches, [
        CompletedMatch(
          outcome: MatchOutcome.cpuWon,
          difficulty: GameDifficulty.hard,
          playedAt: fixedNow,
        ),
      ]);
    });

    test('records a draw match on draw', () async {
      final (:recorder, :repository) = createRecorder();

      await recorder.recordFromGameSession(
        result: const GameDraw(),
        difficulty: GameDifficulty.easy,
      );

      expect(repository.savedMatches, [
        CompletedMatch(
          outcome: MatchOutcome.draw,
          difficulty: GameDifficulty.easy,
          playedAt: fixedNow,
        ),
      ]);
    });

    test('does nothing while the game is still in progress', () async {
      final (:recorder, :repository) = createRecorder();

      await recorder.recordFromGameSession(
        result: const GameInProgress(),
        difficulty: GameDifficulty.easy,
      );

      expect(repository.savedMatches, isEmpty);
    });

    test('uses the injected clock for playedAt', () async {
      final (:recorder, :repository) = createRecorder();

      await recorder.recordFromGameSession(
        result: const GameDraw(),
        difficulty: GameDifficulty.easy,
      );

      expect(repository.savedMatches.single.playedAt, fixedNow);
    });
  });
}

final class _RecordingStatsRepository implements StatsRepository {
  final savedMatches = <CompletedMatch>[];

  @override
  Future<MatchHistory> getMatchHistory() async => MatchHistory(savedMatches);

  @override
  Future<void> recordMatch(CompletedMatch match) async {
    savedMatches.add(match);
  }
}

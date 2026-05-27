import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/integrations/game_stats_recorder.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_roles.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';

void main() {
  group('GameStatsRecorder', () {
    final fixedNow = DateTime(2026, 5, 27, 12);

    ({GameStatsRecorder recorder, List<CompletedMatch> recorded})
    createRecorder() {
      final recorded = <CompletedMatch>[];
      final recorder = GameStatsRecorder(
        addMatch: (match) async => recorded.add(match),
        now: () => fixedNow,
      );
      return (recorder: recorder, recorded: recorded);
    }

    test('records a humanWon match when the human wins', () async {
      final (:recorder, :recorded) = createRecorder();

      await recorder.recordFromGameSession(
        result: GameWinner(humanPlayer, [0, 1, 2]),
        difficulty: GameDifficulty.easy,
      );

      expect(recorded, [
        CompletedMatch(
          outcome: MatchOutcome.humanWon,
          difficulty: GameDifficulty.easy,
          playedAt: fixedNow,
        ),
      ]);
    });

    test('records a cpuWon match when the CPU wins', () async {
      final (:recorder, :recorded) = createRecorder();

      await recorder.recordFromGameSession(
        result: GameWinner(cpuPlayer, [0, 1, 2]),
        difficulty: GameDifficulty.hard,
      );

      expect(recorded, [
        CompletedMatch(
          outcome: MatchOutcome.cpuWon,
          difficulty: GameDifficulty.hard,
          playedAt: fixedNow,
        ),
      ]);
    });

    test('records a draw match on draw', () async {
      final (:recorder, :recorded) = createRecorder();

      await recorder.recordFromGameSession(
        result: const GameDraw(),
        difficulty: GameDifficulty.easy,
      );

      expect(recorded, [
        CompletedMatch(
          outcome: MatchOutcome.draw,
          difficulty: GameDifficulty.easy,
          playedAt: fixedNow,
        ),
      ]);
    });

    test('does nothing while the game is still in progress', () async {
      final (:recorder, :recorded) = createRecorder();

      await recorder.recordFromGameSession(
        result: const GameInProgress(),
        difficulty: GameDifficulty.easy,
      );

      expect(recorded, isEmpty);
    });

    test('uses the injected clock for playedAt', () async {
      final (:recorder, :recorded) = createRecorder();

      await recorder.recordFromGameSession(
        result: const GameDraw(),
        difficulty: GameDifficulty.easy,
      );

      expect(recorded.single.playedAt, fixedNow);
    });
  });
}

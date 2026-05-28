import '../../core/domain/entities/game_difficulty.dart';
import '../../features/game/domain/entities/game_result.dart';
import '../../features/game/domain/entities/game_roles.dart';
import '../../features/stats/domain/entities/completed_match.dart';
import '../../features/stats/domain/entities/match_outcome.dart';

/// App-layer integration that maps a finished [GameResult] to a
/// [CompletedMatch] and forwards it to whatever sink the app composes
/// (typically the live stats controller).
///
/// Lives in `lib/app/integrations/` on purpose: it composes the `game` and
/// `stats` features. Putting it inside either feature would create a
/// `stats → game` (or `game → stats`) dependency. The app layer is the only
/// place allowed to wire features together.
final class GameStatsRecorder {
  const GameStatsRecorder({
    required Future<void> Function(CompletedMatch match) addMatch,
    required DateTime Function() now,
  }) : _addMatch = addMatch,
       _now = now;

  final Future<void> Function(CompletedMatch match) _addMatch;
  final DateTime Function() _now;

  /// Records a completed match if [result] represents a finished game.
  ///
  /// No-op when the game is still in progress, so callers can route every
  /// session-state change here without pre-checking.
  Future<void> recordFromGameSession({
    required GameResult result,
    required GameDifficulty difficulty,
  }) async {
    final outcome = _outcomeFor(result);
    if (outcome == null) return;

    await _addMatch(
      CompletedMatch(
        outcome: outcome,
        difficulty: difficulty,
        playedAt: _now(),
      ),
    );
  }

  MatchOutcome? _outcomeFor(GameResult result) {
    return switch (result) {
      GameWinner(:final player) when player == humanPlayer =>
        MatchOutcome.humanWon,
      GameWinner() => MatchOutcome.cpuWon,
      GameDraw() => MatchOutcome.draw,
      GameInProgress() => null,
    };
  }
}

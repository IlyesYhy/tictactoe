import '../../core/domain/entities/game_difficulty.dart';
import '../../features/game/domain/entities/game_result.dart';
import '../../features/game/domain/entities/game_roles.dart';
import '../../features/stats/domain/entities/completed_match.dart';
import '../../features/stats/domain/entities/match_outcome.dart';
import '../../features/stats/domain/repositories/stats_repository.dart';

/// App-layer integration that maps a finished [GameResult] to a
/// [CompletedMatch] and forwards it to the stats repository.
///
/// Lives in `lib/app/integrations/` on purpose: it composes the `game` and
/// `stats` features. Putting it inside either feature would create a
/// `stats → game` (or `game → stats`) dependency. The app layer is the only
/// place allowed to wire features together.
final class GameStatsRecorder {
  const GameStatsRecorder({
    required StatsRepository repository,
    required DateTime Function() now,
  }) : _repository = repository,
       _now = now;

  final StatsRepository _repository;
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

    await _repository.recordMatch(
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

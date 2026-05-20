import '../entities/game_result.dart';
import '../entities/game_session.dart';
import '../entities/player.dart';
import '../services/game_engine.dart';

/// Handles a human player move.
///
/// This use case validates the current session state,
/// places the move on the board and evaluates the updated game result.
final class PlayHumanTurn {
  const PlayHumanTurn(this._gameEngine);

  final GameEngine _gameEngine;

  GameSession call({required GameSession session, required int cellIndex}) {
    if (session.isFinished) {
      throw StateError('Cannot play a move after the game is finished.');
    }

    if (session.currentPlayer != Player.x) {
      throw StateError('It is not the human player turn.');
    }

    final updatedBoard = session.board.placeMove(
      index: cellIndex,
      player: Player.x,
    );

    final result = _gameEngine.evaluate(updatedBoard);

    return GameSession(
      board: updatedBoard,
      currentPlayer: result is GameInProgress ? Player.o : Player.x,
      result: result,
    );
  }
}

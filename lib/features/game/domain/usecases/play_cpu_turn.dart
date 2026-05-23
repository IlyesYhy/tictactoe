import '../entities/game_result.dart';
import '../entities/game_session.dart';
import '../entities/player.dart';
import '../repositories/ai_repository.dart';
import '../services/game_engine.dart';

/// Handles the CPU player turn.
///
/// This use case asks the AI repository for the next move,
/// applies it to the board and evaluates the updated game result.
final class PlayCpuTurn {
  const PlayCpuTurn(this._aiRepository, this._gameEngine);

  final AiRepository _aiRepository;
  final GameEngine _gameEngine;

  Future<GameSession> call({required GameSession session}) async {
    if (session.isFinished) {
      throw StateError('Cannot play a move after the game is finished.');
    }

    if (session.currentPlayer != Player.o) {
      throw StateError('It is not the CPU player turn.');
    }

    final cellIndex = await _aiRepository.chooseMove(session.board);
    final updatedBoard = session.board.placeMove(
      index: cellIndex,
      player: Player.o,
    );
    final result = _gameEngine.evaluate(updatedBoard);

    return GameSession(
      board: updatedBoard,
      currentPlayer: result is GameInProgress ? Player.x : Player.o,
      result: result,
    );
  }
}

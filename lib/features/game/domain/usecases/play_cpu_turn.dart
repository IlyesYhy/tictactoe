import '../entities/game_roles.dart';
import '../entities/game_session.dart';
import '../repositories/cpu_repository.dart';
import '../services/game_engine.dart';

/// Handles the CPU player turn.
///
/// This use case asks the AI repository for the next move,
/// applies it to the board and evaluates the updated game result.
final class PlayCpuTurn {
  const PlayCpuTurn(this._cpuRepository, this._gameEngine);

  final CpuRepository _cpuRepository;
  final GameEngine _gameEngine;

  Future<GameSession> call({required GameSession session}) async {
    if (session.isFinished) {
      throw StateError('Cannot play a move after the game is finished.');
    }

    if (session.currentPlayer != cpuPlayer) {
      throw StateError('It is not the CPU player turn.');
    }

    final cellIndex = await _cpuRepository.chooseMove(session.board);
    final updatedBoard = session.board.placeMove(
      index: cellIndex,
      player: cpuPlayer,
    );
    final result = _gameEngine.evaluate(updatedBoard);

    return GameSession(
      board: updatedBoard,
      currentPlayer: humanPlayer,
      result: result,
    );
  }
}

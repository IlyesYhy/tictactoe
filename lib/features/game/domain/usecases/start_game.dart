import '../entities/board.dart';
import '../entities/game_result.dart';
import '../entities/game_session.dart';
import '../entities/player.dart';

/// Starts a new TicTacToe game session.
final class StartGame {
  const StartGame();

  GameSession call() {
    return GameSession(
      board: Board.empty(),
      currentPlayer: Player.x,
      result: const GameInProgress(),
    );
  }
}

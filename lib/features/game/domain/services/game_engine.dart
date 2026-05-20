import '../entities/board.dart';
import '../entities/cell.dart';
import '../entities/game_result.dart';
import '../entities/player.dart';

/// Centralizes TicTacToe game rules evaluation.
///
/// This service centralizes the game rules independently from Flutter
/// and remains fully testable in isolation.
///
/// A `const` constructor is used to allow lightweight instantiation
/// while keeping the service injectable.
final class GameEngine {
  const GameEngine();

  static const _winningPositions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  GameResult evaluate(Board board) {
    for (final position in _winningPositions) {
      final a = board.cells[position[0]];
      final b = board.cells[position[1]];
      final c = board.cells[position[2]];

      if (a != Cell.empty && a == b && b == c) {
        return GameWinner(_playerFromCell(a));
      }
    }

    if (board.isFull) {
      return const GameDraw();
    }

    return const GameInProgress();
  }

  Player _playerFromCell(Cell cell) {
    return switch (cell) {
      Cell.x => Player.x,
      Cell.o => Player.o,
      Cell.empty => throw ArgumentError(
        'An empty cell cannot be mapped to a player.',
      ),
    };
  }
}

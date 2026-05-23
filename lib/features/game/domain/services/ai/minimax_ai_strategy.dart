import '../../entities/board.dart';
import '../../entities/game_result.dart';
import '../../entities/game_roles.dart';
import '../game_engine.dart';
import 'ai_strategy.dart';

/// CPU strategy based on the Minimax algorithm.
///
/// TicTacToe is deterministic and has a small state space, making Minimax
/// a good fit to provide optimal local gameplay without external dependencies.
/// The CPU plays as [cpuPlayer] and evaluates the human as [humanPlayer].
///
/// Scores are adjusted by search depth so the CPU prefers faster wins and
/// delays unavoidable losses.
final class MinimaxAiStrategy implements AiStrategy {
  const MinimaxAiStrategy(this._gameEngine);

  final GameEngine _gameEngine;

  @override
  int chooseMove(Board board) {
    if (_gameEngine.evaluate(board) is! GameInProgress) {
      throw StateError('Cannot choose a move for a finished game.');
    }

    final availableMoves = board.availableMoves;

    if (availableMoves.isEmpty) {
      throw StateError('No move is available.');
    }

    var bestMove = availableMoves.first;
    var bestScore = _minScore;

    for (final move in availableMoves) {
      final nextBoard = board.placeMove(index: move, player: cpuPlayer);
      final score = _minimax(board: nextBoard, depth: 1, isAiTurn: false);

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  int _minimax({
    required Board board,
    required int depth,
    required bool isAiTurn,
  }) {
    final result = _gameEngine.evaluate(board);

    if (result is GameWinner) {
      return result.player == cpuPlayer ? 10 - depth : depth - 10;
    }

    if (result is GameDraw) {
      return 0;
    }

    final moves = board.availableMoves;

    if (isAiTurn) {
      var bestScore = _minScore;

      for (final move in moves) {
        final nextBoard = board.placeMove(index: move, player: cpuPlayer);
        final score = _minimax(
          board: nextBoard,
          depth: depth + 1,
          isAiTurn: false,
        );

        if (score > bestScore) {
          bestScore = score;
        }
      }

      return bestScore;
    }

    var bestScore = _maxScore;

    for (final move in moves) {
      final nextBoard = board.placeMove(index: move, player: humanPlayer);
      final score = _minimax(
        board: nextBoard,
        depth: depth + 1,
        isAiTurn: true,
      );

      if (score < bestScore) {
        bestScore = score;
      }
    }

    return bestScore;
  }
}

const _minScore = -1000;
const _maxScore = 1000;

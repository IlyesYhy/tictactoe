import 'package:equatable/equatable.dart';

import 'board.dart';
import 'game_result.dart';
import 'player.dart';

/// Represents the current state of a TicTacToe game.
///
/// It contains the board, the active player and the current game result.
final class GameSession extends Equatable {
  const GameSession({
    required this.board,
    required this.currentPlayer,
    required this.result,
  });

  final Board board;
  final Player currentPlayer;
  final GameResult result;

  bool get isFinished => result is! GameInProgress;

  GameSession copyWith({
    Board? board,
    Player? currentPlayer,
    GameResult? result,
  }) {
    return GameSession(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [board, currentPlayer, result];
}

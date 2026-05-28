import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_session.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';

void main() {
  group('GameSession', () {
    test('is not finished when game is in progress', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      expect(session.isFinished, isFalse);
    });

    test('is finished when game result is draw', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: const GameDraw(),
      );

      expect(session.isFinished, isTrue);
    });

    test('is finished when game has a winner', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: GameWinner(Player.x, [0, 1, 2]),
      );

      expect(session.isFinished, isTrue);
    });

    test('copyWith updates selected values only', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      final updatedBoard = Board.empty().placeMove(index: 0, player: Player.x);

      final updatedSession = session.copyWith(
        board: updatedBoard,
        currentPlayer: Player.o,
      );

      expect(updatedSession.board, updatedBoard);
      expect(updatedSession.currentPlayer, Player.o);
      expect(updatedSession.result, const GameInProgress());
    });
  });
}

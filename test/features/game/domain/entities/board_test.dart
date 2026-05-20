import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';

void main() {
  group('Board', () {
    test('creates an empty board', () {
      final board = Board.empty();

      expect(board.cells, List.filled(Board.size, Cell.empty));
    });

    test('places a move on an empty cell', () {
      final board = Board.empty();

      final updatedBoard = board.placeMove(index: 0, player: Player.x);

      expect(updatedBoard.cells[0], Cell.x);
    });

    test('returns a new board instance when placing a move', () {
      final board = Board.empty();

      final updatedBoard = board.placeMove(index: 0, player: Player.x);

      expect(updatedBoard, isNot(same(board)));
      expect(board.cells[0], Cell.empty);
      expect(updatedBoard.cells[0], Cell.x);
    });

    test('prevents placing a move on an occupied cell', () {
      final board = Board.empty().placeMove(index: 0, player: Player.x);

      expect(
        () => board.placeMove(index: 0, player: Player.o),
        throwsArgumentError,
      );
    });

    test('prevents placing a move outside the board', () {
      final board = Board.empty();

      expect(
        () => board.placeMove(index: -1, player: Player.x),
        throwsRangeError,
      );

      expect(
        () => board.placeMove(index: Board.size, player: Player.x),
        throwsRangeError,
      );
    });

    test('detects when the board is full', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 2, player: Player.x)
          .placeMove(index: 3, player: Player.o)
          .placeMove(index: 4, player: Player.x)
          .placeMove(index: 5, player: Player.o)
          .placeMove(index: 6, player: Player.x)
          .placeMove(index: 7, player: Player.o)
          .placeMove(index: 8, player: Player.x);

      expect(board.isFull, isTrue);
    });
  });
}

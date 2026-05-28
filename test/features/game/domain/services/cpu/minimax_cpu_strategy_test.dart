import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';
import 'package:tictactoe/features/game/domain/services/cpu/minimax_cpu_strategy.dart';
import 'package:tictactoe/features/game/domain/services/game_engine.dart';

void main() {
  group('MinimaxCpuStrategy', () {
    const strategy = MinimaxCpuStrategy(GameEngine());

    test('chooses a winning move when one is available', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.o)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 3, player: Player.x)
          .placeMove(index: 4, player: Player.x);

      final move = strategy.chooseMove(board);

      expect(move, 2);
    });

    test('blocks the human winning move when required', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 1, player: Player.x)
          .placeMove(index: 4, player: Player.o);

      final move = strategy.chooseMove(board);

      expect(move, 2);
    });

    test('chooses an edge to force a draw against opposite corners', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 4, player: Player.o)
          .placeMove(index: 8, player: Player.x);

      final move = strategy.chooseMove(board);

      expect(move, isIn([1, 3, 5, 7]));
    });

    test('chooses the only available move', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 2, player: Player.x)
          .placeMove(index: 3, player: Player.x)
          .placeMove(index: 4, player: Player.o)
          .placeMove(index: 5, player: Player.o)
          .placeMove(index: 6, player: Player.o)
          .placeMove(index: 7, player: Player.x);

      final move = strategy.chooseMove(board);

      expect(move, 8);
    });

    test('throws when no move is available', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 2, player: Player.x)
          .placeMove(index: 3, player: Player.x)
          .placeMove(index: 4, player: Player.o)
          .placeMove(index: 5, player: Player.o)
          .placeMove(index: 6, player: Player.o)
          .placeMove(index: 7, player: Player.x)
          .placeMove(index: 8, player: Player.x);

      expect(() => strategy.chooseMove(board), throwsStateError);
    });
  });
}

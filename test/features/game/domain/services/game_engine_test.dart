import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';
import 'package:tictactoe/features/game/domain/services/game_engine.dart';

void main() {
  group('GameEngine', () {
    const gameEngine = GameEngine();

    test(
      'returns in progress when there is no winner and board is not full',
      () {
        final board = Board.empty().placeMove(index: 0, player: Player.x);

        final result = gameEngine.evaluate(board);

        expect(result, const GameInProgress());
      },
    );

    test('detects row winner', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 1, player: Player.x)
          .placeMove(index: 2, player: Player.x);

      final result = gameEngine.evaluate(board);

      expect(result, const GameWinner(Player.x));
    });

    test('detects column winner', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.o)
          .placeMove(index: 3, player: Player.o)
          .placeMove(index: 6, player: Player.o);

      final result = gameEngine.evaluate(board);

      expect(result, const GameWinner(Player.o));
    });

    test('detects diagonal winner', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 4, player: Player.x)
          .placeMove(index: 8, player: Player.x);

      final result = gameEngine.evaluate(board);

      expect(result, const GameWinner(Player.x));
    });

    test('detects anti-diagonal winner', () {
      final board = Board.empty()
          .placeMove(index: 2, player: Player.o)
          .placeMove(index: 4, player: Player.o)
          .placeMove(index: 6, player: Player.o);

      final result = gameEngine.evaluate(board);

      expect(result, const GameWinner(Player.o));
    });

    test('detects draw when board is full and there is no winner', () {
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

      final result = gameEngine.evaluate(board);

      expect(result, const GameDraw());
    });
  });
}

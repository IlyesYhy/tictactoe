import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';
import 'package:tictactoe/features/game/domain/services/cpu/random_cpu_strategy.dart';

void main() {
  group('RandomCpuStrategy', () {
    test('returns a move from the available cells', () {
      final strategy = RandomCpuStrategy(random: Random(42));
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 4, player: Player.o);

      final move = strategy.chooseMove(board);

      expect(board.availableMoves, contains(move));
    });

    test('produces the same move for the same Random seed', () {
      final strategy1 = RandomCpuStrategy(random: Random(123));
      final strategy2 = RandomCpuStrategy(random: Random(123));
      final board = Board.empty();

      expect(strategy1.chooseMove(board), strategy2.chooseMove(board));
    });

    test('throws when no move is available', () {
      final strategy = RandomCpuStrategy(random: Random(42));
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

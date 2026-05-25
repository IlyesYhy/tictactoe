import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/data/repositories/local_cpu_repository.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';

void main() {
  group('LocalCpuRepository', () {
    const repository = LocalCpuRepository();

    test('delegates the move selection to the minimax strategy', () async {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.o)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 3, player: Player.x)
          .placeMove(index: 4, player: Player.x);

      final move = await repository.chooseMove(board);

      expect(move, 2);
    });
  });
}

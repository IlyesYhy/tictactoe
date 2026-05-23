import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/data/repositories/isolate_ai_repository.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';

void main() {
  group('IsolateAiRepository', () {
    const repository = IsolateAiRepository();

    test('chooses a move using the minimax strategy', () async {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.o)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 3, player: Player.x)
          .placeMove(index: 4, player: Player.x);

      final move = await repository.chooseMove(board);

      expect(move, 2);
    });

    test('throws when no move is available', () async {
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

      expect(() => repository.chooseMove(board), throwsStateError);
    });
  });
}

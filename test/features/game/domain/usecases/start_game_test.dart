import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';
import 'package:tictactoe/features/game/domain/usecases/start_game.dart';

void main() {
  group('StartGame', () {
    const startGame = StartGame();

    test('creates a new game session', () {
      final session = startGame();

      expect(session.board.cells, List.filled(9, Cell.empty));
      expect(session.currentPlayer, Player.x);
      expect(session.result, const GameInProgress());
      expect(session.isFinished, isFalse);
    });
  });
}

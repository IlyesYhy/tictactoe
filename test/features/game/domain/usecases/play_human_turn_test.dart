import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_session.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';
import 'package:tictactoe/features/game/domain/services/game_engine.dart';
import 'package:tictactoe/features/game/domain/usecases/play_human_turn.dart';

void main() {
  group('PlayHumanTurn', () {
    const playHumanTurn = PlayHumanTurn(GameEngine());

    test('places human move on selected cell', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      final updatedSession = playHumanTurn(session: session, cellIndex: 0);

      expect(updatedSession.board.cells[0], Cell.x);
    });

    test('switches current player to cpu when game continues', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      final updatedSession = playHumanTurn(session: session, cellIndex: 0);

      expect(updatedSession.currentPlayer, Player.o);
      expect(updatedSession.result, const GameInProgress());
    });

    test('returns human winner when move completes a winning line', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 1, player: Player.x)
          .placeMove(index: 3, player: Player.o)
          .placeMove(index: 4, player: Player.o);

      final session = GameSession(
        board: board,
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      final updatedSession = playHumanTurn(session: session, cellIndex: 2);

      expect(updatedSession.result, GameWinner(Player.x, [0, 1, 2]));
      expect(updatedSession.isFinished, isTrue);
      expect(updatedSession.currentPlayer, Player.o);
    });

    test('returns draw when human move fills the board without winner', () {
      final board = Board.empty()
          .placeMove(index: 0, player: Player.x)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 2, player: Player.x)
          .placeMove(index: 3, player: Player.x)
          .placeMove(index: 4, player: Player.o)
          .placeMove(index: 5, player: Player.o)
          .placeMove(index: 6, player: Player.o)
          .placeMove(index: 7, player: Player.x);

      final session = GameSession(
        board: board,
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      final updatedSession = playHumanTurn(session: session, cellIndex: 8);

      expect(updatedSession.result, const GameDraw());
      expect(updatedSession.isFinished, isTrue);
    });

    test('prevents human move when game is already finished', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: GameWinner(Player.o, [0, 1, 2]),
      );

      expect(
        () => playHumanTurn(session: session, cellIndex: 0),
        throwsStateError,
      );
    });

    test('prevents human move when it is not human turn', () {
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.o,
        result: const GameInProgress(),
      );

      expect(
        () => playHumanTurn(session: session, cellIndex: 0),
        throwsStateError,
      );
    });

    test('prevents human move on occupied cell', () {
      final board = Board.empty().placeMove(index: 0, player: Player.o);

      final session = GameSession(
        board: board,
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      expect(
        () => playHumanTurn(session: session, cellIndex: 0),
        throwsArgumentError,
      );
    });
  });
}

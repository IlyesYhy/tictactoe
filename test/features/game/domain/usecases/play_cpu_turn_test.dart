import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_session.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';
import 'package:tictactoe/features/game/domain/repositories/cpu_repository.dart';
import 'package:tictactoe/features/game/domain/services/game_engine.dart';
import 'package:tictactoe/features/game/domain/usecases/play_cpu_turn.dart';

void main() {
  group('PlayCpuTurn', () {
    test('places CPU move on selected cell', () async {
      final playCpuTurn = PlayCpuTurn(
        _FakeCpuRepository(0),
        const GameEngine(),
      );
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.o,
        result: const GameInProgress(),
      );

      final updatedSession = await playCpuTurn(session: session);

      expect(updatedSession.board.cells[0], Cell.o);
    });

    test('switches current player to human when game continues', () async {
      final playCpuTurn = PlayCpuTurn(
        _FakeCpuRepository(0),
        const GameEngine(),
      );
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.o,
        result: const GameInProgress(),
      );

      final updatedSession = await playCpuTurn(session: session);

      expect(updatedSession.currentPlayer, Player.x);
      expect(updatedSession.result, const GameInProgress());
    });

    test('returns CPU winner when move completes a winning line', () async {
      final playCpuTurn = PlayCpuTurn(
        _FakeCpuRepository(2),
        const GameEngine(),
      );
      final board = Board.empty()
          .placeMove(index: 0, player: Player.o)
          .placeMove(index: 1, player: Player.o)
          .placeMove(index: 3, player: Player.x)
          .placeMove(index: 4, player: Player.x);

      final session = GameSession(
        board: board,
        currentPlayer: Player.o,
        result: const GameInProgress(),
      );

      final updatedSession = await playCpuTurn(session: session);

      expect(updatedSession.result, const GameWinner(Player.o));
      expect(updatedSession.isFinished, isTrue);
      expect(updatedSession.currentPlayer, Player.x);
    });

    test('returns draw when CPU fills the last available cell', () async {
      final playCpuTurn = PlayCpuTurn(
        _FakeCpuRepository(8),
        const GameEngine(),
      );

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
        currentPlayer: Player.o,
        result: const GameInProgress(),
      );

      final updatedSession = await playCpuTurn(session: session);

      expect(updatedSession.result, const GameDraw());
      expect(updatedSession.isFinished, isTrue);
      expect(updatedSession.currentPlayer, Player.x);
    });

    test('prevents CPU move when game is already finished', () async {
      final playCpuTurn = PlayCpuTurn(
        _FakeCpuRepository(0),
        const GameEngine(),
      );
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.o,
        result: const GameWinner(Player.x),
      );

      await expectLater(playCpuTurn(session: session), throwsStateError);
    });

    test('prevents CPU move when it is not CPU turn', () async {
      final playCpuTurn = PlayCpuTurn(
        _FakeCpuRepository(0),
        const GameEngine(),
      );
      final session = GameSession(
        board: Board.empty(),
        currentPlayer: Player.x,
        result: const GameInProgress(),
      );

      await expectLater(playCpuTurn(session: session), throwsStateError);
    });
  });
}

final class _FakeCpuRepository implements CpuRepository {
  const _FakeCpuRepository(this._move);

  final int _move;

  @override
  Future<int> chooseMove(Board board) async => _move;
}

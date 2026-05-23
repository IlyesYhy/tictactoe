import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_session.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';
import 'package:tictactoe/features/game/presentation/states/game_controller_state.dart';

void main() {
  group('GameControllerState', () {
    final initialSession = GameSession(
      board: Board.empty(),
      currentPlayer: Player.x,
      result: const GameInProgress(),
    );

    final advancedSession = GameSession(
      board: Board.empty().placeMove(index: 0, player: Player.x),
      currentPlayer: Player.o,
      result: const GameInProgress(),
    );

    test('copyWith updates the session only', () {
      final state = GameControllerState(
        session: initialSession,
        isCpuThinking: false,
      );

      final updated = state.copyWith(session: advancedSession);

      expect(updated.session, advancedSession);
      expect(updated.isCpuThinking, false);
    });

    test('copyWith updates isCpuThinking only', () {
      final state = GameControllerState(
        session: initialSession,
        isCpuThinking: false,
      );

      final updated = state.copyWith(isCpuThinking: true);

      expect(updated.session, initialSession);
      expect(updated.isCpuThinking, true);
    });

    test('copyWith without arguments returns an equal state', () {
      final state = GameControllerState(
        session: initialSession,
        isCpuThinking: false,
      );

      expect(state.copyWith(), state);
    });

    test('considers two states with same fields equal', () {
      final a = GameControllerState(
        session: initialSession,
        isCpuThinking: true,
      );
      final b = GameControllerState(
        session: initialSession,
        isCpuThinking: true,
      );

      expect(a, b);
    });

    test('does not consider states with different fields equal', () {
      final a = GameControllerState(
        session: initialSession,
        isCpuThinking: false,
      );
      final b = GameControllerState(
        session: initialSession,
        isCpuThinking: true,
      );
      final c = GameControllerState(
        session: advancedSession,
        isCpuThinking: false,
      );

      expect(a, isNot(b));
      expect(a, isNot(c));
    });
  });
}

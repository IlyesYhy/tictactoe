import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/player.dart';

void main() {
  group('GameWinner', () {
    test('equality includes the winning line', () {
      expect(
        GameWinner(Player.x, [0, 1, 2]),
        isNot(GameWinner(Player.x, [3, 4, 5])),
      );
    });

    test('exposes an immutable winning line', () {
      final winner = GameWinner(Player.x, [0, 1, 2]);

      expect(() => winner.winningLine[0] = 99, throwsUnsupportedError);
    });
  });
}

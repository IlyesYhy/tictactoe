import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';

void main() {
  group('GameDifficulty', () {
    test('fromName returns the matching difficulty', () {
      expect(GameDifficulty.fromName('easy'), GameDifficulty.easy);
      expect(GameDifficulty.fromName('hard'), GameDifficulty.hard);
    });

    test('fromName returns null for an unknown name', () {
      expect(GameDifficulty.fromName('unknown'), isNull);
    });
  });
}

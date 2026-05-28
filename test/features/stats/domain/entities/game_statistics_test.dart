import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';

void main() {
  group('GameStatistics', () {
    test('empty returns zero counters', () {
      final stats = GameStatistics.empty();

      expect(stats.victories, 0);
      expect(stats.defeats, 0);
      expect(stats.draws, 0);
    });

    test('totalMatches returns the sum of all outcomes', () {
      const stats = GameStatistics(victories: 4, defeats: 2, draws: 1);

      expect(stats.totalMatches, 7);
    });

    test('winRate returns 0 when there are no matches', () {
      final stats = GameStatistics.empty();

      expect(stats.winRate, 0);
    });

    test('winRate returns victories divided by total matches', () {
      const stats = GameStatistics(victories: 3, defeats: 1, draws: 1);

      expect(stats.winRate, closeTo(0.6, 0.0001));
    });
  });
}

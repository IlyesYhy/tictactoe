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

    test('percentages return 0 when there are no matches', () {
      final stats = GameStatistics.empty();

      expect(stats.victoryPercentage, 0);
      expect(stats.drawPercentage, 0);
      expect(stats.defeatPercentage, 0);
    });

    test('percentages round each outcome share of the total', () {
      // 3 / 6 = 50%, 1 / 6 = 16.67% -> 17%, 2 / 6 = 33.33% -> 33%.
      const stats = GameStatistics(victories: 3, defeats: 2, draws: 1);

      expect(stats.victoryPercentage, 50);
      expect(stats.drawPercentage, 17);
      expect(stats.defeatPercentage, 33);
    });
  });
}

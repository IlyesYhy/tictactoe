import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';

void main() {
  group('MatchOutcome', () {
    test('fromName returns the matching outcome', () {
      expect(MatchOutcome.fromName('humanWon'), MatchOutcome.humanWon);
      expect(MatchOutcome.fromName('cpuWon'), MatchOutcome.cpuWon);
      expect(MatchOutcome.fromName('draw'), MatchOutcome.draw);
    });

    test('fromName returns null for an unknown name', () {
      expect(MatchOutcome.fromName('unknown'), isNull);
    });
  });
}

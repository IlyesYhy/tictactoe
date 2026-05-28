import 'package:equatable/equatable.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';

import 'completed_match.dart';
import 'game_statistics.dart';
import 'match_outcome.dart';

final class MatchHistory extends Equatable {
  MatchHistory(Iterable<CompletedMatch> matches)
    : matches = List.unmodifiable(matches);

  factory MatchHistory.empty() => MatchHistory(const <CompletedMatch>[]);

  final List<CompletedMatch> matches;

  GameStatistics get statistics => _statisticsFor(matches);

  /// Aggregates the outcomes of matches played at [difficulty].
  GameStatistics statisticsForDifficulty(GameDifficulty difficulty) {
    return _statisticsFor(matches.where((m) => m.difficulty == difficulty));
  }

  static GameStatistics _statisticsFor(Iterable<CompletedMatch> source) {
    var victories = 0;
    var defeats = 0;
    var draws = 0;

    for (final match in source) {
      switch (match.outcome) {
        case MatchOutcome.humanWon:
          victories++;
        case MatchOutcome.cpuWon:
          defeats++;
        case MatchOutcome.draw:
          draws++;
      }
    }

    return GameStatistics(victories: victories, defeats: defeats, draws: draws);
  }

  @override
  List<Object?> get props => [matches];
}

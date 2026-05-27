import 'package:equatable/equatable.dart';

import 'completed_match.dart';
import 'game_statistics.dart';
import 'match_outcome.dart';

final class MatchHistory extends Equatable {
  MatchHistory(Iterable<CompletedMatch> matches)
    : matches = List.unmodifiable(matches);

  factory MatchHistory.empty() => MatchHistory(const <CompletedMatch>[]);

  final List<CompletedMatch> matches;

  GameStatistics get statistics {
    var victories = 0;
    var defeats = 0;
    var draws = 0;

    for (final match in matches) {
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

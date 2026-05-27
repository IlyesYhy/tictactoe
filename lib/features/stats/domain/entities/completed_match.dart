import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/game_difficulty.dart';
import 'match_outcome.dart';

final class CompletedMatch extends Equatable {
  const CompletedMatch({
    required this.outcome,
    required this.difficulty,
    required this.playedAt,
  });

  final MatchOutcome outcome;
  final GameDifficulty difficulty;
  final DateTime playedAt;

  @override
  List<Object?> get props => [outcome, difficulty, playedAt];
}

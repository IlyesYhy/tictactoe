import 'package:equatable/equatable.dart';

final class GameStatistics extends Equatable {
  const GameStatistics({
    required this.victories,
    required this.defeats,
    required this.draws,
  });

  factory GameStatistics.empty() =>
      const GameStatistics(victories: 0, defeats: 0, draws: 0);

  final int victories;
  final int defeats;
  final int draws;

  int get totalMatches => victories + defeats + draws;

  double get winRate => totalMatches == 0 ? 0.0 : victories / totalMatches;

  @override
  List<Object?> get props => [victories, defeats, draws];
}

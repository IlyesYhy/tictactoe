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

  int get victoryPercentage => _percentageOf(victories);

  int get drawPercentage => _percentageOf(draws);

  int get defeatPercentage => _percentageOf(defeats);

  int _percentageOf(int count) =>
      totalMatches == 0 ? 0 : ((count / totalMatches) * 100).round();

  @override
  List<Object?> get props => [victories, defeats, draws];
}

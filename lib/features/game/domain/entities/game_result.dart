import 'package:equatable/equatable.dart';

import 'player.dart';

sealed class GameResult extends Equatable {
  const GameResult();
  @override
  List<Object?> get props => [];
}

final class GameInProgress extends GameResult {
  const GameInProgress();
}

final class GameDraw extends GameResult {
  const GameDraw();
}

final class GameWinner extends GameResult {
  GameWinner(this.player, List<int> winningLine)
    : winningLine = List.unmodifiable(winningLine);

  final Player player;
  final List<int> winningLine;

  @override
  List<Object?> get props => [player, winningLine];
}

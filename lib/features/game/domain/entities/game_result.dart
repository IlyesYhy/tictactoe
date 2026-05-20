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
  const GameWinner(this.player);

  final Player player;
}

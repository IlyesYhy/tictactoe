import 'player.dart';

enum Cell {
  empty,
  x,
  o;

  factory Cell.fromPlayer(Player player) {
    return switch (player) {
      Player.x => Cell.x,
      Player.o => Cell.o,
    };
  }
  bool get isEmpty => this == Cell.empty;
}

import 'dart:math';

import '../../entities/board.dart';
import 'cpu_strategy.dart';

/// CPU strategy that picks a uniformly random empty cell.
///
/// Used to back the easy difficulty: predictable behavior, no foresight,
/// easy to beat for a human player.
///
/// The [Random] source can be injected to make tests deterministic.
final class RandomCpuStrategy implements CpuStrategy {
  RandomCpuStrategy({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  int chooseMove(Board board) {
    final availableMoves = board.availableMoves;

    if (availableMoves.isEmpty) {
      throw StateError('No move is available.');
    }

    final pickedIndex = _random.nextInt(availableMoves.length);
    return availableMoves[pickedIndex];
  }
}

import '../../entities/board.dart';

/// Defines how the CPU selects its next move.
abstract interface class AiStrategy {
  int chooseMove(Board board);
}

import '../../entities/board.dart';

/// Defines how the CPU selects its next move.
abstract interface class CpuStrategy {
  int chooseMove(Board board);
}

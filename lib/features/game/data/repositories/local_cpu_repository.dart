import '../../domain/entities/board.dart';
import '../../domain/repositories/cpu_repository.dart';
import '../../domain/services/cpu/minimax_cpu_strategy.dart';
import '../../domain/services/game_engine.dart';

/// Executes CPU move calculation directly on the current isolate.
///
/// The minimax search on a 3x3 board is small enough to run synchronously
/// without blocking the UI, so the additional cost of spawning an isolate
/// is avoided. The [CpuRepository] abstraction is kept so a heavier strategy
/// can later swap this implementation for an isolate or remote variant
/// without impacting the use cases.
final class LocalCpuRepository implements CpuRepository {
  const LocalCpuRepository();

  @override
  Future<int> chooseMove(Board board) async {
    const strategy = MinimaxCpuStrategy(GameEngine());
    return strategy.chooseMove(board);
  }
}

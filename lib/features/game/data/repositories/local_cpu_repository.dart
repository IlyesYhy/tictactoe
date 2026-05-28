import '../../domain/entities/board.dart';
import '../../domain/repositories/cpu_repository.dart';
import '../../domain/services/cpu/cpu_strategy.dart';

/// Executes a [CpuStrategy] directly on the current isolate.
///
/// This implementation is intentionally agnostic to the selected strategy:
/// the composition root decides which one to inject (random for easy,
/// minimax for hard, etc.).
///
/// Keeping the execution local avoids the overhead of spawning an isolate on
/// a 3x3 board, where the supported strategies are expected to run very fast.
final class LocalCpuRepository implements CpuRepository {
  const LocalCpuRepository(this._strategy);

  final CpuStrategy _strategy;

  @override
  Future<int> chooseMove(Board board) {
    return Future.sync(() => _strategy.chooseMove(board));
  }
}

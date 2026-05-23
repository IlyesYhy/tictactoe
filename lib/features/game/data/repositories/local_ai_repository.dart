import '../../domain/entities/board.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/services/ai/minimax_ai_strategy.dart';
import '../../domain/services/game_engine.dart';

/// Executes AI move calculation directly on the current isolate.
///
/// The minimax search on a 3x3 board is small enough to run synchronously
/// without blocking the UI, so the additional cost of spawning an isolate
/// is avoided. The [AiRepository] abstraction is kept so a heavier strategy
/// can later swap this implementation for an isolate or remote variant
/// without impacting the use cases.
final class LocalAiRepository implements AiRepository {
  const LocalAiRepository();

  @override
  Future<int> chooseMove(Board board) async {
    const strategy = MinimaxAiStrategy(GameEngine());
    return strategy.chooseMove(board);
  }
}

import 'dart:isolate';

import '../../domain/entities/board.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/services/ai/minimax_ai_strategy.dart';
import '../../domain/services/game_engine.dart';

/// Executes AI move calculation in a separate isolate.
///
/// The domain layer depends only on [AiRepository] and remains unaware
/// of how the move is computed.
///
/// This implementation uses an isolate, but it could later be replaced
/// by a remote service or another AI engine without impacting the use cases.
final class IsolateAiRepository implements AiRepository {
  const IsolateAiRepository();

  @override
  Future<int> chooseMove(Board board) {
    return Isolate.run(() {
      const gameEngine = GameEngine();
      const strategy = MinimaxAiStrategy(gameEngine);

      return strategy.chooseMove(board);
    });
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/entities/game_difficulty.dart';
import '../data/repositories/local_cpu_repository.dart';
import '../domain/repositories/cpu_repository.dart';
import '../domain/services/cpu/minimax_cpu_strategy.dart';
import '../domain/services/cpu/random_cpu_strategy.dart';
import '../domain/services/game_engine.dart';
import '../domain/usecases/play_cpu_turn.dart';
import '../domain/usecases/play_human_turn.dart';
import '../domain/usecases/start_game.dart';

final gameEngineProvider = Provider<GameEngine>((ref) => const GameEngine());

final class DifficultyController extends Notifier<GameDifficulty> {
  @override
  GameDifficulty build() => GameDifficulty.easy;

  void select(GameDifficulty difficulty) {
    state = difficulty;
  }
}

final difficultyProvider =
    NotifierProvider<DifficultyController, GameDifficulty>(
      DifficultyController.new,
    );

/// Repository keyed by [GameDifficulty] so the chosen strategy is captured
/// at game start and stays stable for the lifetime of that game.
///
/// Reading [difficultyProvider] reactively here would let the CPU swap
/// strategies mid-match if the user changed difficulty during a game.
final cpuRepositoryProvider = Provider.family<CpuRepository, GameDifficulty>((
  ref,
  difficulty,
) {
  final gameEngine = ref.watch(gameEngineProvider);

  final strategy = switch (difficulty) {
    GameDifficulty.easy => RandomCpuStrategy(),
    GameDifficulty.hard => MinimaxCpuStrategy(gameEngine),
  };

  return LocalCpuRepository(strategy);
});

final startGameProvider = Provider<StartGame>((ref) => const StartGame());

final playHumanTurnProvider = Provider<PlayHumanTurn>(
  (ref) => PlayHumanTurn(ref.watch(gameEngineProvider)),
);

final playCpuTurnProvider = Provider.family<PlayCpuTurn, GameDifficulty>((
  ref,
  difficulty,
) {
  return PlayCpuTurn(
    ref.watch(cpuRepositoryProvider(difficulty)),
    ref.watch(gameEngineProvider),
  );
});

final cpuThinkingDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 450),
);

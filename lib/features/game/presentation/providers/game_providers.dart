import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/local_ai_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/services/game_engine.dart';
import '../../domain/usecases/play_cpu_turn.dart';
import '../../domain/usecases/play_human_turn.dart';
import '../../domain/usecases/start_game.dart';

final gameEngineProvider = Provider<GameEngine>((ref) => const GameEngine());

final aiRepositoryProvider = Provider<AiRepository>(
  (ref) => const LocalAiRepository(),
);

final startGameProvider = Provider<StartGame>((ref) => const StartGame());

final playHumanTurnProvider = Provider<PlayHumanTurn>(
  (ref) => PlayHumanTurn(ref.watch(gameEngineProvider)),
);

final playCpuTurnProvider = Provider<PlayCpuTurn>(
  (ref) => PlayCpuTurn(
    ref.watch(aiRepositoryProvider),
    ref.watch(gameEngineProvider),
  ),
);

final cpuThinkingDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 450),
);

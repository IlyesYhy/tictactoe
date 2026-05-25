import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/local_cpu_repository.dart';
import '../../domain/repositories/cpu_repository.dart';
import '../../domain/services/game_engine.dart';
import '../../domain/usecases/play_cpu_turn.dart';
import '../../domain/usecases/play_human_turn.dart';
import '../../domain/usecases/start_game.dart';

final gameEngineProvider = Provider<GameEngine>((ref) => const GameEngine());

final cpuRepositoryProvider = Provider<CpuRepository>(
  (ref) => const LocalCpuRepository(),
);

final startGameProvider = Provider<StartGame>((ref) => const StartGame());

final playHumanTurnProvider = Provider<PlayHumanTurn>(
  (ref) => PlayHumanTurn(ref.watch(gameEngineProvider)),
);

final playCpuTurnProvider = Provider<PlayCpuTurn>(
  (ref) => PlayCpuTurn(
    ref.watch(cpuRepositoryProvider),
    ref.watch(gameEngineProvider),
  ),
);

final cpuThinkingDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 450),
);

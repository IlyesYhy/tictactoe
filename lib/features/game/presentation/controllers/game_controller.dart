import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/game_providers.dart';
import '../../domain/entities/game_result.dart';
import '../states/game_controller_state.dart';

final gameControllerProvider =
    NotifierProvider<GameController, GameControllerState>(GameController.new);

final class GameController extends Notifier<GameControllerState> {
  @override
  GameControllerState build() {
    final startGame = ref.watch(startGameProvider);
    final difficulty = ref.read(difficultyProvider);

    return GameControllerState(
      session: startGame(),
      difficulty: difficulty,
      isCpuThinking: false,
    );
  }

  Future<void> playHumanTurn(int cellIndex) async {
    if (state.isCpuThinking || state.session.isFinished) {
      return;
    }

    if (!state.session.board.isCellEmpty(cellIndex)) {
      return;
    }

    final playHumanTurn = ref.read(playHumanTurnProvider);
    final playCpuTurn = ref.read(playCpuTurnProvider(state.difficulty));

    final humanSession = playHumanTurn(
      session: state.session,
      cellIndex: cellIndex,
    );

    if (humanSession.result is! GameInProgress) {
      state = state.copyWith(session: humanSession);
      return;
    }

    state = state.copyWith(session: humanSession, isCpuThinking: true);

    final (cpuSession, _) = await (
      playCpuTurn(session: humanSession),
      Future<void>.delayed(ref.read(cpuThinkingDelayProvider)),
    ).wait;

    state = state.copyWith(session: cpuSession, isCpuThinking: false);
  }

  void resetGame() {
    final startGame = ref.read(startGameProvider);
    final difficulty = ref.read(difficultyProvider);

    state = GameControllerState(
      session: startGame(),
      difficulty: difficulty,
      isCpuThinking: false,
    );
  }
}

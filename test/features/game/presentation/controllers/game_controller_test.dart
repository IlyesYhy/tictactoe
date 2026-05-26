import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/di/game_providers.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';
import 'package:tictactoe/features/game/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_roles.dart';
import 'package:tictactoe/features/game/domain/repositories/cpu_repository.dart';
import 'package:tictactoe/features/game/presentation/controllers/game_controller.dart';

void main() {
  ProviderContainer createContainer({
    required CpuRepository cpuRepository,
    Duration cpuThinkingDelay = Duration.zero,
  }) {
    final container = ProviderContainer(
      overrides: [
        cpuRepositoryProvider.overrideWith((ref, difficulty) => cpuRepository),
        cpuThinkingDelayProvider.overrideWithValue(cpuThinkingDelay),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('GameController', () {
    test('starts with an empty board and the human to play', () {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([]),
      );

      final state = container.read(gameControllerProvider);

      expect(state.session.board.cells, List.filled(Board.size, Cell.empty));
      expect(state.session.currentPlayer, humanPlayer);
      expect(state.session.result, const GameInProgress());
      expect(state.isCpuThinking, isFalse);
    });

    test('plays the human move and chains the CPU move', () async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4]),
      );
      final controller = container.read(gameControllerProvider.notifier);

      await controller.playHumanTurn(0);
      final state = container.read(gameControllerProvider);

      expect(state.session.board.cells[0], Cell.x);
      expect(state.session.board.cells[4], Cell.o);
      expect(state.session.currentPlayer, humanPlayer);
      expect(state.session.result, const GameInProgress());
      expect(state.isCpuThinking, isFalse);
    });

    test('keeps the CPU thinking badge visible for at least the configured '
        'delay', () async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4]),
        cpuThinkingDelay: const Duration(milliseconds: 100),
      );
      final controller = container.read(gameControllerProvider.notifier);
      final stopwatch = Stopwatch()..start();

      await controller.playHumanTurn(0);

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(100));
      expect(container.read(gameControllerProvider).isCpuThinking, isFalse);
      expect(
        container.read(gameControllerProvider).session.board.cells[4],
        Cell.o,
      );
    });

    test('flags isCpuThinking while the CPU turn is in flight', () async {
      final repository = _ControlledCpuRepository(4);
      addTearDown(repository.completeIfPending);
      final container = createContainer(cpuRepository: repository);
      final controller = container.read(gameControllerProvider.notifier);

      final pending = controller.playHumanTurn(0);

      final midState = container.read(gameControllerProvider);
      expect(midState.session.board.cells[0], Cell.x);
      expect(midState.isCpuThinking, isTrue);

      repository.completer.complete();
      await pending;

      final finalState = container.read(gameControllerProvider);
      expect(finalState.session.board.cells[4], Cell.o);
      expect(finalState.isCpuThinking, isFalse);
    });

    test('does not chain the CPU turn when the human wins', () async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4, 8]),
      );
      final controller = container.read(gameControllerProvider.notifier);

      await controller.playHumanTurn(0);
      await controller.playHumanTurn(1);
      await controller.playHumanTurn(2);

      final state = container.read(gameControllerProvider);

      expect(state.session.result, GameWinner(humanPlayer, [0, 1, 2]));
      expect(state.session.isFinished, isTrue);
      expect(state.isCpuThinking, isFalse);
      expect(state.session.board.cells[0], Cell.x);
      expect(state.session.board.cells[1], Cell.x);
      expect(state.session.board.cells[2], Cell.x);
    });

    test('returns draw when the board becomes full', () async {
      // X plays 0,2,3,7,5 ; CPU plays 4,1,6,8. Board ends full without winner.
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4, 1, 6, 8]),
      );
      final controller = container.read(gameControllerProvider.notifier);

      await controller.playHumanTurn(0);
      await controller.playHumanTurn(2);
      await controller.playHumanTurn(3);
      await controller.playHumanTurn(7);
      await controller.playHumanTurn(5);

      final state = container.read(gameControllerProvider);

      expect(state.session.result, const GameDraw());
      expect(state.session.isFinished, isTrue);
      expect(state.isCpuThinking, isFalse);
    });

    test('ignores input while the CPU is thinking', () async {
      final repository = _ControlledCpuRepository(4);
      addTearDown(repository.completeIfPending);
      final container = createContainer(cpuRepository: repository);
      final controller = container.read(gameControllerProvider.notifier);

      final firstTurn = controller.playHumanTurn(0);
      expect(container.read(gameControllerProvider).isCpuThinking, isTrue);

      await controller.playHumanTurn(1);

      expect(
        container.read(gameControllerProvider).session.board.cells[1],
        Cell.empty,
      );

      repository.completer.complete();
      await firstTurn;
    });

    test('ignores input after the game is finished', () async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4, 8]),
      );
      final controller = container.read(gameControllerProvider.notifier);

      await controller.playHumanTurn(0);
      await controller.playHumanTurn(1);
      await controller.playHumanTurn(2);

      final snapshot = container.read(gameControllerProvider);
      await controller.playHumanTurn(3);

      expect(container.read(gameControllerProvider), snapshot);
    });

    test('ignores input on an already occupied cell', () async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4]),
      );
      final controller = container.read(gameControllerProvider.notifier);

      await controller.playHumanTurn(0);
      final snapshot = container.read(gameControllerProvider);

      await controller.playHumanTurn(0);
      await controller.playHumanTurn(4);

      expect(container.read(gameControllerProvider), snapshot);
    });

    test('resetGame restores the initial state', () async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4]),
      );
      final controller = container.read(gameControllerProvider.notifier);

      await controller.playHumanTurn(0);
      controller.resetGame();

      final state = container.read(gameControllerProvider);

      expect(state.session.board.cells, List.filled(Board.size, Cell.empty));
      expect(state.session.currentPlayer, humanPlayer);
      expect(state.session.result, const GameInProgress());
      expect(state.isCpuThinking, isFalse);
    });

    group('difficulty capture', () {
      ProviderContainer createContainerWithPerDifficultyRepositories() {
        const easyRepository = _SequenceCpuRepository([4]);
        const hardRepository = _SequenceCpuRepository([7]);

        final container = ProviderContainer(
          overrides: [
            cpuRepositoryProvider.overrideWith(
              (ref, difficulty) => difficulty == GameDifficulty.easy
                  ? easyRepository
                  : hardRepository,
            ),
            cpuThinkingDelayProvider.overrideWithValue(Duration.zero),
          ],
        );
        addTearDown(container.dispose);
        return container;
      }

      test(
        'keeps the captured difficulty stable when difficultyProvider changes '
        'mid-game',
        () async {
          final container = createContainerWithPerDifficultyRepositories();

          expect(
            container.read(gameControllerProvider).difficulty,
            GameDifficulty.easy,
          );

          container
              .read(difficultyProvider.notifier)
              .select(GameDifficulty.hard);

          await container
              .read(gameControllerProvider.notifier)
              .playHumanTurn(0);

          final state = container.read(gameControllerProvider);
          expect(state.difficulty, GameDifficulty.easy);
          expect(state.session.board.cells[4], Cell.o);
          expect(state.session.board.cells[7], Cell.empty);
        },
      );

      test('resetGame captures the latest selected difficulty', () async {
        final container = createContainerWithPerDifficultyRepositories();

        expect(
          container.read(gameControllerProvider).difficulty,
          GameDifficulty.easy,
        );

        container.read(difficultyProvider.notifier).select(GameDifficulty.hard);
        container.read(gameControllerProvider.notifier).resetGame();

        expect(
          container.read(gameControllerProvider).difficulty,
          GameDifficulty.hard,
        );

        await container.read(gameControllerProvider.notifier).playHumanTurn(0);

        final state = container.read(gameControllerProvider);
        expect(state.session.board.cells[7], Cell.o);
        expect(state.session.board.cells[4], Cell.empty);
      });
    });
  });
}

final class _SequenceCpuRepository implements CpuRepository {
  const _SequenceCpuRepository(this._moves);

  final List<int> _moves;

  @override
  Future<int> chooseMove(Board board) async {
    final usedMoves = board.cells.where((cell) => cell == Cell.o).length;
    if (usedMoves >= _moves.length) {
      throw StateError('No fake CPU move available for this board state.');
    }
    return _moves[usedMoves];
  }
}

final class _ControlledCpuRepository implements CpuRepository {
  _ControlledCpuRepository(this._move);

  final int _move;
  final Completer<void> completer = Completer<void>();

  void completeIfPending() {
    if (!completer.isCompleted) {
      completer.complete();
    }
  }

  @override
  Future<int> chooseMove(Board board) async {
    await completer.future;
    return _move;
  }
}

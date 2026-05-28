import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/core/di/current_date_time_provider.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/game/di/game_providers.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';
import 'package:tictactoe/features/game/domain/repositories/cpu_repository.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_cell.dart';
import 'package:tictactoe/features/game/presentation/widgets/restart_game_button.dart';
import 'package:tictactoe/features/settings/di/settings_providers.dart';
import 'package:tictactoe/features/settings/domain/entities/app_language.dart';
import 'package:tictactoe/features/settings/domain/entities/app_settings.dart';
import 'package:tictactoe/features/settings/domain/entities/app_theme_mode.dart';
import 'package:tictactoe/features/stats/di/stats_providers.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_history.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/domain/repositories/stats_repository.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  const turnSettleDuration = Duration(milliseconds: 100);

  ProviderContainer createContainer({
    required CpuRepository cpuRepository,
    StatsRepository? statsRepository,
  }) {
    final container = ProviderContainer(
      overrides: [
        cpuRepositoryProvider.overrideWith((ref, difficulty) => cpuRepository),
        cpuThinkingDelayProvider.overrideWithValue(Duration.zero),
        initialSettingsProvider.overrideWithValue(
          const AppSettings(
            language: AppLanguage.en,
            themeMode: AppThemeMode.system,
          ),
        ),
        statsRepositoryProvider.overrideWithValue(
          statsRepository ?? _NoopStatsRepository(),
        ),
        initialMatchHistoryProvider.overrideWithValue(MatchHistory.empty()),
        currentDateTimeProvider.overrideWithValue(
          () => DateTime(2026, 5, 27, 12),
        ),
      ],
    );

    addTearDown(container.dispose);

    return container;
  }

  Future<void> pumpGamePage(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const GamePage(),
        ),
      ),
    );
  }

  Future<void> tapCell(WidgetTester tester, int index) async {
    await tester.tap(find.byType(GameCell).at(index));
    await tester.pump();
    await tester.pump(turnSettleDuration);
  }

  group('GamePage end-game flow', () {
    testWidgets('shows confetti when the human wins', (tester) async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([3, 6]),
      );

      await pumpGamePage(tester, container);

      // Human plays the diagonal 0, 4, 8. CPU fills 3 then 6.
      await tapCell(tester, 0);
      await tapCell(tester, 4);
      await tapCell(tester, 8);

      expect(find.byType(ConfettiWidget), findsOneWidget);
    });

    testWidgets('does not show confetti when the CPU wins', (tester) async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([0, 1, 2]),
      );

      await pumpGamePage(tester, container);

      // Human plays safe cells. CPU completes the top row 0, 1, 2.
      await tapCell(tester, 3);
      await tapCell(tester, 4);
      await tapCell(tester, 8);

      expect(find.byType(ConfettiWidget), findsNothing);
    });

    testWidgets('highlights winning cells after human wins', (tester) async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([3, 6]),
      );

      await pumpGamePage(tester, container);

      await tapCell(tester, 0);
      await tapCell(tester, 4);
      await tapCell(tester, 8);

      const winningLine = [0, 4, 8];

      for (var index = 0; index < Board.size; index++) {
        final cell = tester.widget<GameCell>(find.byType(GameCell).at(index));

        expect(cell.isWinning, winningLine.contains(index));
      }
    });

    testWidgets('does not show confetti on a draw', (tester) async {
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4, 1, 6, 8]),
      );

      await pumpGamePage(tester, container);

      // X plays 0, 2, 3, 7, 5. CPU plays 4, 1, 6, 8.
      // The board fills without a winner.
      await tapCell(tester, 0);
      await tapCell(tester, 2);
      await tapCell(tester, 3);
      await tapCell(tester, 7);
      await tapCell(tester, 5);

      expect(find.byType(ConfettiWidget), findsNothing);
    });

    testWidgets('records a humanWon match when the human wins', (tester) async {
      final statsRepository = _RecordingStatsRepository();
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([3, 6]),
        statsRepository: statsRepository,
      );

      await pumpGamePage(tester, container);

      await tapCell(tester, 0);
      await tapCell(tester, 4);
      await tapCell(tester, 8);

      expect(statsRepository.savedMatches.length, 1);
      final recorded = statsRepository.savedMatches.single;
      expect(recorded.outcome, MatchOutcome.humanWon);
      // The recorded match carries the current difficulty (default easy) and
      // the timestamp from the injected clock.
      expect(recorded.difficulty, GameDifficulty.easy);
      expect(recorded.playedAt, DateTime(2026, 5, 27, 12));
    });

    testWidgets('records a cpuWon match when the CPU wins', (tester) async {
      final statsRepository = _RecordingStatsRepository();
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([0, 1, 2]),
        statsRepository: statsRepository,
      );

      await pumpGamePage(tester, container);

      await tapCell(tester, 3);
      await tapCell(tester, 4);
      await tapCell(tester, 8);

      expect(statsRepository.savedMatches.length, 1);
      expect(statsRepository.savedMatches.single.outcome, MatchOutcome.cpuWon);
    });

    testWidgets('records a draw match when the game ends in a draw', (
      tester,
    ) async {
      final statsRepository = _RecordingStatsRepository();
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([4, 1, 6, 8]),
        statsRepository: statsRepository,
      );

      await pumpGamePage(tester, container);

      await tapCell(tester, 0);
      await tapCell(tester, 2);
      await tapCell(tester, 3);
      await tapCell(tester, 7);
      await tapCell(tester, 5);

      expect(statsRepository.savedMatches.length, 1);
      expect(statsRepository.savedMatches.single.outcome, MatchOutcome.draw);
    });

    testWidgets('does not record while the game is still in progress', (
      tester,
    ) async {
      final statsRepository = _RecordingStatsRepository();
      final container = createContainer(
        cpuRepository: const _SequenceCpuRepository([3, 6]),
        statsRepository: statsRepository,
      );

      await pumpGamePage(tester, container);

      // Only one human move + CPU reply, game stays in progress.
      await tapCell(tester, 0);

      expect(statsRepository.savedMatches, isEmpty);
    });

    testWidgets(
      'does not record again when restarting after a finished match',
      (tester) async {
        final statsRepository = _RecordingStatsRepository();
        final container = createContainer(
          cpuRepository: const _SequenceCpuRepository([3, 6]),
          statsRepository: statsRepository,
        );

        await pumpGamePage(tester, container);

        await tapCell(tester, 0);
        await tapCell(tester, 4);
        await tapCell(tester, 8);

        expect(statsRepository.savedMatches.length, 1);

        // Restart: result transitions from GameWinner back to GameInProgress.
        // The listener must skip because the new state is no longer finished.
        await tester.tap(find.byType(RestartGameButton));
        await tester.pump();
        await tester.pump(turnSettleDuration);

        expect(statsRepository.savedMatches.length, 1);
      },
    );
  });
}

final class _NoopStatsRepository implements StatsRepository {
  @override
  Future<MatchHistory> getMatchHistory() async => MatchHistory.empty();

  @override
  Future<void> recordMatch(CompletedMatch match) async {}
}

final class _RecordingStatsRepository implements StatsRepository {
  final savedMatches = <CompletedMatch>[];

  @override
  Future<MatchHistory> getMatchHistory() async => MatchHistory(savedMatches);

  @override
  Future<void> recordMatch(CompletedMatch match) async {
    savedMatches.add(match);
  }
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

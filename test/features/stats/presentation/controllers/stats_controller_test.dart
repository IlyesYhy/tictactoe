import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/stats/di/stats_providers.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_history.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/domain/repositories/stats_repository.dart';
import 'package:tictactoe/features/stats/presentation/controllers/stats_controller.dart';

void main() {
  final sampleMatch = CompletedMatch(
    outcome: MatchOutcome.humanWon,
    difficulty: GameDifficulty.easy,
    playedAt: DateTime(2026, 5, 27, 12),
  );

  ProviderContainer createContainer({
    MatchHistory? initial,
    StatsRepository? repository,
  }) {
    final container = ProviderContainer(
      overrides: [
        initialMatchHistoryProvider.overrideWithValue(
          initial ?? MatchHistory.empty(),
        ),
        statsRepositoryProvider.overrideWithValue(
          repository ?? _RecordingStatsRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('StatsController', () {
    test('build returns the initial match history', () {
      final container = createContainer(initial: MatchHistory([sampleMatch]));

      final history = container.read(statsControllerProvider);

      expect(history.matches, [sampleMatch]);
    });

    test('addMatch persists the match through the repository', () async {
      final repository = _RecordingStatsRepository();
      final container = createContainer(repository: repository);

      await container
          .read(statsControllerProvider.notifier)
          .addMatch(sampleMatch);

      expect(repository.savedMatches, [sampleMatch]);
    });

    test(
      'addMatch appends the match to the in-memory state on success',
      () async {
        final container = createContainer();

        await container
            .read(statsControllerProvider.notifier)
            .addMatch(sampleMatch);

        expect(container.read(statsControllerProvider).matches, [sampleMatch]);
      },
    );

    test(
      'addMatch appends to an existing history without overwriting',
      () async {
        final existing = CompletedMatch(
          outcome: MatchOutcome.draw,
          difficulty: GameDifficulty.hard,
          playedAt: DateTime(2026, 5, 26, 9),
        );
        final container = createContainer(initial: MatchHistory([existing]));

        await container
            .read(statsControllerProvider.notifier)
            .addMatch(sampleMatch);

        expect(container.read(statsControllerProvider).matches, [
          existing,
          sampleMatch,
        ]);
      },
    );

    test(
      'addMatch leaves the state untouched when the repository throws',
      () async {
        final container = createContainer(
          repository: _ThrowingStatsRepository(),
        );

        await expectLater(
          container
              .read(statsControllerProvider.notifier)
              .addMatch(sampleMatch),
          throwsException,
        );

        expect(container.read(statsControllerProvider).matches, isEmpty);
      },
    );

    test('addMatch propagates repository errors to the caller', () async {
      final container = createContainer(repository: _ThrowingStatsRepository());

      await expectLater(
        container.read(statsControllerProvider.notifier).addMatch(sampleMatch),
        throwsException,
      );
    });
  });
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

final class _ThrowingStatsRepository implements StatsRepository {
  @override
  Future<MatchHistory> getMatchHistory() async => MatchHistory.empty();

  @override
  Future<void> recordMatch(CompletedMatch match) async {
    throw Exception('repository down');
  }
}

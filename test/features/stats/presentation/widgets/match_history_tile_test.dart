import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/presentation/widgets/match_history_tile.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  Future<void> pumpTile(
    WidgetTester tester, {
    required CompletedMatch match,
    required DateTime now,
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MatchHistoryTile(match: match, now: now),
        ),
      ),
    );
  }

  CompletedMatch buildMatch({
    MatchOutcome outcome = MatchOutcome.humanWon,
    GameDifficulty difficulty = GameDifficulty.easy,
    required DateTime playedAt,
  }) {
    return CompletedMatch(
      outcome: outcome,
      difficulty: difficulty,
      playedAt: playedAt,
    );
  }

  group('MatchHistoryTile outcome label', () {
    testWidgets('shows Victory for human win', (tester) async {
      await pumpTile(
        tester,
        match: buildMatch(
          outcome: MatchOutcome.humanWon,
          playedAt: DateTime(2026, 5, 28, 12),
        ),
        now: DateTime(2026, 5, 28, 13),
      );

      expect(find.text('Victory'), findsOneWidget);
    });

    testWidgets('shows Defeat for CPU win', (tester) async {
      await pumpTile(
        tester,
        match: buildMatch(
          outcome: MatchOutcome.cpuWon,
          playedAt: DateTime(2026, 5, 28, 12),
        ),
        now: DateTime(2026, 5, 28, 13),
      );

      expect(find.text('Defeat'), findsOneWidget);
    });

    testWidgets('shows Draw for draw', (tester) async {
      await pumpTile(
        tester,
        match: buildMatch(
          outcome: MatchOutcome.draw,
          playedAt: DateTime(2026, 5, 28, 12),
        ),
        now: DateTime(2026, 5, 28, 13),
      );

      expect(find.text('Draw'), findsOneWidget);
    });
  });

  group('MatchHistoryTile difficulty label', () {
    testWidgets('shows Easy label for easy difficulty', (tester) async {
      await pumpTile(
        tester,
        match: buildMatch(
          difficulty: GameDifficulty.easy,
          playedAt: DateTime(2026, 5, 28, 12),
        ),
        now: DateTime(2026, 5, 28, 13),
      );

      expect(find.text('Easy'), findsOneWidget);
    });

    testWidgets('shows Hard label for hard difficulty', (tester) async {
      await pumpTile(
        tester,
        match: buildMatch(
          difficulty: GameDifficulty.hard,
          playedAt: DateTime(2026, 5, 28, 12),
        ),
        now: DateTime(2026, 5, 28, 13),
      );

      expect(find.text('Hard'), findsOneWidget);
    });
  });

  group('MatchHistoryTile date label', () {
    testWidgets('shows Today, HH:mm for same calendar day', (tester) async {
      await pumpTile(
        tester,
        match: buildMatch(playedAt: DateTime(2026, 5, 28, 17, 42)),
        now: DateTime(2026, 5, 28, 19, 0),
      );

      expect(find.text('Today, 17:42'), findsOneWidget);
    });

    testWidgets('shows Yesterday, HH:mm for the previous calendar day', (
      tester,
    ) async {
      await pumpTile(
        tester,
        match: buildMatch(playedAt: DateTime(2026, 5, 27, 9, 5)),
        now: DateTime(2026, 5, 28, 10, 0),
      );

      expect(find.text('Yesterday, 09:05'), findsOneWidget);
    });

    testWidgets('shows the short date for an older same-year match', (
      tester,
    ) async {
      await pumpTile(
        tester,
        match: buildMatch(playedAt: DateTime(2026, 3, 15, 9, 5)),
        now: DateTime(2026, 5, 28, 10, 0),
      );

      expect(find.text('Mar 15'), findsOneWidget);
    });

    testWidgets('shows the dated label for a prior-year match', (tester) async {
      await pumpTile(
        tester,
        match: buildMatch(playedAt: DateTime(2024, 3, 15, 9, 5)),
        now: DateTime(2026, 5, 28, 10, 0),
      );

      expect(find.text('Mar 15, 2024'), findsOneWidget);
    });

    testWidgets('respects French locale for the Today label', (tester) async {
      await pumpTile(
        tester,
        locale: const Locale('fr'),
        match: buildMatch(playedAt: DateTime(2026, 5, 28, 17, 42)),
        now: DateTime(2026, 5, 28, 19, 0),
      );

      expect(find.text("Aujourd'hui, 17:42"), findsOneWidget);
    });
  });
}

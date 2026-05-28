import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/core/di/current_date_time_provider.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/domain/entities/game_statistics.dart';
import 'package:tictactoe/features/stats/presentation/controllers/stats_controller.dart';
import 'package:tictactoe/features/stats/presentation/widgets/difficulty_stats_card.dart';
import 'package:tictactoe/features/stats/presentation/widgets/match_history_tile.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_hero.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_section_title.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_summary_card.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({this.scrollController, super.key});

  /// Optional scroll controller for the statistics page scroll view.
  ///
  /// Supplied by the home shell so it can scroll the page back to the top
  /// when the user reopens this tab. Standalone routes can omit it and let
  /// the [ListView] manage its own controller.
  final ScrollController? scrollController;

  static const _horizontalPadding = 16.0;
  static const _verticalPadding = 16.0;
  static const _bottomPadding = 64.0;
  static const _sectionGap = 24.0;
  static const _headerGap = 12.0;
  static const _tileGap = 8.0;
  static const _difficultyCardGap = 12.0;
  static const _difficultyStackBreakpoint = 360.0;

  static const _heroIndex = 0;
  static const _summaryIndex = 1;
  static const _difficultyHeaderIndex = 2;
  static const _difficultyCardsIndex = 3;
  static const _historyHeaderIndex = 4;
  static const _fixedItemCount = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(statsControllerProvider);
    final stats = history.statistics;
    final now = ref.watch(currentDateTimeProvider)();
    final recentMatches = history.matches.reversed.toList(growable: false);

    final easyStats = history.statisticsForDifficulty(GameDifficulty.easy);
    final hardStats = history.statisticsForDifficulty(GameDifficulty.hard);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          context.l10n.statsTitle,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: stats.totalMatches == 0
          ? const _EmptyState()
          : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(
                _horizontalPadding,
                _verticalPadding,
                _horizontalPadding,
                _bottomPadding,
              ),
              itemCount: _fixedItemCount + recentMatches.length,
              itemBuilder: (context, index) {
                switch (index) {
                  case _heroIndex:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: _sectionGap),
                      child: StatsHero(stats: stats),
                    );

                  case _summaryIndex:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: _sectionGap),
                      child: StatsSummaryCard(stats: stats),
                    );

                  case _difficultyHeaderIndex:
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: _headerGap,
                      ),
                      child: StatsSectionTitle(
                        label: context.l10n.statsByDifficulty,
                      ),
                    );

                  case _difficultyCardsIndex:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: _sectionGap),
                      child: _DifficultyCardsRow(
                        easyStats: easyStats,
                        hardStats: hardStats,
                      ),
                    );

                  case _historyHeaderIndex:
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: _headerGap,
                      ),
                      child: StatsSectionTitle(
                        label: context.l10n.statsHistory,
                      ),
                    );
                }

                final match = recentMatches[index - _fixedItemCount];
                return Padding(
                  padding: const EdgeInsets.only(bottom: _tileGap),
                  child: MatchHistoryTile(match: match, now: now),
                );
              },
            ),
    );
  }
}

class _DifficultyCardsRow extends StatelessWidget {
  const _DifficultyCardsRow({required this.easyStats, required this.hardStats});

  final GameStatistics easyStats;
  final GameStatistics hardStats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow =
            constraints.maxWidth < StatsPage._difficultyStackBreakpoint;

        final easyCard = DifficultyStatsCard(
          difficulty: GameDifficulty.easy,
          stats: easyStats,
        );
        final hardCard = DifficultyStatsCard(
          difficulty: GameDifficulty.hard,
          stats: hardStats,
        );

        if (isNarrow) {
          return Column(
            children: [
              easyCard,
              const SizedBox(height: StatsPage._difficultyCardGap),
              hardCard,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: easyCard),
            const SizedBox(width: StatsPage._difficultyCardGap),
            Expanded(child: hardCard),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 64,
              color: context.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.statsEmpty,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

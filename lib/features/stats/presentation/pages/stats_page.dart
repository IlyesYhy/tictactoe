import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/core/di/current_date_time_provider.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/presentation/controllers/stats_controller.dart';
import 'package:tictactoe/features/stats/presentation/widgets/match_history_tile.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_chart.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_counter_card.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({this.scrollController, super.key});

  /// Supplied by the home shell so it can scroll the statistics tab back to the top.
  ///
  /// Supplied by the home shell so it can scroll the page back to the top
  /// when the user reopens this tab. Standalone routes can omit it and let
  /// the [ListView] manage its own controller.
  final ScrollController? scrollController;

  static const _horizontalPadding = 16.0;
  static const _verticalPadding = 16.0;
  static const _bottomPadding = 32.0;
  static const _sectionGap = 18.0;
  static const _historyHeaderGap = 12.0;
  static const _tileGap = 8.0;

  static const _counterIndex = 0;
  static const _chartIndex = 1;
  static const _historyHeaderIndex = 2;
  static const _fixedItemCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(statsControllerProvider);
    final stats = history.statistics;
    final now = ref.watch(currentDateTimeProvider)();
    final recentMatches = history.matches.reversed.toList(growable: false);

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(context.l10n.statsTitle),
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
                  case _counterIndex:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: _sectionGap),
                      child: StatsCounterCard(stats: stats),
                    );
                  case _chartIndex:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: _sectionGap),
                      child: StatsChart(stats: stats),
                    );
                  case _historyHeaderIndex:
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                        bottom: _historyHeaderGap,
                      ),
                      child: Text(
                        context.l10n.statsHistory,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
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

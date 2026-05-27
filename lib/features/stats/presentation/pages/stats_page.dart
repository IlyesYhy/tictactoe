import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/stats/presentation/controllers/stats_controller.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_chart.dart';
import 'package:tictactoe/features/stats/presentation/widgets/stats_counter_card.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({this.scrollController, super.key});

  /// Optional scroll controller for the matches list.
  ///
  /// Supplied by the home shell so it can scroll the page back to the top
  /// when the user reopens this tab. Standalone routes can omit it and let
  /// the [ListView] manage its own controller.
  final ScrollController? scrollController;

  static const _horizontalPadding = 16.0;
  static const _verticalPadding = 16.0;
  static const _sectionGap = 18.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(statsControllerProvider);
    final stats = history.statistics;

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
          : ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(
                _horizontalPadding,
                _verticalPadding,
                _horizontalPadding,
                32,
              ),
              children: [
                StatsCounterCard(stats: stats),
                const SizedBox(height: _sectionGap),
                StatsChart(stats: stats),
              ],
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

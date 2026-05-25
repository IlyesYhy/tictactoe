import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/app/theme/app_spacing.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/presentation/controllers/game_controller.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_board.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_players_legend.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_status_badge.dart';
import 'package:tictactoe/features/game/presentation/widgets/restart_game_button.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final isBoardDisabled = state.isCpuThinking || state.session.isFinished;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final layout = _GamePageLayout.fromConstraints(constraints);

            return Padding(
              padding: AppSpacing.gamePagePadding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: _GamePageLayout.maxContentWidth,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).backButtonTooltip,
                            onPressed: () => _goBack(context),

                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Text(
                        context.l10n.appTitle,
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      layout.titleStatusGap,
                      GameStatusBadge(
                        result: state.session.result,
                        isCpuThinking: state.isCpuThinking,
                      ),
                      layout.statusBoardGap,
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GameBoard(
                              board: state.session.board,
                              isDisabled: isBoardDisabled,
                              onCellTap: controller.playHumanTurn,
                            ),
                          ),
                        ),
                      ),
                      layout.boardLegendGap,
                      const GamePlayersLegend(),
                      layout.legendButtonGap,
                      RestartGameButton(
                        onPressed: state.isCpuThinking
                            ? null
                            : controller.resetGame,
                        isGameOver: state.session.isFinished,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRouteNames.home);
  }
}

class _GamePageLayout {
  const _GamePageLayout({
    required this.titleStatusGap,
    required this.statusBoardGap,
    required this.boardLegendGap,
    required this.legendButtonGap,
  });

  factory _GamePageLayout.fromConstraints(BoxConstraints constraints) {
    final isSpaciousHeight = constraints.maxHeight >= _spaciousHeightThreshold;

    return _GamePageLayout(
      titleStatusGap: isSpaciousHeight ? AppSpacing.h40 : AppSpacing.h16,
      statusBoardGap: isSpaciousHeight ? AppSpacing.h40 : AppSpacing.h16,
      boardLegendGap: isSpaciousHeight ? AppSpacing.h24 : AppSpacing.h12,
      legendButtonGap: isSpaciousHeight ? AppSpacing.h32 : AppSpacing.h16,
    );
  }

  static const maxContentWidth = 420.0;
  static const _spaciousHeightThreshold = 700.0;

  final SizedBox titleStatusGap;
  final SizedBox statusBoardGap;
  final SizedBox boardLegendGap;
  final SizedBox legendButtonGap;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/app/theme/app_spacing.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/presentation/controllers/game_controller.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_board.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final isBoardDisabled = state.isCpuThinking || state.session.isFinished;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.gamePagePadding,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.appTitle,
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppSpacing.h40,
                  GameBoard(
                    board: state.session.board,
                    isDisabled: isBoardDisabled,
                    onCellTap: controller.playHumanTurn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

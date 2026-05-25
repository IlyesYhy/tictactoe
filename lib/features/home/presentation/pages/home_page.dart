import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/di/game_providers.dart';
import 'package:tictactoe/features/game/presentation/controllers/game_controller.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_difficulty_selector.dart';

/// Entry point of the application.
///
/// Lets the player pick a difficulty and start a new game. The CTA resets
/// the game controller explicitly so the upcoming `GamePage` boots on a
/// fresh session that captures the currently selected difficulty.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const _maxContentWidth = 420.0;
  static const _horizontalPadding = 24.0;
  static const _verticalPadding = 32.0;
  static const _mascotSize = 120.0;
  static const _buttonHeight = 56.0;

  void _startNewGame(BuildContext context, WidgetRef ref) {
    ref.read(gameControllerProvider.notifier).resetGame();
    context.goNamed(AppRouteNames.game);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(difficultyProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
                vertical: _verticalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.appTitle,
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.homeSubtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const _HomeMascot(key: Key('home_mascot'), size: _mascotSize),
                  const SizedBox(height: 32),
                  HomeDifficultySelector(
                    selected: selected,
                    onSelected: (difficulty) => ref
                        .read(difficultyProvider.notifier)
                        .select(difficulty),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: _buttonHeight,
                    child: FilledButton.icon(
                      key: const Key('home_new_game_button'),
                      onPressed: () => _startNewGame(context, ref),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(context.l10n.newGame),
                    ),
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

class _HomeMascot extends StatelessWidget {
  const _HomeMascot({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        size: size * 0.6,
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}

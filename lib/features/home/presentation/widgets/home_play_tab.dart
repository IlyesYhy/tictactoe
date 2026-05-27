import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/di/game_providers.dart';
import 'package:tictactoe/features/game/presentation/controllers/game_controller.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_difficulty_selector.dart';

/// Content of the Play tab inside the home shell.
///
/// Lets the player pick a difficulty and start a new game. Also exposes a
/// floating shortcut to the settings page.
class HomePlayTab extends ConsumerWidget {
  const HomePlayTab({super.key});

  static const _maxContentWidth = 420.0;
  static const _horizontalPadding = 24.0;

  static const _compactBreakpoint = 700.0;

  static const _regularTopSpacing = 48.0;
  static const _compactTopSpacing = 20.0;

  static const _titleSubtitleGap = 8.0;

  static const _regularSubtitleHeroGap = 24.0;
  static const _compactSubtitleHeroGap = 14.0;

  static const _regularHeroHeight = 230.0;
  static const _compactHeroHeight = 170.0;

  static const _regularRobotSize = 180.0;
  static const _compactRobotSize = 140.0;

  static const _regularSelectorGap = 28.0;
  static const _compactSelectorGap = 20.0;

  static const _regularCtaGap = 32.0;
  static const _compactCtaGap = 24.0;

  static const _regularButtonHeight = 62.0;
  static const _compactButtonHeight = 56.0;

  static const _regularBottomSpacing = 32.0;
  static const _compactBottomSpacing = 20.0;

  static const _buttonRadius = 18.0;

  void _startNewGame(BuildContext context, WidgetRef ref) {
    ref.read(gameControllerProvider.notifier).resetGame();
    context.pushNamed(AppRouteNames.game);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(difficultyProvider);

    return SafeArea(
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxHeight < _compactBreakpoint;

              final topSpacing = isCompact
                  ? _compactTopSpacing
                  : _regularTopSpacing;
              final subtitleHeroGap = isCompact
                  ? _compactSubtitleHeroGap
                  : _regularSubtitleHeroGap;
              final heroHeight = isCompact
                  ? _compactHeroHeight
                  : _regularHeroHeight;
              final robotSize = isCompact
                  ? _compactRobotSize
                  : _regularRobotSize;
              final selectorGap = isCompact
                  ? _compactSelectorGap
                  : _regularSelectorGap;
              final ctaGap = isCompact ? _compactCtaGap : _regularCtaGap;
              final buttonHeight = isCompact
                  ? _compactButtonHeight
                  : _regularButtonHeight;
              final bottomSpacing = isCompact
                  ? _compactBottomSpacing
                  : _regularBottomSpacing;

              final titleStyle = isCompact
                  ? context.textTheme.headlineLarge
                  : context.textTheme.displaySmall;

              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _horizontalPadding,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: topSpacing),
                            Text(
                              context.l10n.appTitle,
                              textAlign: TextAlign.center,
                              style: titleStyle?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: context.colorScheme.onSurface,
                                letterSpacing: -1.2,
                              ),
                            ),
                            const SizedBox(height: _titleSubtitleGap),
                            Text(
                              context.l10n.homeSubtitle,
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: subtitleHeroGap),
                            _HomeHero(
                              key: const Key('home_mascot'),
                              difficulty: selected,
                              height: heroHeight,
                              robotSize: robotSize,
                            ),
                            SizedBox(height: selectorGap),
                            _HomeCard(
                              isCompact: isCompact,
                              child: HomeDifficultySelector(
                                selected: selected,
                                isCompact: isCompact,
                                onSelected: (difficulty) => ref
                                    .read(difficultyProvider.notifier)
                                    .select(difficulty),
                              ),
                            ),
                            SizedBox(height: ctaGap),
                            SizedBox(
                              width: double.infinity,
                              height: buttonHeight,
                              child: FilledButton.icon(
                                key: const Key('home_new_game_button'),
                                onPressed: () => _startNewGame(context, ref),
                                icon: const Icon(Icons.play_circle_rounded),
                                label: Text(context.l10n.newGame),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      _buttonRadius,
                                    ),
                                  ),
                                  textStyle: context.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            SizedBox(height: bottomSpacing),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              key: const Key('home_settings_button'),
              tooltip: context.l10n.settingsTitle,
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.pushNamed(AppRouteNames.settings),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({required this.child, required this.isCompact});

  final Widget child;
  final bool isCompact;

  static const _radius = 24.0;
  static const _regularPadding = 20.0;
  static const _compactPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? _compactPadding : _regularPadding),
        child: child,
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.difficulty,
    required this.height,
    required this.robotSize,
    super.key,
  });

  final GameDifficulty difficulty;
  final double height;
  final double robotSize;

  static const _lightHappyAssetPath = 'assets/bot-light-happy.png';
  static const _darkHappyAssetPath = 'assets/bot-dark-happy.png';
  static const _lightAngryAssetPath = 'assets/bot-light-angry.png';
  static const _darkAngryAssetPath = 'assets/bot-dark-angry.png';

  String _robotAssetPath(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch ((difficulty, isDark)) {
      (GameDifficulty.easy, false) => _lightHappyAssetPath,
      (GameDifficulty.easy, true) => _darkHappyAssetPath,
      (GameDifficulty.hard, false) => _lightAngryAssetPath,
      (GameDifficulty.hard, true) => _darkAngryAssetPath,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final robotAssetPath = _robotAssetPath(context);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 28,
            bottom: height * 0.30,
            child: _DecorativeSymbol(
              symbol: 'X',
              color: colorScheme.primary,
              size: robotSize * 0.28,
              rotation: -0.65,
            ),
          ),
          Positioned(
            right: 28,
            top: height * 0.18,
            child: _DecorativeSymbol(
              symbol: 'O',
              color: colorScheme.secondary,
              size: robotSize * 0.27,
              rotation: 0.18,
            ),
          ),
          Positioned(
            left: 70,
            top: height * 0.20,
            child: _Sparkle(color: colorScheme.primary.withValues(alpha: 0.18)),
          ),
          Positioned(
            right: 72,
            bottom: height * 0.24,
            child: _Sparkle(
              color: colorScheme.secondary.withValues(alpha: 0.18),
            ),
          ),
          Image.asset(
            robotAssetPath,
            width: robotSize,
            height: robotSize,
            fit: BoxFit.contain,
            gaplessPlayback: true,
          ),
        ],
      ),
    );
  }
}

class _DecorativeSymbol extends StatelessWidget {
  const _DecorativeSymbol({
    required this.symbol,
    required this.color,
    required this.size,
    required this.rotation,
  });

  final String symbol;
  final Color color;
  final double size;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Text(
        symbol,
        style: context.textTheme.displaySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: size,
          height: 1,
        ),
      ),
    );
  }
}

class _Sparkle extends StatelessWidget {
  const _Sparkle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome_rounded, color: color, size: 18);
  }
}

import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

class GameRulesPage extends StatelessWidget {
  const GameRulesPage({super.key});

  static const _horizontalPadding = 20.0;
  static const _verticalPadding = 16.0;
  static const _sectionGap = 18.0;
  static const _cardRadius = 22.0;

  // Replace these paths with your final assets.
  static const _assetPath = 'assets/bot-light-happy.png';
  static const _heroImagePath = _assetPath; // 'assets/rules-hero.png';
  static const _objectiveImagePath =
      _assetPath; // 'assets/rules-objective.png';
  static const _startImagePath = _assetPath; // 'assets/rules-start.png';
  static const _winImagePath = _assetPath; // 'assets/rules-win.png';
  static const _drawImagePath = _assetPath; // 'assets/rules-draw.png';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.gameRulesTitle,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          _horizontalPadding,
          _verticalPadding,
          _horizontalPadding,
          32,
        ),
        children: [
          _HeroCard(
            title: l10n.gameRulesTitle,
            subtitle: l10n.gameRulesObjectiveDescription,
            imagePath: _heroImagePath,
          ),
          const SizedBox(height: _sectionGap),

          _RuleCard(
            icon: Icons.flag_circle_outlined,
            title: l10n.gameRulesObjective,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    l10n.gameRulesObjectiveDescription,
                    style: context.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ),
                const SizedBox(width: 16),
                const _RuleImage(
                  key: Key('game_rules_objective_image'),
                  assetPath: _objectiveImagePath,
                  size: 82,
                ),
              ],
            ),
          ),
          const SizedBox(height: _sectionGap),

          _RuleCard(
            icon: Icons.sports_esports_outlined,
            title: l10n.gameRulesHowToPlay,
            child: Column(
              children: [
                _StepRow(
                  index: 1,
                  text: l10n.gameRulesStart,
                  trailing: const _RuleImage(
                    key: Key('game_rules_start_image'),
                    assetPath: _startImagePath,
                    size: 62,
                  ),
                ),
                const _RuleDivider(),
                _StepRow(
                  index: 2,
                  text: l10n.gameRulesWin,
                  trailing: const _RuleImage(
                    key: Key('game_rules_win_image'),
                    assetPath: _winImagePath,
                    size: 62,
                  ),
                ),
                const _RuleDivider(),
                _StepRow(
                  index: 3,
                  text: l10n.gameRulesDraw,
                  trailing: const _RuleImage(
                    key: Key('game_rules_draw_image'),
                    assetPath: _drawImagePath,
                    size: 62,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: _sectionGap),

          _RuleCard(
            icon: Icons.emoji_events_outlined,
            title: l10n.gameRulesDifficulty,
            child: Column(
              children: [
                _DifficultyRow(
                  icon: Icons.sentiment_satisfied_rounded,
                  label: l10n.difficultyEasy,
                  description: l10n.gameRulesEasy,
                ),
                const _RuleDivider(),
                _DifficultyRow(
                  icon: Icons.local_fire_department_rounded,
                  label: l10n.difficultyHard,
                  description: l10n.gameRulesHard,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String imagePath;

  static const _height = 260.0;
  static const _imageSize = 150.0;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: SizedBox(
        height: _height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 22,
              top: 54,
              child: _DecorativeSymbol(
                symbol: 'X',
                color: context.colorScheme.primary,
                size: 42,
                rotation: -0.55,
              ),
            ),
            Positioned(
              right: 24,
              top: 62,
              child: _DecorativeSymbol(
                symbol: 'O',
                color: context.colorScheme.secondary,
                size: 42,
                rotation: 0.12,
              ),
            ),
            Positioned(
              left: 72,
              bottom: 58,
              child: _Sparkle(
                color: context.colorScheme.primary.withValues(alpha: 0.22),
              ),
            ),
            Positioned(
              right: 76,
              bottom: 62,
              child: _Sparkle(
                color: context.colorScheme.secondary.withValues(alpha: 0.22),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  width: _imageSize,
                  height: _imageSize,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardTitle(icon: icon, title: title),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBubble(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.text,
    required this.trailing,
  });

  final int index;
  final String text;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepBadge(index: index),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
      child: Text(
        '$index',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DifficultyRow extends StatelessWidget {
  const _DifficultyRow({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconBubble(icon: icon),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: context.colorScheme.primary.withValues(alpha: 0.12),
      child: Icon(icon, size: 21, color: context.colorScheme.primary),
    );
  }
}

class _RuleImage extends StatelessWidget {
  const _RuleImage({required this.assetPath, required this.size, super.key});

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        gaplessPlayback: true,
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  static const _radius = GameRulesPage._cardRadius;

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
            color: context.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _RuleDivider extends StatelessWidget {
  const _RuleDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 28,
      color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
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
        textScaler: TextScaler.noScaling,
        style: context.textTheme.displaySmall?.copyWith(
          color: color,
          fontSize: size,
          fontWeight: FontWeight.w900,
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

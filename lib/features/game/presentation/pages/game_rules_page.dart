import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/core/constants/app_assets.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

class GameRulesPage extends StatelessWidget {
  const GameRulesPage({this.onPlayNow, this.scrollController, super.key});

  /// Optional override for the "play now" call-to-action.
  ///
  /// When null (standalone route), the button pops back to the home shell. When
  /// supplied (embedded inside the home shell), the callback switches tabs
  /// without rebuilding the shell.
  final VoidCallback? onPlayNow;

  /// Optional scroll controller for the rules list.
  ///
  /// Supplied by the home shell so it can scroll the page back to the top
  /// when the user reopens this tab. Standalone routes can omit it.
  final ScrollController? scrollController;

  static const _horizontalPadding = 20.0;
  static const _verticalPadding = 0.0;
  static const _bottomPadding = 32.0;
  static const _sectionGap = 18.0;
  static const _cardPadding = 18.0;
  static const _cardRadius = 22.0;

  static const _headerHeight = 260.0;
  static const _bottomImageHeight = 260.0;
  static const _buttonBottomGap = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final headerImagePath = isDarkMode
        ? AppAssets.botDarkRules
        : AppAssets.botLightRules;

    final bottomImagePath = isDarkMode
        ? AppAssets.botDarkRulesEnd
        : AppAssets.botLightRulesEnd;

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
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(
          _horizontalPadding,
          _verticalPadding,
          _horizontalPadding,
          _bottomPadding,
        ),
        children: [
          _Header(subtitle: l10n.gameRulesSubtitle, imagePath: headerImagePath),
          const SizedBox(height: _sectionGap),
          _RuleCard(
            icon: Icons.flag_outlined,
            title: l10n.gameRulesObjective,
            child: Text(
              l10n.gameRulesObjectiveDescription,
              style: context.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ),
          const SizedBox(height: _sectionGap),
          _RuleCard(
            icon: Icons.sports_esports_outlined,
            title: l10n.gameRulesHowToPlay,
            child: Column(
              children: [
                _StepRow(index: 1, text: l10n.gameRulesStart),
                const _RuleDivider(),
                _StepRow(index: 2, text: l10n.gameRulesWin),
                const _RuleDivider(),
                _StepRow(index: 3, text: l10n.gameRulesDraw),
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
          const SizedBox(height: _sectionGap),
          _DecorativeImage(
            assetPath: bottomImagePath,
            height: _bottomImageHeight,
          ),
          const SizedBox(height: 20),
          _PlayNowButton(
            label: l10n.gameRulesPlayNow,
            onPressed: onPlayNow ?? () => context.goNamed(AppRouteNames.home),
          ),
          const SizedBox(height: _buttonBottomGap),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.subtitle, required this.imagePath});

  final String subtitle;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: GameRulesPage._headerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          const SizedBox(height: 12),
          Expanded(child: _DecorativeImage(assetPath: imagePath)),
          const SizedBox(height: 6),
        ],
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
        padding: const EdgeInsets.all(GameRulesPage._cardPadding),
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
  const _StepRow({required this.index, required this.text});

  final int index;
  final String text;

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
      radius: 16,
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

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(GameRulesPage._cardRadius),
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

class _DecorativeImage extends StatelessWidget {
  const _DecorativeImage({required this.assetPath, this.height});

  final String assetPath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}

class _PlayNowButton extends StatelessWidget {
  const _PlayNowButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  static const _borderRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7A00FF), Color(0xFF8F00FF)],
          ),
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7A00FF).withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(_borderRadius),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_esports, color: Colors.white, size: 28),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/domain/entities/game_difficulty.dart';

/// Two-card selector for the [GameDifficulty] picked on the home page.
///
/// Stateless: the parent owns the [selected] value and updates it via
/// [onSelected]. Keys are stable across difficulties so widget tests can
/// target a specific card without depending on its label.
class HomeDifficultySelector extends StatelessWidget {
  const HomeDifficultySelector({
    required this.selected,
    required this.onSelected,
    this.isCompact = false,
    super.key,
  });

  final GameDifficulty selected;
  final ValueChanged<GameDifficulty> onSelected;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final titleStyle = isCompact
        ? context.textTheme.titleSmall
        : context.textTheme.titleMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.difficultyTitle,
          style: titleStyle?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: isCompact ? 10 : 12),
        Row(
          children: [
            Expanded(
              child: _DifficultyCard(
                key: const Key('home_difficulty_easy'),
                icon: Icons.sentiment_satisfied_rounded,
                label: context.l10n.difficultyEasy,
                isSelected: selected == GameDifficulty.easy,
                isCompact: isCompact,
                onTap: () => onSelected(GameDifficulty.easy),
              ),
            ),
            SizedBox(width: isCompact ? 10 : 12),
            Expanded(
              child: _DifficultyCard(
                key: const Key('home_difficulty_hard'),
                icon: Icons.local_fire_department_rounded,
                label: context.l10n.difficultyHard,
                isSelected: selected == GameDifficulty.hard,
                isCompact: isCompact,
                onTap: () => onSelected(GameDifficulty.hard),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isCompact,
    required this.onTap,
    super.key,
  });

  static const _borderRadius = 16.0;
  static const _selectedBorderWidth = 2.0;
  static const _unselectedBorderWidth = 1.0;

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCompact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final foreground = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;
    final borderColor = isSelected
        ? colorScheme.primary
        : colorScheme.outlineVariant;

    final verticalPadding = isCompact ? 12.0 : 16.0;
    final iconSize = isCompact ? 22.0 : 24.0;
    final iconLabelGap = isCompact ? 6.0 : 8.0;
    final textStyle = isCompact
        ? context.textTheme.titleSmall
        : context.textTheme.titleMedium;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(
              color: borderColor,
              width: isSelected ? _selectedBorderWidth : _unselectedBorderWidth,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: iconSize),
              SizedBox(width: iconLabelGap),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

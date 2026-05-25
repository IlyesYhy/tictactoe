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
    super.key,
  });

  final GameDifficulty selected;
  final ValueChanged<GameDifficulty> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.difficultyTitle,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DifficultyCard(
                key: const Key('home_difficulty_easy'),
                icon: Icons.sentiment_satisfied_rounded,
                label: context.l10n.difficultyEasy,
                isSelected: selected == GameDifficulty.easy,
                onTap: () => onSelected(GameDifficulty.easy),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DifficultyCard(
                key: const Key('home_difficulty_hard'),
                icon: Icons.local_fire_department_rounded,
                label: context.l10n.difficultyHard,
                isSelected: selected == GameDifficulty.hard,
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
    required this.onTap,
    super.key,
  });

  static const _borderRadius = 16.0;
  static const _selectedBorderWidth = 2.0;
  static const _unselectedBorderWidth = 1.0;
  static const _verticalPadding = 16.0;
  static const _iconLabelGap = 8.0;

  final IconData icon;
  final String label;
  final bool isSelected;
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

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
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
              Icon(icon, color: foreground),
              const SizedBox(width: _iconLabelGap),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
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

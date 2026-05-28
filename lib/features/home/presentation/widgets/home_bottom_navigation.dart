import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

/// Floating bottom navigation used by the home shell.
///
/// Renders three destinations (play, stats, rules) inside a rounded surface
/// card that hovers above the page background. The widget handles its own
/// [SafeArea] and outer padding so callers can pass it directly to
/// [Scaffold.bottomNavigationBar].
class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _horizontalMargin = 24.0;
  static const _bottomMargin = 12.0;
  static const _radius = 24.0;
  static const _internalPadding = 8.0;
  static const _elevation = 2.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          _horizontalMargin,
          0,
          _horizontalMargin,
          _bottomMargin,
        ),
        child: Material(
          color: context.colorScheme.surface,
          elevation: _elevation,
          shadowColor: context.colorScheme.shadow.withValues(alpha: 0.10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
            side: BorderSide(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(_internalPadding),
            child: Row(
              children: [
                _HomeBottomNavItem(
                  key: const Key('home_tab_play'),
                  icon: Icons.sports_esports_outlined,
                  activeIcon: Icons.sports_esports,
                  label: l10n.homeTabPlay,
                  isSelected: selectedIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
                _HomeBottomNavItem(
                  key: const Key('home_tab_stats'),
                  icon: Icons.bar_chart_outlined,
                  activeIcon: Icons.bar_chart,
                  label: l10n.homeTabStats,
                  isSelected: selectedIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
                _HomeBottomNavItem(
                  key: const Key('home_tab_rules'),
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book,
                  label: l10n.homeTabRules,
                  isSelected: selectedIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBottomNavItem extends StatelessWidget {
  const _HomeBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const _itemRadius = 18.0;
  static const _itemHorizontalMargin = 4.0;
  static const _itemVerticalPadding = 8.0;
  static const _iconSize = 26.0;
  static const _iconLabelGap = 4.0;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.colorScheme.primary
        : context.colorScheme.onSurfaceVariant;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _itemHorizontalMargin),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_itemRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: _itemVerticalPadding),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colorScheme.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(_itemRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: color,
                  size: _iconSize,
                ),
                const SizedBox(height: _iconLabelGap),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
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

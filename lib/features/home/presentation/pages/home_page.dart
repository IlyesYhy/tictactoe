import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/presentation/pages/game_rules_page.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_play_tab.dart';
import 'package:tictactoe/features/stats/presentation/pages/stats_page.dart';

/// Entry shell of the application.
///
/// Hosts a [NavigationBar] with three destinations (play, rules, stats) and
/// keeps their state alive via an [IndexedStack].
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _playIndex = 0;

  int _selectedIndex = _playIndex;

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomePlayTab(),
          GameRulesPage(onPlayNow: () => _selectTab(_playIndex)),
          const StatsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: [
          NavigationDestination(
            key: const Key('home_tab_play'),
            icon: const Icon(Icons.sports_esports_outlined),
            selectedIcon: const Icon(Icons.sports_esports),
            label: context.l10n.homeTabPlay,
          ),
          NavigationDestination(
            key: const Key('home_tab_rules'),
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: context.l10n.homeTabRules,
          ),
          NavigationDestination(
            key: const Key('home_tab_stats'),
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: context.l10n.homeTabStats,
          ),
        ],
      ),
    );
  }
}

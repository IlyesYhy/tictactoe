import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/presentation/pages/game_rules_page.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_play_tab.dart';
import 'package:tictactoe/features/stats/presentation/pages/stats_page.dart';

/// Entry shell of the application.
///
/// Hosts a [HomeBottomNavigation] with three destinations (play, rules, stats)
/// and keeps their state alive via an [IndexedStack].
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
          const StatsPage(),
          GameRulesPage(onPlayNow: () => _selectTab(_playIndex)),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';
import 'package:tictactoe/features/game/presentation/pages/game_rules_page.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_play_tab.dart';
import 'package:tictactoe/features/stats/presentation/pages/stats_page.dart';

/// Entry shell of the application.
///
/// Hosts a [HomeBottomNavigation] with three destinations (play, stats, rules)
/// and keeps their state alive via an [IndexedStack]. Reopening the stats or
/// rules tab animates the page back to the top so the user does not return to
/// a stale scroll position.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _playIndex = 0;
  static const _statsIndex = 1;
  static const _rulesIndex = 2;

  static const _scrollResetDuration = Duration(milliseconds: 250);

  final ScrollController _statsScrollController = ScrollController();
  final ScrollController _rulesScrollController = ScrollController();

  int _selectedIndex = _playIndex;

  @override
  void dispose() {
    _statsScrollController.dispose();
    _rulesScrollController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    final previousIndex = _selectedIndex;

    setState(() => _selectedIndex = index);

    if (previousIndex == index) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (index) {
        case _statsIndex:
          unawaited(_scrollToTop(_statsScrollController));
        case _rulesIndex:
          unawaited(_scrollToTop(_rulesScrollController));
      }
    });
  }

  Future<void> _scrollToTop(ScrollController controller) async {
    if (!controller.hasClients) return;
    if (controller.offset <= 0) return;

    await controller.animateTo(
      0,
      duration: _scrollResetDuration,
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomePlayTab(),
          StatsPage(scrollController: _statsScrollController),
          GameRulesPage(
            scrollController: _rulesScrollController,
            onPlayNow: () => _selectTab(_playIndex),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
      ),
    );
  }
}

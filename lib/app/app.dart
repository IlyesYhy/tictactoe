import 'package:flutter/material.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';

import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTacToe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const GamePage(),
    );
  }
}

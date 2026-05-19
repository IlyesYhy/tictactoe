import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_theme_x.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('TicTacToe', style: context.textTheme.titleLarge),
      ),
    );
  }
}

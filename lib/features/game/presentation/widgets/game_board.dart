import 'package:flutter/material.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_cell.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    required this.board,
    required this.onCellTap,
    this.isDisabled = false,
    this.winningLine,
    super.key,
  });

  static const _cellGap = 16.0;

  final Board board;
  final ValueChanged<int> onCellTap;
  final bool isDisabled;
  final List<int>? winningLine;

  @override
  Widget build(BuildContext context) {
    final winningCells = winningLine?.toSet() ?? const <int>{};

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: board.cells.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: _cellGap,
          crossAxisSpacing: _cellGap,
        ),
        itemBuilder: (context, index) {
          return GameCell(
            cell: board.cells[index],
            index: index,
            isDisabled: isDisabled,
            isWinning: winningCells.contains(index),
            onTap: () => onCellTap(index),
          );
        },
      ),
    );
  }
}

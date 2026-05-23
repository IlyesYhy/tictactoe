import 'package:equatable/equatable.dart';

import 'cell.dart';
import 'player.dart';

/// Immutable representation of a TicTacToe board.
///
/// The board always contains exactly 9 cells and never mutates.
/// Any move produces a new board instance.
final class Board extends Equatable {
  Board._(List<Cell> cells) : cells = List.unmodifiable(cells);
  factory Board.empty() {
    return Board._(List.filled(size, Cell.empty));
  }
  static const size = 9;
  static const minIndex = 0;
  static const maxIndex = size - 1;
  final List<Cell> cells;

  @override
  List<Object?> get props => [cells];

  bool get isFull => !cells.contains(Cell.empty);

  List<int> get availableMoves {
    return [
      for (var index = minIndex; index <= maxIndex; index++)
        if (isCellEmpty(index)) index,
    ];
  }

  bool isCellEmpty(int index) {
    _validateIndex(index);
    return cells[index].isEmpty;
  }

  Board placeMove({required int index, required Player player}) {
    if (!isCellEmpty(index)) {
      throw ArgumentError('Cell at index $index is already occupied.');
    }

    final updatedCells = List<Cell>.from(cells);
    updatedCells[index] = Cell.fromPlayer(player);

    return Board._(updatedCells);
  }

  void _validateIndex(int index) {
    if (index < minIndex || index > maxIndex) {
      throw RangeError.range(
        index,
        minIndex,
        maxIndex,
        'index',
        'Index must be between $minIndex and $maxIndex',
      );
    }
  }
}

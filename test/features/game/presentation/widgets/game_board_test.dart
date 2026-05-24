import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_board.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_cell.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  Widget sized(Widget child) => SizedBox.square(dimension: 300, child: child);

  group('GameBoard', () {
    testWidgets('renders nine cells', (tester) async {
      await tester.pumpTestApp(
        sized(GameBoard(board: Board.empty(), onCellTap: (_) {})),
      );

      expect(find.byType(GameCell), findsNWidgets(9));
    });

    testWidgets('propagates the tapped index', (tester) async {
      final taps = <int>[];
      await tester.pumpTestApp(
        sized(GameBoard(board: Board.empty(), onCellTap: taps.add)),
      );

      final cells = find.byType(GameCell);
      await tester.tap(cells.at(0));
      await tester.tap(cells.at(4));
      await tester.tap(cells.at(8));

      expect(taps, [0, 4, 8]);
    });

    testWidgets('ignores taps when the board is disabled', (tester) async {
      final taps = <int>[];

      await tester.pumpTestApp(
        sized(
          GameBoard(
            board: Board.empty(),
            isDisabled: true,
            onCellTap: taps.add,
          ),
        ),
      );

      await tester.tap(find.byType(GameCell).at(0));
      await tester.tap(find.byType(GameCell).at(4));

      expect(taps, isEmpty);
    });
  });
}

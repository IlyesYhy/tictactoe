import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/cell.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_cell.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  Widget sized(Widget child) => SizedBox.square(dimension: 100, child: child);

  group('GameCell', () {
    testWidgets('renders no symbol for an empty cell', (tester) async {
      await tester.pumpTestApp(
        sized(GameCell(cell: Cell.empty, index: 0, onTap: () {})),
      );

      expect(find.text('X'), findsNothing);
      expect(find.text('O'), findsNothing);
    });

    testWidgets('renders X for Cell.x', (tester) async {
      await tester.pumpTestApp(
        sized(GameCell(cell: Cell.x, index: 0, onTap: () {})),
      );

      expect(find.text('X'), findsOneWidget);
    });

    testWidgets('renders O for Cell.o', (tester) async {
      await tester.pumpTestApp(
        sized(GameCell(cell: Cell.o, index: 0, onTap: () {})),
      );

      expect(find.text('O'), findsOneWidget);
    });

    testWidgets('fires onTap when the cell is empty and not disabled', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpTestApp(
        sized(GameCell(cell: Cell.empty, index: 0, onTap: () => taps++)),
      );

      await tester.tap(find.byType(GameCell));

      expect(taps, 1);
    });

    testWidgets('ignores taps on an occupied cell', (tester) async {
      var taps = 0;
      await tester.pumpTestApp(
        sized(GameCell(cell: Cell.x, index: 0, onTap: () => taps++)),
      );

      await tester.tap(find.byType(GameCell));

      expect(taps, 0);
    });

    testWidgets('ignores taps when the cell is disabled', (tester) async {
      var taps = 0;
      await tester.pumpTestApp(
        sized(
          GameCell(
            cell: Cell.empty,
            index: 0,
            isDisabled: true,
            onTap: () => taps++,
          ),
        ),
      );

      await tester.tap(find.byType(GameCell));

      expect(taps, 0);
    });
  });
}

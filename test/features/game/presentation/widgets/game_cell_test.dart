import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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

    group('Semantics', () {
      testWidgets(
        'exposes the cell as an enabled button with position label and '
        '"empty" value',
        (tester) async {
          final handle = tester.ensureSemantics();

          await tester.pumpTestApp(
            sized(GameCell(cell: Cell.empty, index: 0, onTap: () {})),
          );

          final finder = find.bySemanticsLabel('Cell 1');
          expect(finder, findsOneWidget);

          final node = tester.getSemantics(finder);
          expect(node.value, 'empty');
          expect(node.flagsCollection.isButton, isTrue);
          expect(
            node.getSemanticsData().hasAction(SemanticsAction.tap),
            isTrue,
          );

          handle.dispose();
        },
      );

      testWidgets('reports "You" as the value of an X cell', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          sized(GameCell(cell: Cell.x, index: 4, onTap: () {})),
        );

        final finder = find.bySemanticsLabel('Cell 5');
        expect(finder, findsOneWidget);
        expect(tester.getSemantics(finder).value, 'You');

        handle.dispose();
      });

      testWidgets('reports "CPU" as the value of an O cell', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          sized(GameCell(cell: Cell.o, index: 8, onTap: () {})),
        );

        final finder = find.bySemanticsLabel('Cell 9');
        expect(finder, findsOneWidget);
        expect(tester.getSemantics(finder).value, 'CPU');

        handle.dispose();
      });

      testWidgets('removes the tap action when the cell is occupied', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          sized(GameCell(cell: Cell.x, index: 0, onTap: () {})),
        );

        final node = tester.getSemantics(find.bySemanticsLabel('Cell 1'));
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);

        handle.dispose();
      });

      testWidgets('removes the tap action when the board is disabled', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          sized(
            GameCell(
              cell: Cell.empty,
              index: 0,
              isDisabled: true,
              onTap: () {},
            ),
          ),
        );

        final node = tester.getSemantics(find.bySemanticsLabel('Cell 1'));
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);

        handle.dispose();
      });
    });
  });
}

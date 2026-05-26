import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/game_result.dart';
import 'package:tictactoe/features/game/domain/entities/game_roles.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_status_badge.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  group('GameStatusBadge', () {
    testWidgets('shows the your-turn label on the human turn', (tester) async {
      await tester.pumpTestApp(
        const GameStatusBadge(result: GameInProgress(), isCpuThinking: false),
      );

      expect(find.text('Your turn'), findsOneWidget);
    });

    testWidgets('shows the cpu-thinking label while the CPU is computing', (
      tester,
    ) async {
      await tester.pumpTestApp(
        const GameStatusBadge(result: GameInProgress(), isCpuThinking: true),
      );

      expect(find.text('CPU is thinking'), findsOneWidget);
    });

    testWidgets('shows the you-won label when the human wins', (tester) async {
      await tester.pumpTestApp(
        GameStatusBadge(
          result: GameWinner(humanPlayer, [0, 1, 2]),
          isCpuThinking: false,
        ),
      );

      expect(find.text('You won!'), findsOneWidget);
    });

    testWidgets('shows the cpu-won label when the CPU wins', (tester) async {
      await tester.pumpTestApp(
        GameStatusBadge(
          result: GameWinner(cpuPlayer, [0, 1, 2]),
          isCpuThinking: false,
        ),
      );

      expect(find.text('The CPU won!'), findsOneWidget);
    });

    testWidgets('shows the draw label on a draw', (tester) async {
      await tester.pumpTestApp(
        const GameStatusBadge(result: GameDraw(), isCpuThinking: false),
      );

      expect(find.text('Draw!'), findsOneWidget);
    });

    testWidgets('renders French CPU thinking label without overflow', (
      tester,
    ) async {
      await tester.pumpTestApp(
        const GameStatusBadge(result: GameInProgress(), isCpuThinking: true),
        locale: const Locale('fr'),
      );

      expect(find.text("L'ordinateur réfléchit"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders French CPU win label without overflow', (
      tester,
    ) async {
      await tester.pumpTestApp(
        GameStatusBadge(
          result: GameWinner(cpuPlayer, [0, 1, 2]),
          isCpuThinking: false,
        ),
        locale: const Locale('fr'),
      );

      expect(find.text("L'ordinateur a gagné !"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets('renders French CPU win label on narrow width', (tester) async {
      await tester.pumpTestApp(
        SizedBox(
          width: 272,
          child: Center(
            child: GameStatusBadge(
              result: GameWinner(cpuPlayer, [0, 1, 2]),
              isCpuThinking: false,
            ),
          ),
        ),
        locale: const Locale('fr'),
      );

      expect(find.text("L'ordinateur a gagné !"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    group('Semantics', () {
      testWidgets('announces the in-progress state via a live region', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          const GameStatusBadge(result: GameInProgress(), isCpuThinking: false),
        );

        final finder = find.bySemanticsLabel('Your turn');
        expect(finder, findsOneWidget);
        expect(
          tester.getSemantics(finder).flagsCollection.isLiveRegion,
          isTrue,
        );

        handle.dispose();
      });

      testWidgets('announces the cpu-thinking state', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          const GameStatusBadge(result: GameInProgress(), isCpuThinking: true),
        );

        expect(find.bySemanticsLabel('CPU is thinking'), findsOneWidget);

        handle.dispose();
      });

      testWidgets('announces the human-won state', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          GameStatusBadge(
            result: GameWinner(humanPlayer, [0, 1, 2]),
            isCpuThinking: false,
          ),
        );

        expect(find.bySemanticsLabel('You won!'), findsOneWidget);

        handle.dispose();
      });

      testWidgets('announces the cpu-won state', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          GameStatusBadge(
            result: GameWinner(cpuPlayer, [0, 1, 2]),
            isCpuThinking: false,
          ),
        );

        expect(find.bySemanticsLabel('The CPU won!'), findsOneWidget);

        handle.dispose();
      });

      testWidgets('announces the draw state', (tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpTestApp(
          const GameStatusBadge(result: GameDraw(), isCpuThinking: false),
        );

        expect(find.bySemanticsLabel('Draw!'), findsOneWidget);

        handle.dispose();
      });
    });
  });
}

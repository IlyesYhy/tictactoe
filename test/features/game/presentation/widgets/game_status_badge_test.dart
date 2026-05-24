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
        const GameStatusBadge(
          result: GameWinner(humanPlayer),
          isCpuThinking: false,
        ),
      );

      expect(find.text('You won!'), findsOneWidget);
    });

    testWidgets('shows the cpu-won label when the CPU wins', (tester) async {
      await tester.pumpTestApp(
        const GameStatusBadge(
          result: GameWinner(cpuPlayer),
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
        const GameStatusBadge(
          result: GameWinner(cpuPlayer),
          isCpuThinking: false,
        ),
        locale: const Locale('fr'),
      );

      expect(find.text("L'ordinateur a gagné !"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets('renders French CPU win label on narrow width', (tester) async {
      await tester.pumpTestApp(
        const SizedBox(
          width: 272,
          child: Center(
            child: GameStatusBadge(
              result: GameWinner(cpuPlayer),
              isCpuThinking: false,
            ),
          ),
        ),
        locale: const Locale('fr'),
      );

      expect(find.text("L'ordinateur a gagné !"), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

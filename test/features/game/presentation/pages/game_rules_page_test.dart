import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/presentation/pages/game_rules_page.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  group('GameRulesPage', () {
    testWidgets('renders English title, section headers, rules and CTA', (
      tester,
    ) async {
      await tester.pumpTestApp(const GameRulesPage(), wrapWithScaffold: false);

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Game rules'),
        ),
        findsOneWidget,
      );

      expect(find.text('Objective'), findsOneWidget);
      expect(
        find.text(
          'Align three of your marks in a row, column, or diagonal '
          'to win.',
        ),
        findsOneWidget,
      );

      expect(find.text('How to play'), findsOneWidget);
      expect(
        find.text('You play X and always start. The CPU plays O.'),
        findsOneWidget,
      );
      expect(
        find.text('Three marks in a row, column, or diagonal wins the match.'),
        findsOneWidget,
      );
      expect(
        find.text(
          'If the board fills up without a winner, the match ends in a draw.',
        ),
        findsOneWidget,
      );

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Difficulty'), findsOneWidget);
      expect(
        find.text('Easy — the CPU picks moves at random.'),
        findsOneWidget,
      );
      expect(
        find.text('Hard — the CPU plays optimally and never loses.'),
        findsOneWidget,
      );

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Understood, play now !'), findsOneWidget);
    });

    testWidgets('renders French copy under fr locale', (tester) async {
      await tester.pumpTestApp(
        const GameRulesPage(),
        wrapWithScaffold: false,
        locale: const Locale('fr'),
      );

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Règles du jeu'),
        ),
        findsOneWidget,
      );

      expect(find.text('Objectif'), findsOneWidget);
      expect(find.text('Comment jouer'), findsOneWidget);

      expect(
        find.text("Vous jouez X et commencez toujours. L'ordinateur joue O."),
        findsOneWidget,
      );

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Difficulté'), findsOneWidget);
      expect(
        find.text(
          "Difficile — l'ordinateur joue de façon optimale et ne perd jamais.",
        ),
        findsOneWidget,
      );

      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Compris, jouer maintenant !'), findsOneWidget);
    });
  });
}

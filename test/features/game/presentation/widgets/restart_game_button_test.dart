import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/presentation/widgets/restart_game_button.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  group('RestartGameButton', () {
    testWidgets('shows the localized restart label', (tester) async {
      await tester.pumpTestApp(RestartGameButton(onPressed: () {}));

      expect(find.text('Restart'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var taps = 0;
      await tester.pumpTestApp(RestartGameButton(onPressed: () => taps++));
      await tester.tap(find.text('Restart'));

      expect(taps, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpTestApp(const RestartGameButton(onPressed: null));

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.enabled, isFalse);
    });
    testWidgets('shows the French restart label', (tester) async {
      await tester.pumpTestApp(
        RestartGameButton(onPressed: () {}),
        locale: const Locale('fr'),
      );

      expect(find.text('Recommencer'), findsOneWidget);
    });

    testWidgets(
      'renders as FilledButton with play again label when the game is over',
      (tester) async {
        await tester.pumpTestApp(
          RestartGameButton(onPressed: () {}, isGameOver: true),
        );

        expect(find.byType(FilledButton), findsOneWidget);
        expect(find.byType(OutlinedButton), findsNothing);
        expect(find.text('Play again'), findsOneWidget);
        expect(find.text('Restart'), findsNothing);
      },
    );

    testWidgets('shows the French play again label when the game is over', (
      tester,
    ) async {
      await tester.pumpTestApp(
        RestartGameButton(onPressed: () {}, isGameOver: true),
        locale: const Locale('fr'),
      );

      expect(find.text('Rejouer'), findsOneWidget);
    });
  });
}

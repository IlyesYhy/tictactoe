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
  });
}

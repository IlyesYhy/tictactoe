import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_players_legend.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  group('GamePlayersLegend', () {
    testWidgets('shows the human player entry with X icon and you label', (
      tester,
    ) async {
      await tester.pumpTestApp(const GamePlayersLegend());

      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
    });

    testWidgets('shows the cpu player entry with O icon and cpu label', (
      tester,
    ) async {
      await tester.pumpTestApp(const GamePlayersLegend());

      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
      expect(find.text('CPU'), findsOneWidget);
    });
    testWidgets('shows localized French player labels', (tester) async {
      await tester.pumpTestApp(
        const GamePlayersLegend(),
        locale: const Locale('fr'),
      );

      expect(find.text('Vous'), findsOneWidget);
      expect(find.text('Ordinateur'), findsOneWidget);
    });
  });
}

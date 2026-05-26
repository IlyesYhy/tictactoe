import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/presentation/widgets/victory_confetti.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  group('VictoryConfetti', () {
    testWidgets('renders nothing when inactive', (tester) async {
      await tester.pumpTestApp(const VictoryConfetti(active: false));

      expect(find.byType(ConfettiWidget), findsNothing);
    });

    testWidgets('renders a ConfettiWidget when active', (tester) async {
      await tester.pumpTestApp(const VictoryConfetti(active: true));

      expect(find.byType(ConfettiWidget), findsOneWidget);
    });

    testWidgets('shows ConfettiWidget on transition from inactive to active', (
      tester,
    ) async {
      var active = false;
      late StateSetter externalSetState;

      await tester.pumpTestApp(
        StatefulBuilder(
          builder: (context, setState) {
            externalSetState = setState;
            return VictoryConfetti(active: active);
          },
        ),
      );

      expect(find.byType(ConfettiWidget), findsNothing);

      externalSetState(() => active = false);
      await tester.pump();

      expect(find.byType(ConfettiWidget), findsOneWidget);
    });
  });
}

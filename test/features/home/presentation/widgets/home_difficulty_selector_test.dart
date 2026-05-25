import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_difficulty_selector.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  group('HomeDifficultySelector', () {
    testWidgets('renders both difficulty cards', (tester) async {
      await tester.pumpTestApp(
        HomeDifficultySelector(
          selected: GameDifficulty.easy,
          onSelected: (_) {},
        ),
      );

      expect(find.byKey(const Key('home_difficulty_easy')), findsOneWidget);
      expect(find.byKey(const Key('home_difficulty_hard')), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('Hard'), findsOneWidget);
      expect(find.text('Difficulty'), findsOneWidget);
    });

    testWidgets('calls onSelected with easy when easy card is tapped', (
      tester,
    ) async {
      GameDifficulty? selected;
      await tester.pumpTestApp(
        HomeDifficultySelector(
          selected: GameDifficulty.hard,
          onSelected: (value) => selected = value,
        ),
      );

      await tester.tap(find.byKey(const Key('home_difficulty_easy')));

      expect(selected, GameDifficulty.easy);
    });

    testWidgets('calls onSelected with hard when hard card is tapped', (
      tester,
    ) async {
      GameDifficulty? selected;
      await tester.pumpTestApp(
        HomeDifficultySelector(
          selected: GameDifficulty.easy,
          onSelected: (value) => selected = value,
        ),
      );

      await tester.tap(find.byKey(const Key('home_difficulty_hard')));

      expect(selected, GameDifficulty.hard);
    });

    testWidgets('renders localized French labels', (tester) async {
      await tester.pumpTestApp(
        HomeDifficultySelector(
          selected: GameDifficulty.easy,
          onSelected: (_) {},
        ),
        locale: const Locale('fr'),
      );

      expect(find.text('Difficulté'), findsOneWidget);
      expect(find.text('Facile'), findsOneWidget);
      expect(find.text('Difficile'), findsOneWidget);
    });
  });
}

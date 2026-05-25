import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_spacing.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_board.dart';
import 'package:tictactoe/features/game/presentation/widgets/restart_game_button.dart';

import '../../../../helpers/pump_test_app.dart';

void main() {
  Future<void> setScreenSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> pumpGamePage(WidgetTester tester) {
    return tester.pumpTestApp(const GamePage(), wrapWithScaffold: false);
  }

  group('GamePage responsive layout', () {
    testWidgets('caps content width at 420 on wide screens', (tester) async {
      await setScreenSize(tester, const Size(800, 1200));

      await pumpGamePage(tester);

      final buttonWidth = tester.getSize(find.byType(RestartGameButton)).width;

      expect(buttonWidth, moreOrLessEquals(420));
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses available width on narrow screens', (tester) async {
      const screenWidth = 320.0;

      await setScreenSize(tester, const Size(screenWidth, 800));

      await pumpGamePage(tester);

      final buttonWidth = tester.getSize(find.byType(RestartGameButton)).width;

      expect(
        buttonWidth,
        moreOrLessEquals(screenWidth - AppSpacing.gamePagePadding.horizontal),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps the board square on compact screens', (tester) async {
      await setScreenSize(tester, const Size(320, 568));

      await pumpGamePage(tester);

      final boardSize = tester.getSize(find.byType(GameBoard));

      expect(boardSize.width, moreOrLessEquals(boardSize.height));
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps restart button visible on compact screens', (
      tester,
    ) async {
      await setScreenSize(tester, const Size(320, 568));

      await pumpGamePage(tester);

      final buttonFinder = find.byType(RestartGameButton);

      expect(buttonFinder, findsOneWidget);

      final buttonBottom = tester.getBottomLeft(buttonFinder).dy;
      final screenHeight = tester.view.physicalSize.height;

      expect(buttonBottom, lessThanOrEqualTo(screenHeight));
      expect(tester.takeException(), isNull);
    });

    const screenSizes = [
      Size(320, 568), // Small phone.
      Size(375, 667), // Older iPhone.
      Size(390, 844), // Modern phone.
      Size(430, 932), // Large phone.
      Size(768, 1024), // Tablet portrait.
      Size(1024, 768), // Tablet landscape.
    ];

    for (final size in screenSizes) {
      testWidgets('renders without layout exception at '
          '${size.width.toInt()}x${size.height.toInt()}', (tester) async {
        await setScreenSize(tester, size);

        await pumpGamePage(tester);

        expect(find.byType(GamePage), findsOneWidget);
        expect(find.byType(GameBoard), findsOneWidget);
        expect(find.byType(RestartGameButton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('GamePage accessibility', () {
    testWidgets('renders the back button with the localized Back tooltip', (
      tester,
    ) async {
      await pumpGamePage(tester);

      expect(find.byTooltip('Back'), findsOneWidget);
    });
  });
}

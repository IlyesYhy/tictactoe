import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_spacing.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';
import 'package:tictactoe/features/game/presentation/widgets/game_board.dart';
import 'package:tictactoe/features/game/presentation/widgets/restart_game_button.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  Future<void> setScreenSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('GamePage responsive layout', () {
    testWidgets('caps content width at 420 on wide screens', (tester) async {
      await setScreenSize(tester, const Size(800, 1200));

      await tester.pumpWidget(wrap(const GamePage()));

      final buttonWidth = tester.getSize(find.byType(RestartGameButton)).width;

      expect(buttonWidth, moreOrLessEquals(420));
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses available width on narrow screens', (tester) async {
      const screenWidth = 320.0;

      await setScreenSize(tester, const Size(screenWidth, 800));

      await tester.pumpWidget(wrap(const GamePage()));

      final buttonWidth = tester.getSize(find.byType(RestartGameButton)).width;

      expect(
        buttonWidth,
        moreOrLessEquals(screenWidth - AppSpacing.gamePagePadding.horizontal),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps the board square on compact screens', (tester) async {
      await setScreenSize(tester, const Size(320, 568));

      await tester.pumpWidget(wrap(const GamePage()));

      final boardSize = tester.getSize(find.byType(GameBoard));

      expect(boardSize.width, moreOrLessEquals(boardSize.height));
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps restart button visible on compact screens', (
      tester,
    ) async {
      await setScreenSize(tester, const Size(320, 568));

      await tester.pumpWidget(wrap(const GamePage()));

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

        await tester.pumpWidget(wrap(const GamePage()));

        expect(find.byType(GamePage), findsOneWidget);
        expect(find.byType(GameBoard), findsOneWidget);
        expect(find.byType(RestartGameButton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}

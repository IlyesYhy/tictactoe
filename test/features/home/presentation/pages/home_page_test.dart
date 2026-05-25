import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/features/home/presentation/pages/home_page.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  GoRouter buildTestRouter() {
    return GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: AppRouteNames.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.game,
          name: AppRouteNames.game,
          builder: (context, state) => const Scaffold(body: Text('Game route')),
        ),
      ],
    );
  }

  Future<void> pumpAppWithRouter(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: buildTestRouter(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('HomePage', () {
    testWidgets('renders the app title', (tester) async {
      await pumpAppWithRouter(tester);

      expect(find.text('TicTacToe'), findsOneWidget);
    });

    testWidgets('navigates to the game route on new game button tap', (
      tester,
    ) async {
      await pumpAppWithRouter(tester);

      await tester.tap(find.byKey(const Key('home_new_game_button')));
      await tester.pumpAndSettle();

      expect(find.text('Game route'), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });
  });
}

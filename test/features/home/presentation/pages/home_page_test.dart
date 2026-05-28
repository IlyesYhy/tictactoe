import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/app/router/app_routes.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/core/domain/entities/game_difficulty.dart';
import 'package:tictactoe/features/game/di/game_providers.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';
import 'package:tictactoe/features/game/presentation/pages/game_rules_page.dart';
import 'package:tictactoe/features/home/presentation/pages/home_page.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_bottom_navigation.dart';
import 'package:tictactoe/features/home/presentation/widgets/home_difficulty_selector.dart';
import 'package:tictactoe/features/stats/di/stats_providers.dart';
import 'package:tictactoe/features/stats/domain/entities/completed_match.dart';
import 'package:tictactoe/features/stats/domain/entities/match_history.dart';
import 'package:tictactoe/features/stats/domain/entities/match_outcome.dart';
import 'package:tictactoe/features/stats/presentation/pages/stats_page.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  GoRouter buildStubGameRouter() {
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
        GoRoute(
          path: AppRoutes.settings,
          name: AppRouteNames.settings,
          builder: (context, state) =>
              const Scaffold(body: Text('Settings route')),
        ),
      ],
    );
  }

  GoRouter buildIntegrationRouter({String initialLocation = AppRoutes.home}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: AppRouteNames.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRoutes.game,
          name: AppRouteNames.game,
          builder: (context, state) => const GamePage(),
        ),
      ],
    );
  }

  Future<ProviderContainer> pumpHome(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    MatchHistory? initialHistory,
  }) async {
    final container = ProviderContainer(
      overrides: [
        initialMatchHistoryProvider.overrideWithValue(
          initialHistory ?? MatchHistory.empty(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: buildStubGameRouter(),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    return container;
  }

  Future<ProviderContainer> pumpAppForNavigation(
    WidgetTester tester, {
    String initialLocation = AppRoutes.home,
  }) async {
    final container = ProviderContainer(
      overrides: [
        initialMatchHistoryProvider.overrideWithValue(MatchHistory.empty()),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: buildIntegrationRouter(
            initialLocation: initialLocation,
          ),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    return container;
  }

  group('HomePage play tab', () {
    testWidgets('renders title, subtitle, mascot, selector and CTA', (
      tester,
    ) async {
      await pumpHome(tester);

      expect(find.text('TicTacToe'), findsOneWidget);
      expect(find.text('Play against the computer'), findsOneWidget);
      expect(find.byKey(const Key('home_mascot')), findsOneWidget);
      expect(find.byType(HomeDifficultySelector), findsOneWidget);
      expect(find.byKey(const Key('home_new_game_button')), findsOneWidget);
      expect(find.text('New game'), findsOneWidget);
      expect(find.byKey(const Key('home_settings_button')), findsOneWidget);
    });

    testWidgets('navigates to the settings route on settings icon tap', (
      tester,
    ) async {
      await pumpHome(tester);

      await tester.tap(find.byKey(const Key('home_settings_button')));
      await tester.pumpAndSettle();

      expect(find.text('Settings route'), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('updates difficultyProvider when a card is selected', (
      tester,
    ) async {
      final container = await pumpHome(tester);

      expect(container.read(difficultyProvider), GameDifficulty.easy);

      await tester.tap(find.byKey(const Key('home_difficulty_hard')));
      await tester.pump();

      expect(container.read(difficultyProvider), GameDifficulty.hard);
    });

    testWidgets('navigates to the game route on new game button tap', (
      tester,
    ) async {
      await pumpHome(tester);

      await tester.ensureVisible(find.byKey(const Key('home_new_game_button')));
      await tester.tap(find.byKey(const Key('home_new_game_button')));
      await tester.pumpAndSettle();

      expect(find.text('Game route'), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets('renders localized French copy', (tester) async {
      await pumpHome(tester, locale: const Locale('fr'));

      expect(find.text("Jouez contre l'ordinateur"), findsOneWidget);
      expect(find.text('Nouvelle partie'), findsOneWidget);
    });
  });

  group('HomePage bottom navigation', () {
    int selectedTab(WidgetTester tester) {
      return tester
          .widget<HomeBottomNavigation>(find.byType(HomeBottomNavigation))
          .selectedIndex;
    }

    testWidgets('renders all three tab destinations', (tester) async {
      await pumpHome(tester);

      expect(find.byKey(const Key('home_tab_play')), findsOneWidget);
      expect(find.byKey(const Key('home_tab_rules')), findsOneWidget);
      expect(find.byKey(const Key('home_tab_stats')), findsOneWidget);
      expect(find.text('Play'), findsOneWidget);
      expect(find.text('Rules'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });

    testWidgets('selects the Play tab by default', (tester) async {
      await pumpHome(tester);

      expect(selectedTab(tester), 0);
    });

    testWidgets('selects the Stats tab when its destination is tapped', (
      tester,
    ) async {
      await pumpHome(tester);

      await tester.tap(find.byKey(const Key('home_tab_stats')));
      await tester.pumpAndSettle();

      expect(selectedTab(tester), 1);
    });

    testWidgets('selects the Rules tab when its destination is tapped', (
      tester,
    ) async {
      await pumpHome(tester);

      await tester.tap(find.byKey(const Key('home_tab_rules')));
      await tester.pumpAndSettle();

      expect(selectedTab(tester), 2);
    });

    testWidgets('returns to the Play tab when its destination is tapped', (
      tester,
    ) async {
      await pumpHome(tester);

      await tester.tap(find.byKey(const Key('home_tab_stats')));
      await tester.pumpAndSettle();
      expect(selectedTab(tester), 1);

      await tester.tap(find.byKey(const Key('home_tab_play')));
      await tester.pumpAndSettle();

      expect(selectedTab(tester), 0);
    });

    testWidgets('Play now CTA in the Rules tab switches back to the Play tab', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await pumpHome(tester);

      await tester.tap(find.byKey(const Key('home_tab_rules')));
      await tester.pumpAndSettle();
      expect(selectedTab(tester), 2);

      await tester.tap(find.text('Understood, play now !'));
      await tester.pumpAndSettle();

      expect(selectedTab(tester), 0);
    });

    testWidgets('renders localized French tab labels', (tester) async {
      await pumpHome(tester, locale: const Locale('fr'));

      expect(find.text('Jouer'), findsOneWidget);
      expect(find.text('Règles'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
    });

    testWidgets('returning to the Rules tab resets its scroll position', (
      tester,
    ) async {
      await pumpHome(tester);

      await tester.tap(find.byKey(const Key('home_tab_rules')));
      await tester.pumpAndSettle();

      final rulesScrollable = find
          .descendant(
            of: find.byType(GameRulesPage),
            matching: find.byType(Scrollable),
          )
          .first;

      await tester.drag(rulesScrollable, const Offset(0, -200));
      await tester.pump();
      expect(
        tester.state<ScrollableState>(rulesScrollable).position.pixels,
        greaterThan(0),
      );

      await tester.tap(find.byKey(const Key('home_tab_play')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_tab_rules')));
      await tester.pumpAndSettle();

      expect(tester.state<ScrollableState>(rulesScrollable).position.pixels, 0);
    });

    testWidgets('returning to the Stats tab resets its scroll position', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(400, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final matches = List<CompletedMatch>.generate(
        3,
        (_) => CompletedMatch(
          outcome: MatchOutcome.humanWon,
          difficulty: GameDifficulty.easy,
          playedAt: DateTime(2026, 5, 27),
        ),
      );
      await pumpHome(tester, initialHistory: MatchHistory(matches));

      await tester.tap(find.byKey(const Key('home_tab_stats')));
      await tester.pumpAndSettle();

      final statsScrollable = find
          .descendant(
            of: find.byType(StatsPage),
            matching: find.byType(Scrollable),
          )
          .first;

      await tester.drag(statsScrollable, const Offset(0, -120));
      await tester.pump();
      expect(
        tester.state<ScrollableState>(statsScrollable).position.pixels,
        greaterThan(0),
      );

      await tester.tap(find.byKey(const Key('home_tab_play')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_tab_stats')));
      await tester.pumpAndSettle();

      expect(tester.state<ScrollableState>(statsScrollable).position.pixels, 0);
    });
  });

  group('HomePage compact layout', () {
    void setNarrowViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    testWidgets('renders all key elements without overflow exception', (
      tester,
    ) async {
      setNarrowViewport(tester);

      await pumpHome(tester);

      expect(find.text('TicTacToe'), findsOneWidget);
      expect(find.text('Play against the computer'), findsOneWidget);
      expect(find.byKey(const Key('home_mascot')), findsOneWidget);
      expect(find.byKey(const Key('home_difficulty_easy')), findsOneWidget);
      expect(find.byKey(const Key('home_difficulty_hard')), findsOneWidget);
      expect(find.byKey(const Key('home_new_game_button')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders French copy without overflow exception', (
      tester,
    ) async {
      setNarrowViewport(tester);

      await pumpHome(tester, locale: const Locale('fr'));

      expect(find.text("Jouez contre l'ordinateur"), findsOneWidget);
      expect(find.text('Difficulté'), findsOneWidget);
      expect(find.text('Nouvelle partie'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('HomePage ↔ GamePage navigation', () {
    testWidgets('returns to HomePage when back is tapped on GamePage', (
      tester,
    ) async {
      await pumpAppForNavigation(tester);

      await tester.ensureVisible(find.byKey(const Key('home_new_game_button')));
      await tester.tap(find.byKey(const Key('home_new_game_button')));
      await tester.pumpAndSettle();

      expect(find.byType(GamePage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(GamePage), findsNothing);
    });

    testWidgets(
      'falls back to HomePage when back is tapped after direct game entry',
      (tester) async {
        await pumpAppForNavigation(tester, initialLocation: AppRoutes.game);

        expect(find.byType(GamePage), findsOneWidget);

        await tester.tap(find.byIcon(Icons.arrow_back_rounded));
        await tester.pumpAndSettle();

        expect(find.byType(HomePage), findsOneWidget);
        expect(find.byType(GamePage), findsNothing);
      },
    );
  });
}

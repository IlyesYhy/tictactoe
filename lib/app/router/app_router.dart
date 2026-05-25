import 'package:go_router/go_router.dart';

import '../../features/game/presentation/pages/game_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import 'app_routes.dart';

/// Static navigation configuration for the app.
///
/// Kept as a top-level `final` because the route tree does not depend on
/// runtime state. Promoting it to a Riverpod-managed provider would only be
/// justified if route guards or deep-link parameters needed to react to
/// shared state.
final appRouter = GoRouter(
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
      builder: (context, state) => const GamePage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: AppRouteNames.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

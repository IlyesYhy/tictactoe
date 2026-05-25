/// Centralizes the application route paths so navigation targets stay
/// typo-safe and easy to change.
abstract final class AppRoutes {
  static const home = '/';
  static const game = '/game';
  static const settings = '/settings';
}

/// Centralizes the application route names so callers can rely on
/// `context.goNamed(AppRouteNames.game)` rather than raw strings.
abstract final class AppRouteNames {
  static const home = 'home';
  static const game = 'game';
  static const settings = 'settings';
}

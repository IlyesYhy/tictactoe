# Architecture

## Clean Architecture layers

```text
UI / controllers ─────▶ domain contracts ◀──── data implementations
         ▲                                                       ▲
         └───── composition root wires them from the outside ────┘
                 without changing the dependency direction.
```

The domain layer contains the game rules and business logic. It does not depend on Flutter, Riverpod, go_router, or any data implementation.

The presentation layer contains pages, widgets, controllers and UI state.

The data layer contains concrete implementations behind domain abstractions.

The `di/` folder acts as the feature-level composition root and wires domain abstractions to concrete implementations.

## Feature folder layout

Example for the game feature:

```
lib/features/game/
  domain/
    entities/
    repositories/
    services/
    usecases/

  data/
    repositories/

  presentation/
    controllers/
    pages/
    states/
    widgets/

  di/
    game_providers.dart
```

The stats feature owns its own domain entities, repository contract, persistence implementation, controller, and UI. Completed games are recorded through the app-level `GameStatsRecorder`, so the game feature does not need to know that statistics exist.

### `domain/`

Pure Dart layer containing entities, use cases, repository contracts, and game services.

### `data/`

Concrete implementations of domain contracts.

### `presentation/`

Flutter and Riverpod-facing layer containing UI and state controllers.

### `di/`

Composition root for the feature. This is where providers wire use cases, repositories, services and strategies together.

## Composition root

Provider wiring lives in:

```
lib/features/game/di/game_providers.dart
```

This avoids placing data-layer dependencies inside the presentation layer.

`Provider.family` is used for CPU strategy wiring so the selected `GameDifficulty` is passed explicitly and captured when a game starts. This prevents the CPU strategy from changing mid-game if the user later selects another difficulty on the HomePage.

### App-level wiring

Cross-feature wiring lives in `lib/app/di/`. `GameStatsRecorder` (`lib/app/integrations/game_stats_recorder.dart`) listens for a finished game and records the result through the stats feature. This keeps `game` and `stats` decoupled: neither feature imports the other, and the bridge is owned by the app layer.

## State management

The project uses Riverpod.

### `difficultyProvider`

Stores the currently selected difficulty from the HomePage.

### `gameControllerProvider`

Owns the current game session and exposes user actions such as playing a human turn and resetting the game.

### `Provider`

Used for stateless dependencies such as use cases or services.

### `Notifier`

Used when a provider owns mutable state.

### `Provider.family`

Used when the dependency must be parameterized, for example by `GameDifficulty`.

## Navigation

The app uses `go_router` for screen-level routes and an in-page tab shell for the home experience.

Routes are centralized through:

- `AppRoutes`
- `AppRouteNames`

### Home tab shell

`HomePage` is a shell that hosts three destinations through an `IndexedStack`:

- Play
- Rules
- Stats

Rules and Stats are embedded tabs, so they have no standalone route. `IndexedStack` keeps each tab's state alive while switching.

### Pushed routes

Game (`/game`) and Settings (`/settings`) are pushed on top of the shell with `pushNamed`, because they open a focused screen over the home experience.

The GamePage back button uses:

- `canPop` → `pop`
- else → `goNamed(home)`

This supports both normal navigation and direct `/game` entry.

## Theming

The app defines:

- `AppTheme.light`
- `AppTheme.dark`

The theme uses `ColorScheme.fromSeed` with explicit brand color overrides.

Game-specific colors are stored in `GameThemeExtension`, and outcome colors (draw, defeat) in `StatsOutcomeColors`. Both are theme extensions registered on the light and dark themes.

`AppColors` is internal to the app theme and should not be imported directly by feature widgets. Feature widgets should consume colors through `ThemeData`, `ColorScheme`, or `ThemeExtension`.

## Localization

Localization uses ARB files and Flutter's generated localization system.

The app exposes localized strings through:

```dart
context.l10n.someKey
```

Generated localization files are committed so the project can be cloned, analyzed and tested without requiring an extra generation step before first use.

## Testing strategy

The test suite follows this priority order:

1. domain tests
2. controller tests
3. widget tests
4. navigation/page tests

### Domain tests

Pure Dart tests for game rules, board behavior, results and CPU strategies.

### Controller tests

Riverpod ProviderContainer tests with overrides where needed.

### Widget tests

UI tests using test helpers such as `pumpTestApp`.

### Navigation tests

Router-based tests using real or stub routes depending on the behavior under test.

### Determinism

Random behavior is controlled through seeded `Random` instances or provider overrides to keep tests deterministic.

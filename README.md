# TicTacToe Flutter Challenge

A Flutter Tic-Tac-Toe application ready to scale.

The goal of this project is to showcase a production-oriented Flutter architecture with a clean separation of concerns, testable business logic, and a maintainable codebase.

## Technical Decisions

### Feature-first architecture

The app is organized by feature to make the codebase scalable and easier to maintain as new functionality is added.

### Clean Architecture

Business logic is isolated from the presentation layer so it can be tested independently from Flutter.

### Riverpod v2

Riverpod is used for dependency injection and state management, aligned with modern Flutter development practices.

### Bootstrap layer

The app startup logic is centralized in bootstrap.dart to keep main.dart minimal and prepare the project for production concerns such as error reporting or environment configuration.

### Theme system

The project uses Flutter’s ThemeData and TextTheme to keep the UI consistent and aligned with the Flutter ecosystem.

`AppColors` is an internal design-system palette and should only be used inside `lib/app/theme/`.

Feature widgets must consume colors through `ThemeData`, `ColorScheme`, or dedicated `ThemeExtension`s.

### Localization

The app supports English and French using Flutter's official localization system.

Translations are defined with ARB files under `lib/l10n/` and accessed through a `BuildContext` extension:

```dart
context.l10n.appTitle
```

Generated localization files are committed to the repository on purpose.

For this technical test, this keeps the project immediately usable after cloning, makes localization API changes explicit in pull requests, and keeps the review process straightforward.

When ARB files change, `flutter pub get` regenerates the Dart files automatically thanks to `generate: true` in `pubspec.yaml`.

## Getting started

```bash
flutter pub get
flutter run
```

## Quality

The project uses:

- Flutter analysis options
- Commitlint
- Husky Git hooks

The project follows conventional commits rules, making it compatible with automated changelog and release workflows if needed.

```bash
flutter analyze
dart format .
```

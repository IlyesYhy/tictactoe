# TicTacToe Flutter Challenge

A Flutter Tic-Tac-Toe application ready to scale.

The goal of this project is to showcase a production-oriented Flutter architecture with a clean separation of concerns, testable business logic, and a maintainable codebase.

## Technical Choices

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

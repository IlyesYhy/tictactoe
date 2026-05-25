# TicTacToe Flutter Challenge

## Overview

TicTacToe is a Flutter technical challenge where a human player plays locally against a CPU opponent. The project focuses on Clean Architecture, testability, maintainability, and a production-oriented Flutter structure.

## Highlights

- Human vs CPU Tic-Tac-Toe
- Easy and Hard difficulty levels
- Clean Architecture
- Riverpod state management
- go_router navigation
- English and French localization
- Light and dark themes
- Responsive UI
- Automated tests

## Getting started

### Prerequisites

- Flutter SDK compatible with the version defined in `pubspec.yaml`

### Install

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Test

```bash
flutter test
```

### Quality checks

```bash
flutter analyze
dart format .
```

## Project structure

```
lib/
  app/          App-level configuration: theme, router, root widget
  core/         Shared extensions and reusable helpers
  features/     Feature-first application modules
  l10n/         Localization files and generated delegates

test/           Automated tests mirroring the production structure
assets/         Static images used by the UI
```

## Architecture

This project follows a feature-first Clean Architecture approach. Each feature separates domain logic, data implementations, presentation widgets/controllers, and dependency wiring.

For a deeper technical overview, see [ARCHITECTURE.md](ARCHITECTURE.md).

## Quality & conventions

- Conventional commits
- Husky and commitlint
- flutter_lints
- Automated tests for domain logic, controllers, widgets and navigation flows

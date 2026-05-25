import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/di/game_providers.dart';
import 'package:tictactoe/features/game/domain/entities/game_difficulty.dart';

void main() {
  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('difficultyProvider', () {
    test('defaults to easy', () {
      final container = createContainer();

      expect(container.read(difficultyProvider), GameDifficulty.easy);
    });

    test('updates the state when select is called', () {
      final container = createContainer();

      container
          .read(difficultyProvider.notifier)
          .select(GameDifficulty.hard);

      expect(container.read(difficultyProvider), GameDifficulty.hard);
    });
  });

  group('cpuRepositoryProvider', () {
    test('returns a distinct repository per requested difficulty', () {
      final container = createContainer();

      final easyRepository = container.read(
        cpuRepositoryProvider(GameDifficulty.easy),
      );
      final hardRepository = container.read(
        cpuRepositoryProvider(GameDifficulty.hard),
      );

      expect(identical(easyRepository, hardRepository), isFalse);
    });
  });
}

/// Difficulty levels the player can pick before starting a game.
///
/// Each level maps to a different CPU move strategy.
enum GameDifficulty {
  easy,
  hard;

  static GameDifficulty? fromName(String name) {
    return switch (name) {
      'easy' => GameDifficulty.easy,
      'hard' => GameDifficulty.hard,
      _ => null,
    };
  }
}

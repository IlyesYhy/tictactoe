enum MatchOutcome {
  humanWon,
  cpuWon,
  draw;

  static MatchOutcome? fromName(String name) {
    return switch (name) {
      'humanWon' => MatchOutcome.humanWon,
      'cpuWon' => MatchOutcome.cpuWon,
      'draw' => MatchOutcome.draw,
      _ => null,
    };
  }
}

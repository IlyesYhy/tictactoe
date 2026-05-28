// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TicTacToe';

  @override
  String get yourTurn => 'Your turn';

  @override
  String get cpuThinking => 'CPU is thinking';

  @override
  String get youWon => 'You won!';

  @override
  String get cpuWon => 'The CPU won!';

  @override
  String get draw => 'Draw!';

  @override
  String get you => 'You';

  @override
  String get cpu => 'CPU';

  @override
  String get restartGame => 'Restart';

  @override
  String get playAgain => 'Play again';

  @override
  String get newGame => 'New game';

  @override
  String get homeSubtitle => 'Play against the computer';

  @override
  String get difficultyTitle => 'Difficulty';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyHard => 'Hard';

  @override
  String cellSemanticLabel(int position) {
    return 'Cell $position';
  }

  @override
  String get cellStateEmpty => 'empty';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageFrench => 'French';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsHapticFeedback => 'Haptic feedback';

  @override
  String get gameRulesTitle => 'Game rules';

  @override
  String get gameRulesSubtitle => 'All you need to know to play TicTacToe';

  @override
  String get gameRulesObjective => 'Objective';

  @override
  String get gameRulesObjectiveDescription =>
      'Align three of your marks in a row, column, or diagonal to win.';

  @override
  String get gameRulesHowToPlay => 'How to play';

  @override
  String get gameRulesStart => 'You play X and always start. The CPU plays O.';

  @override
  String get gameRulesWin =>
      'Three marks in a row, column, or diagonal wins the match.';

  @override
  String get gameRulesDraw =>
      'If the board fills up without a winner, the match ends in a draw.';

  @override
  String get gameRulesDifficulty => 'Difficulty';

  @override
  String get gameRulesEasy => 'Easy — the CPU picks moves at random.';

  @override
  String get gameRulesHard => 'Hard — the CPU plays optimally and never loses.';

  @override
  String get gameRulesPlayNow => 'Understood, play now !';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsGameRules => 'Game rules';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPlayer => 'Player';

  @override
  String get settingsPlayerSubtitle => 'Customize your experience';

  @override
  String get settingsPlayerName => 'Player name';

  @override
  String get settingsPreferredSymbol => 'Preferred symbol';

  @override
  String get statsTitle => 'Statistics';

  @override
  String statsVictoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Victories',
      one: 'Victory',
    );
    return '$_temp0';
  }

  @override
  String statsDefeatCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Defeats',
      one: 'Defeat',
    );
    return '$_temp0';
  }

  @override
  String statsDrawCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Draws',
      one: 'Draw',
    );
    return '$_temp0';
  }

  @override
  String get statsTotalMatches => 'Total matches';

  @override
  String get statsWinRate => 'Win rate';

  @override
  String get statsEmpty => 'Play your first match to see your stats here.';

  @override
  String get homeTabPlay => 'Play';

  @override
  String get homeTabRules => 'Rules';

  @override
  String get homeTabStats => 'Stats';

  @override
  String get statsHistory => 'History';

  @override
  String get statsHistoryToday => 'Today';

  @override
  String get statsHistoryYesterday => 'Yesterday';

  @override
  String get matchOutcomeVictory => 'Victory';

  @override
  String get matchOutcomeDefeat => 'Defeat';

  @override
  String get matchOutcomeDraw => 'Draw';

  @override
  String get statsByDifficulty => 'Results by difficulty';

  @override
  String statsMatchCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Matches',
      one: 'Match',
      zero: 'Matches',
    );
    return '$_temp0';
  }
}

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
}

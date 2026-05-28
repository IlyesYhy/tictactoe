import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Application title used in the OS task bar and on the home screen.
  ///
  /// In en, this message translates to:
  /// **'TicTacToe'**
  String get appTitle;

  /// Status message displayed when it is the human player's turn.
  ///
  /// In en, this message translates to:
  /// **'Your turn'**
  String get yourTurn;

  /// Status message displayed while the CPU is computing its next move.
  ///
  /// In en, this message translates to:
  /// **'CPU is thinking'**
  String get cpuThinking;

  /// Result message displayed when the human player wins the game.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get youWon;

  /// Result message displayed when the CPU wins the game.
  ///
  /// In en, this message translates to:
  /// **'The CPU won!'**
  String get cpuWon;

  /// Result message displayed when the game ends without a winner.
  ///
  /// In en, this message translates to:
  /// **'Draw!'**
  String get draw;

  /// Label used to identify the human player.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Label used to identify the computer-controlled opponent.
  ///
  /// In en, this message translates to:
  /// **'CPU'**
  String get cpu;

  /// Button label used to restart the current game while it is still in progress.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartGame;

  /// Button label used to start a new game once the current one has ended.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// Primary call-to-action used to start a new game from the home page.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// Tagline shown on the home page below the app title.
  ///
  /// In en, this message translates to:
  /// **'Play against the computer'**
  String get homeSubtitle;

  /// Section heading above the difficulty selector on the home page.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficultyTitle;

  /// Label for the easy difficulty option (random CPU strategy).
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// Label for the hard difficulty option (minimax CPU strategy).
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// Accessibility label for a board cell, identifying its 1-based position (1 to 9).
  ///
  /// In en, this message translates to:
  /// **'Cell {position}'**
  String cellSemanticLabel(int position);

  /// Accessibility value spoken when a board cell has not been played yet.
  ///
  /// In en, this message translates to:
  /// **'empty'**
  String get cellStateEmpty;

  /// AppBar title on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Section header for the language selector on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Label for the English language option on the settings page.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// Label for the French language option on the settings page.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFrench;

  /// Section header for the theme selector on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Label for the light theme option on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// Label for the dark theme option on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// Label for the system theme option on the settings page.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// Section header for the user preferences on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// Toggle label that enables or disables vibration feedback when tapping a board cell.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsHapticFeedback;

  /// AppBar title on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'Game rules'**
  String get gameRulesTitle;

  /// AppBar subtitle on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'All you need to know to play TicTacToe'**
  String get gameRulesSubtitle;

  /// Section header introducing the goal of the game on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get gameRulesObjective;

  /// Sentence describing how to win a game on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'Align three of your marks in a row, column, or diagonal to win.'**
  String get gameRulesObjectiveDescription;

  /// Section header listing the basic gameplay rules on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get gameRulesHowToPlay;

  /// Bullet describing player turn order on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'You play X and always start. The CPU plays O.'**
  String get gameRulesStart;

  /// Bullet describing the winning condition on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'Three marks in a row, column, or diagonal wins the match.'**
  String get gameRulesWin;

  /// Bullet describing the draw condition on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'If the board fills up without a winner, the match ends in a draw.'**
  String get gameRulesDraw;

  /// Section header introducing the difficulty levels on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get gameRulesDifficulty;

  /// Bullet describing the Easy difficulty behavior on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'Easy — the CPU picks moves at random.'**
  String get gameRulesEasy;

  /// Bullet describing the Hard difficulty behavior on the game rules page.
  ///
  /// In en, this message translates to:
  /// **'Hard — the CPU plays optimally and never loses.'**
  String get gameRulesHard;

  /// Call-to-action button label on the game rules page that closes the rules screen and lets the user start playing.
  ///
  /// In en, this message translates to:
  /// **'Understood, play now !'**
  String get gameRulesPlayNow;

  /// Section header for the about block on the settings page.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// Tile title opening the game rules page from the settings page.
  ///
  /// In en, this message translates to:
  /// **'Game rules'**
  String get settingsGameRules;

  /// Tile title displaying the installed app version on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// Section header for the player block on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get settingsPlayer;

  /// Subtitle shown under the player section header inviting customization.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get settingsPlayerSubtitle;

  /// Label for the player name row on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Player name'**
  String get settingsPlayerName;

  /// Label for the preferred symbol row on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Preferred symbol'**
  String get settingsPreferredSymbol;

  /// AppBar title on the statistics page.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// Counter label for matches won by the human player.
  ///
  /// In en, this message translates to:
  /// **'Victories'**
  String get statsVictories;

  /// Counter label for matches won by the CPU.
  ///
  /// In en, this message translates to:
  /// **'Defeats'**
  String get statsDefeats;

  /// Counter label for matches that ended in a draw.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get statsDraws;

  /// Label for the total number of recorded matches.
  ///
  /// In en, this message translates to:
  /// **'Total matches'**
  String get statsTotalMatches;

  /// Label for the percentage of matches won by the human player.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get statsWinRate;

  /// Empty-state message shown on the statistics page when no match has been recorded yet.
  ///
  /// In en, this message translates to:
  /// **'Play your first match to see your stats here.'**
  String get statsEmpty;

  /// Bottom navigation label for the play tab on the home shell.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get homeTabPlay;

  /// Bottom navigation label for the rules tab on the home shell.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get homeTabRules;

  /// Bottom navigation label for the stats tab on the home shell.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get homeTabStats;

  /// Section title above the match history list on the statistics page.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get statsHistory;

  /// Date label used when a match was played on the same calendar day as now.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsHistoryToday;

  /// Date label used when a match was played on the previous calendar day.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get statsHistoryYesterday;

  /// Outcome label used for a single match won by the human player.
  ///
  /// In en, this message translates to:
  /// **'Victory'**
  String get matchOutcomeVictory;

  /// Outcome label used for a single match won by the CPU.
  ///
  /// In en, this message translates to:
  /// **'Defeat'**
  String get matchOutcomeDefeat;

  /// Outcome label used for a single match that ended in a draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get matchOutcomeDraw;

  /// Section title above the per-difficulty stats cards on the statistics page.
  ///
  /// In en, this message translates to:
  /// **'Results by difficulty'**
  String get statsByDifficulty;

  /// Short label rendered under the total match count, for example inside the donut chart.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get statsMatchesLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

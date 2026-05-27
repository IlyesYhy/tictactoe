// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TicTacToe';

  @override
  String get yourTurn => 'À vous de jouer';

  @override
  String get cpuThinking => 'L\'ordinateur réfléchit';

  @override
  String get youWon => 'Vous avez gagné !';

  @override
  String get cpuWon => 'L\'ordinateur a gagné !';

  @override
  String get draw => 'Match nul !';

  @override
  String get you => 'Vous';

  @override
  String get cpu => 'Ordinateur';

  @override
  String get restartGame => 'Recommencer';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get homeSubtitle => 'Jouez contre l\'ordinateur';

  @override
  String get difficultyTitle => 'Difficulté';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String cellSemanticLabel(int position) {
    return 'Case $position';
  }

  @override
  String get cellStateEmpty => 'vide';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageEnglish => 'Anglais';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsPreferences => 'Préférences';

  @override
  String get settingsHapticFeedback => 'Vibrations';

  @override
  String get gameRulesTitle => 'Règles du jeu';

  @override
  String get gameRulesSubtitle =>
      'Tout ce que vous devez savoir pour jouer au TicTacToe';

  @override
  String get gameRulesObjective => 'Objectif';

  @override
  String get gameRulesObjectiveDescription =>
      'Alignez trois de vos symboles en ligne, colonne ou diagonale pour gagner.';

  @override
  String get gameRulesHowToPlay => 'Comment jouer';

  @override
  String get gameRulesStart =>
      'Vous jouez X et commencez toujours. L\'ordinateur joue O.';

  @override
  String get gameRulesWin =>
      'Trois symboles alignés en ligne, colonne ou diagonale gagnent la partie.';

  @override
  String get gameRulesDraw =>
      'Si le plateau se remplit sans gagnant, la partie se termine par un match nul.';

  @override
  String get gameRulesDifficulty => 'Difficulté';

  @override
  String get gameRulesEasy => 'Facile — l\'ordinateur joue au hasard.';

  @override
  String get gameRulesHard =>
      'Difficile — l\'ordinateur joue de façon optimale et ne perd jamais.';

  @override
  String get gameRulesPlayNow => 'Compris, jouer maintenant !';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsGameRules => 'Règles du jeu';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPlayer => 'Joueur';

  @override
  String get settingsPlayerSubtitle => 'Personnalisez votre expérience';

  @override
  String get settingsPlayerName => 'Nom du joueur';

  @override
  String get settingsPreferredSymbol => 'Symbole préféré';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get statsVictories => 'Victoires';

  @override
  String get statsDefeats => 'Défaites';

  @override
  String get statsDraws => 'Nuls';

  @override
  String get statsTotalMatches => 'Parties jouées';

  @override
  String get statsWinRate => 'Taux de victoire';

  @override
  String get statsEmpty =>
      'Jouez votre première partie pour voir vos statistiques ici.';

  @override
  String get homeTabPlay => 'Jouer';

  @override
  String get homeTabRules => 'Règles';

  @override
  String get homeTabStats => 'Stats';

  @override
  String get statsHistory => 'Historique';

  @override
  String get statsHistoryToday => 'Aujourd\'hui';

  @override
  String get statsHistoryYesterday => 'Hier';

  @override
  String get matchOutcomeVictory => 'Victoire';

  @override
  String get matchOutcomeDefeat => 'Défaite';

  @override
  String get matchOutcomeDraw => 'Match nul';
}

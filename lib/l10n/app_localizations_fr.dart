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
}

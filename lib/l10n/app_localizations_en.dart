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
  String cellSemanticLabel(int position) {
    return 'Cell $position';
  }

  @override
  String get cellStateEmpty => 'empty';
}

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('stats outcome count pluralization (en)', () {
    late AppLocalizations l10n;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    test('victory count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsVictoryCount(1), 'Victory');
      expect(l10n.statsVictoryCount(2), 'Victories');
    });

    test('defeat count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsDefeatCount(1), 'Defeat');
      expect(l10n.statsDefeatCount(2), 'Defeats');
    });

    test('draw count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsDrawCount(1), 'Draw');
      expect(l10n.statsDrawCount(2), 'Draws');
    });

    test('match count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsMatchCount(1), 'Match');
      expect(l10n.statsMatchCount(2), 'Matches');
    });
  });

  group('stats outcome count pluralization (fr)', () {
    late AppLocalizations l10n;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('fr'));
    });

    test('victory count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsVictoryCount(1), 'Victoire');
      expect(l10n.statsVictoryCount(2), 'Victoires');
    });

    test('defeat count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsDefeatCount(1), 'Défaite');
      expect(l10n.statsDefeatCount(2), 'Défaites');
    });

    test('draw count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsDrawCount(1), 'Nul');
      expect(l10n.statsDrawCount(2), 'Nuls');
    });

    test('match count uses singular for 1 and plural otherwise', () {
      expect(l10n.statsMatchCount(1), 'Partie');
      expect(l10n.statsMatchCount(2), 'Parties');
    });
  });
}

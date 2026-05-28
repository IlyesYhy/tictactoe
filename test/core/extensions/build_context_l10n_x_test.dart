import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

void main() {
  testWidgets('loads app localizations from context extension', (tester) async {
    AppLocalizations? captured;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            captured = context.l10n;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(captured, isA<AppLocalizations>());
    expect(captured!.appTitle, 'TicTacToe');
  });
}

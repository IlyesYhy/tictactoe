import 'package:flutter/material.dart';
import 'package:tictactoe/core/extensions/build_context_l10n_x.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        return supportedLocales.firstWhere(
          (supported) => supported.languageCode == locale?.languageCode,
          orElse: () => const Locale('en'),
        );
      },
      home: const GamePage(),
    );
  }
}

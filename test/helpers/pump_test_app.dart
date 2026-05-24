import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/theme/app_theme.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

extension PumpTestApp on WidgetTester {
  Future<void> pumpTestApp(
    Widget child, {
    Locale locale = const Locale('en'),
    bool wrapWithScaffold = true,
  }) {
    return pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: wrapWithScaffold ? Scaffold(body: Center(child: child)) : child,
      ),
    );
  }
}

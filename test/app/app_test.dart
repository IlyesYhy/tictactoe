import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/app/app.dart';

void main() {
  group('App theme mode', () {
    testWidgets('uses dark theme when platform brightness is dark', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(const ProviderScope(child: App()));

      final scaffoldContext = tester.element(find.byType(Scaffold));
      expect(Theme.of(scaffoldContext).brightness, Brightness.dark);
    });

    testWidgets('uses light theme when platform brightness is light', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(const ProviderScope(child: App()));

      final scaffoldContext = tester.element(find.byType(Scaffold));
      expect(Theme.of(scaffoldContext).brightness, Brightness.light);
    });
  });
}

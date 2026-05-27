import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/di/app_overrides.dart';

Future<void> bootstrap() {
  return runZonedGuarded(
        () async {
          WidgetsFlutterBinding.ensureInitialized();

          FlutterError.onError = (details) {
            FlutterError.presentError(details);
          };

          final overrides = await buildAppOverrides();

          runApp(ProviderScope(overrides: overrides, child: const App()));
        },
        (error, stackTrace) {
          // In production, errors could be reported to an error tracking service
          // such as Sentry or Firebase Crashlytics.
          debugPrint(error.toString());
        },
      ) ??
      Future<void>.value();
}

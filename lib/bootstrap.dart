import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void bootstrap() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
      };

      runApp(const ProviderScope(child: App()));
    },
    (error, stackTrace) {
      // In production, errors could be reported to an error tracking service
      // (ex: Sentry, Firebase Crashlytics)
      debugPrint(error.toString());
    },
  );
}

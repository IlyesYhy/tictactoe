import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared infrastructure provider for the resolved [SharedPreferences]
/// instance. Bootstrapped once at app launch and consumed by any feature that
/// needs local key-value storage.
///
/// Reads will crash by design if it has not been overridden before `runApp`,
/// so missing wiring fails fast rather than silently.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at app startup.',
  );
});

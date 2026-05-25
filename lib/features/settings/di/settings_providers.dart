import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/local_settings_repository.dart';
import '../domain/repositories/settings_repository.dart';

/// Bootstrapped at app launch with the resolved [SharedPreferences] instance.
///
/// Reads will crash by design if it has not been overridden before `runApp`,
/// so missing wiring fails fast rather than silently.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at app startup.',
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return LocalSettingsRepository(ref.watch(sharedPreferencesProvider));
});

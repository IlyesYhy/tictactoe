import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/local_settings_repository.dart';
import '../domain/entities/app_settings.dart';
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

/// Initial [AppSettings] resolved at bootstrap from persisted preferences.
///
/// Reads will crash by design if it has not been overridden before `runApp`,
/// so missing wiring fails fast rather than silently.
final initialSettingsProvider = Provider<AppSettings>((ref) {
  throw UnimplementedError(
    'initialSettingsProvider must be overridden at app startup.',
  );
});

/// Bootstrapped at app launch with the resolved [PackageInfo] instance.
///
/// Reads will crash by design if it has not been overridden before `runApp`,
/// so missing wiring fails fast rather than silently.
final packageInfoProvider = Provider<PackageInfo>((ref) {
  throw UnimplementedError(
    'packageInfoProvider must be overridden at app startup.',
  );
});

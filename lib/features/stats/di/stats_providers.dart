import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/shared_preferences_provider.dart';
import '../data/repositories/local_stats_repository.dart';
import '../domain/entities/match_history.dart';
import '../domain/repositories/stats_repository.dart';

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return LocalStatsRepository(ref.watch(sharedPreferencesProvider));
});

/// Initial [MatchHistory] resolved at bootstrap from persisted matches.
///
/// Reads will crash by design if it has not been overridden before `runApp`,
/// so missing wiring fails fast rather than silently.
final initialMatchHistoryProvider = Provider<MatchHistory>((ref) {
  throw UnimplementedError(
    'initialMatchHistoryProvider must be overridden at app startup.',
  );
});

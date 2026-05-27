import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/stats/presentation/controllers/stats_controller.dart';
import '../integrations/game_stats_recorder.dart';

/// Clock indirection so tests can inject a stable timestamp instead of
/// the system clock. Production resolves to [DateTime.now].
final currentDateTimeProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final gameStatsRecorderProvider = Provider<GameStatsRecorder>((ref) {
  return GameStatsRecorder(
    addMatch: (match) =>
        ref.read(statsControllerProvider.notifier).addMatch(match),
    now: ref.watch(currentDateTimeProvider),
  );
});

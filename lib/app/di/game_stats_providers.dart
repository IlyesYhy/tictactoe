import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/current_date_time_provider.dart';
import '../../features/stats/presentation/controllers/stats_controller.dart';
import '../integrations/game_stats_recorder.dart';

final gameStatsRecorderProvider = Provider<GameStatsRecorder>((ref) {
  return GameStatsRecorder(
    addMatch: (match) =>
        ref.read(statsControllerProvider.notifier).addMatch(match),
    now: ref.watch(currentDateTimeProvider),
  );
});

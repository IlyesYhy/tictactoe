import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/stats_providers.dart';
import '../../domain/entities/completed_match.dart';
import '../../domain/entities/match_history.dart';

final statsControllerProvider = NotifierProvider<StatsController, MatchHistory>(
  StatsController.new,
);

final class StatsController extends Notifier<MatchHistory> {
  @override
  MatchHistory build() {
    return ref.read(initialMatchHistoryProvider);
  }

  /// Persists [match] and appends it to the in-memory history on success.
  ///
  /// Persists first, then updates the state on success. If the repository
  /// throws, the state is left untouched so the UI never shows a match that
  /// was lost before being saved.
  Future<void> addMatch(CompletedMatch match) async {
    await ref.read(statsRepositoryProvider).recordMatch(match);
    state = MatchHistory([...state.matches, match]);
  }
}
